package com.pathofnur.watch

import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.runtime.*
import androidx.compose.ui.platform.LocalContext
import androidx.wear.compose.material.*
import androidx.lifecycle.lifecycleScope
import com.pathofnur.watch.data.WatchRepository
import com.pathofnur.watch.domain.DhikrMode
import com.pathofnur.watch.domain.DhikrInteractionMode
import com.pathofnur.watch.dhikr.WearDhikrHapticEngine
import com.pathofnur.watch.dhikr.WearDhikrPulseEngine
import com.pathofnur.watch.quran.StubWearQuranPlaybackBridge
import com.pathofnur.watch.quran.WearListeningModeController
import com.pathofnur.watch.quran.WearLocalAudioPlayer
import com.pathofnur.watch.quran.WearQuranPlaybackController
import com.pathofnur.watch.ui.screens.DhikrScreen
import com.pathofnur.watch.ui.screens.PrayersScreen
import com.pathofnur.watch.ui.screens.ProgressScreen
import com.pathofnur.watch.ui.screens.QuranOutputScreen
import com.pathofnur.watch.ui.screens.QuranPlayerScreen
import com.pathofnur.watch.ui.screens.TodayScreen
import com.pathofnur.watch.ui.screens.WearListeningModeScreen
import com.pathofnur.watch.ui.theme.PathOfNurWatchTheme
import com.pathofnur.watch.notifications.WearPrayerNotificationScheduler
import com.pathofnur.watch.refresh.WearBackgroundRefreshCoordinator
import com.pathofnur.watch.tiles.TileRoutes

