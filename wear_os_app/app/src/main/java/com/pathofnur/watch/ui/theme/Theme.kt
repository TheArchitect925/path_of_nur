package com.pathofnur.watch.ui.theme

import androidx.compose.runtime.Composable
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.Colors
import androidx.compose.ui.graphics.Color

private val WatchColors = Colors(
    primary = Color(0xFFD6BD80),
    primaryVariant = Color(0xFFD6BD80),
    secondary = Color(0xFF8FAFD9),
    secondaryVariant = Color(0xFF8FAFD9),
    background = Color(0xFF090B12),
    surface = Color(0xFF171B27),
    error = Color(0xFFCF6679),
    onPrimary = Color.Black,
    onSecondary = Color.Black,
    onBackground = Color.White,
    onSurface = Color.White,
    onError = Color.Black
)

@Composable
fun PathOfNurWatchTheme(content: @Composable () -> Unit) {
    MaterialTheme(colors = WatchColors, content = content)
}