class MainActivity : ComponentActivity() {
    private val pulseEngine = WearDhikrPulseEngine()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            PathOfNurWatchTheme {
                val context = LocalContext.current
                val dhikrHaptics = remember { WearDhikrHapticEngine(context) }
                val repository = remember { WatchRepository(context) }
                val refreshCoordinator = remember { WearBackgroundRefreshCoordinator(context) }
                val quranController = remember {
                    WearQuranPlaybackController(
                        repository = repository,
                        bridge = StubWearQuranPlaybackBridge(),
                        localAudioPlayer = WearLocalAudioPlayer()
                    )
                }
                LaunchedEffect(Unit) {
                    refreshCoordinator.appLaunch()
                    quranController.refreshFromPhone()
                }
                val tileAction = remember {
                    intent?.data?.getQueryParameter("tileAction")
                }
                var screen by remember {
                    mutableStateOf(
                        intent?.getStringExtra(TileRoutes.EXTRA_SCREEN)
                            ?: intent?.data?.lastPathSegment
                            ?: if (repository.quranPlayback().isPlaying) "quran_listening" else TileRoutes.SCREEN_TODAY
                    )
                }
                var refreshKey by remember { mutableIntStateOf(0) }
                val snapshot by remember(refreshKey) { mutableStateOf(repository.snapshot()) }
                val prayers by remember(refreshKey) { mutableStateOf(repository.prayers()) }
                val dhikr by remember(refreshKey) { mutableStateOf(repository.dhikrSession()) }
                val queue by remember(refreshKey) { mutableStateOf(repository.queue()) }
                val quranPlayback by remember(refreshKey) { mutableStateOf(repository.quranPlayback()) }
                val quranAvailability by remember(refreshKey) { mutableStateOf(repository.quranAudioAvailability()) }

                LaunchedEffect(tileAction) {
                    when (tileAction) {
                        "increment" -> {
                            repository.incrementDhikr()?.let { outcome ->
                                dhikrHaptics.play(outcome.milestone)
                                refreshCoordinator.dhikrUpdate()
                                refreshKey += 1
                            }
                        }
                        "reset" -> {
                            repository.resetDhikrSession()
                            refreshCoordinator.dhikrUpdate()
                            refreshKey += 1
                        }
                    }
                }

                Scaffold(
                    timeText = { TimeText() },
                    vignette = { Vignette(vignettePosition = VignettePosition.TopAndBottom) },
                    positionIndicator = { PositionIndicator() }
                ) {
                    ScalingLazyColumn {
                        item {
                            when (screen) {
                                "today" -> TodayScreen(
                                    snapshot = snapshot,
                                    onPrayers = { screen = "prayers" },
                                    onDhikr = { screen = "dhikr" },
                                    onProgress = { screen = "progress" },
                                    onQuran = { screen = "quran" }
                                )
                                "prayers" -> PrayersScreen(
                                    prayers = prayers,
                                    onToggle = {
                                        repository.togglePrayer(it)
                                        WearPrayerNotificationScheduler(context).refreshSchedules()
                                        refreshCoordinator.prayerCompletion()
                                        refreshKey += 1
                                    },
                                    onBack = { screen = "today" }
                                )
                                "dhikr" -> DhikrScreen(
                                    session = dhikr,
                                    todayTotal = snapshot.dhikrTodayCount,
                                    onIncrement = {
                                        repository.incrementDhikr()?.let { outcome ->
                                            if (repository.dhikrSession().interactionMode == DhikrInteractionMode.SilentTap) {
                                                dhikrHaptics.playConfirmation()
                                            }
                                            dhikrHaptics.play(outcome.milestone)
                                            refreshCoordinator.dhikrUpdate()
                                            refreshKey += 1
                                        }
                                    },
                                    onMode = {
                                        repository.startDhikrSession(it)
                                        refreshCoordinator.dhikrUpdate()
                                        refreshKey += 1
                                    },
                                    onInteractionMode = {
                                        repository.startDhikrSession(repository.dhikrSession().mode)
                                        repository.setDhikrInteractionMode(it)
                                        pulseEngine.stop()
                                        refreshCoordinator.dhikrUpdate()
                                        refreshKey += 1
                                    },
                                    onPulseFaster = {
                                        val allowed = repository.updateGuidedPulseFaster()
                                        refreshKey += 1
                                        allowed
                                    },
                                    onPulseSlower = {
                                        repository.updateGuidedPulseSlower()
                                        refreshKey += 1
                                    },
                                    onPulseResetSteady = {
                                        repository.resetGuidedPaceToSteady()
                                        refreshKey += 1
                                    },
                                    onGuidedStart = {
                                        repository.setGuidedPulseRunning(true)
                                        pulseEngine.start(lifecycleScope, repository.dhikrSession().pulseIntervalSeconds ?: 2.5) {
                                            dhikrHaptics.playGuidancePulse()
                                            repository.incrementDhikr()?.let { outcome ->
                                                dhikrHaptics.play(outcome.milestone)
                                                if (outcome.session.completed) {
                                                    pulseEngine.stop()
                                                    repository.setGuidedPulseRunning(false)
                                                }
                                            }
                                            refreshCoordinator.dhikrUpdate()
                                            refreshKey += 1
                                        }
                                        refreshKey += 1
                                    },
                                    onGuidedPause = {
                                        pulseEngine.stop()
                                        repository.setGuidedPulseRunning(false)
                                        refreshKey += 1
                                    },
                                    onGuidedStop = {
                                        pulseEngine.stop()
                                        repository.setGuidedPulseRunning(false)
                                        refreshKey += 1
                                    },
                                    onReset = {
                                        pulseEngine.stop()
                                        repository.resetDhikrSession()
                                        refreshCoordinator.dhikrUpdate()
                                        refreshKey += 1
                                    },
                                    onBack = { screen = "today" }
                                )
                                "quran" -> QuranPlayerScreen(
                                    snapshot = quranPlayback,
                                    availability = quranAvailability,
                                    onCommand = {
                                        quranController.sendCommand(it)
                                        refreshKey += 1
                                    },
                                    onOutput = { screen = "quran_output" },
                                    onListeningMode = { screen = "quran_listening" },
                                    onBack = { screen = "today" }
                                )
                                "quran_listening" -> WearListeningModeScreen(
                                    snapshot = quranPlayback,
                                    phoneReachable = quranController.isPhoneReachable(),
                                    onCommand = {
                                        quranController.sendCommand(it)
                                        refreshKey += 1
                                    },
                                    onPlayer = { screen = "quran" }
                                )
                                "quran_output" -> QuranOutputScreen(
                                    currentSource = quranPlayback.sourceType,
                                    availability = quranAvailability,
                                    onSelectPhone = {
                                        quranController.sendCommand(com.pathofnur.watch.domain.QuranPlaybackCommand.SwitchOutputPhone)
                                        screen = "quran"
                                        refreshKey += 1
                                    },
                                    onSelectWatch = {
                                        quranController.sendCommand(com.pathofnur.watch.domain.QuranPlaybackCommand.SwitchOutputWatch)
                                        screen = "quran"
                                        refreshKey += 1
                                    },
                                    onBack = { screen = "quran" }
                                )
                                else -> ProgressScreen(
                                    snapshot = snapshot,
                                    queue = queue,
                                    onBack = { screen = "today" }
                                )
                            }
                        }
                    }
                }

                LaunchedEffect(quranPlayback.isPlaying, quranPlayback.lastUpdatedAt) {
                    if (WearListeningModeController.shouldAutoActivate(quranPlayback) &&
                        (screen == "today" || screen == "quran")) {
                        screen = "quran_listening"
                    } else if (!quranPlayback.isPlaying && screen == "quran_listening") {
                        screen = "quran"
                    }
                }
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
    }

    override fun onResume() {
        super.onResume()
    }
}
