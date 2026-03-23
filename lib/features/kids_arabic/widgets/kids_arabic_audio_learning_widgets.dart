import 'dart:async';

import 'package:flutter/material.dart';

class KidsArabicRepeatAfterMeCard extends StatefulWidget {
  const KidsArabicRepeatAfterMeCard({
    super.key,
    required this.autoplayToken,
    required this.displayText,
    required this.title,
    required this.subtitle,
    required this.listenLabel,
    required this.repeatPromptLabel,
    required this.onPlay,
    this.autoplayEnabled = false,
    this.textDirection = TextDirection.rtl,
  });

  final String autoplayToken;
  final String displayText;
  final String title;
  final String subtitle;
  final String listenLabel;
  final String repeatPromptLabel;
  final Future<void> Function() onPlay;
  final bool autoplayEnabled;
  final TextDirection textDirection;

  @override
  State<KidsArabicRepeatAfterMeCard> createState() =>
      _KidsArabicRepeatAfterMeCardState();
}

class _KidsArabicRepeatAfterMeCardState
    extends State<KidsArabicRepeatAfterMeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  );
  String? _lastAutoplayToken;
  bool _isPlaying = false;
  bool _showRepeatPrompt = false;

  @override
  void initState() {
    super.initState();
    _maybeAutoplay();
  }

  @override
  void didUpdateWidget(covariant KidsArabicRepeatAfterMeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.autoplayToken != widget.autoplayToken) {
      _lastAutoplayToken = null;
      _showRepeatPrompt = false;
    }
    _maybeAutoplay();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _maybeAutoplay() {
    if (!widget.autoplayEnabled || _lastAutoplayToken == widget.autoplayToken) {
      return;
    }
    _lastAutoplayToken = widget.autoplayToken;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(_play());
    });
  }

  Future<void> _play() async {
    if (_isPlaying) {
      return;
    }
    setState(() {
      _isPlaying = true;
      _showRepeatPrompt = false;
    });
    _pulseController
      ..stop()
      ..forward(from: 0);
    try {
      await widget.onPlay();
    } catch (_) {
      // Keep the learning flow calm even if TTS fails.
    } finally {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _showRepeatPrompt = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: _isPlaying ? const Color(0xFFF1F6FF) : const Color(0xFFF8F2E8),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _isPlaying ? const Color(0xFFC8D8F3) : const Color(0xFFE5D5C1),
        ),
        boxShadow: _isPlaying
            ? const [
                BoxShadow(
                  color: Color(0x149E84D8),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ]
            : const [],
      ),
      child: InkWell(
        onTap: _play,
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2E261F),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.subtitle,
                style: const TextStyle(color: Color(0xFF675B4E), height: 1.35),
              ),
              const SizedBox(height: 14),
              Center(
                child: FadeTransition(
                  opacity: Tween<double>(
                    begin: 1,
                    end: 0.78,
                  ).animate(_pulseController),
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 1, end: 1.04).animate(
                      CurvedAnimation(
                        parent: _pulseController,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: Text(
                      widget.displayText,
                      textDirection: widget.textDirection,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'Noto Naskh Arabic',
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5E462A),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _showRepeatPrompt
                    ? Container(
                        key: const ValueKey('repeat-prompt'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6E6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFD4E4C0)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.record_voice_over_rounded,
                              size: 18,
                              color: Color(0xFF64873B),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.repeatPromptLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF52713A),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(key: ValueKey('repeat-empty')),
              ),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: _play,
                icon: Icon(
                  _isPlaying
                      ? Icons.volume_up_rounded
                      : Icons.play_circle_outline_rounded,
                ),
                label: Text(widget.listenLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KidsArabicAudioChipButton extends StatefulWidget {
  const KidsArabicAudioChipButton({
    super.key,
    required this.label,
    required this.onPlay,
  });

  final String label;
  final Future<void> Function() onPlay;

  @override
  State<KidsArabicAudioChipButton> createState() =>
      _KidsArabicAudioChipButtonState();
}

class _KidsArabicAudioChipButtonState extends State<KidsArabicAudioChipButton> {
  bool _isPlaying = false;

  Future<void> _play() async {
    if (_isPlaying) {
      return;
    }
    setState(() {
      _isPlaying = true;
    });
    try {
      await widget.onPlay();
    } catch (_) {
      // Keep tap-to-hear resilient if TTS fails.
    } finally {
      if (mounted) {
        setState(() {
          _isPlaying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: _isPlaying ? const Color(0xFFEAF4FF) : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: _isPlaying ? const Color(0xFFC8D8F3) : const Color(0xFFE2D2BC),
        ),
      ),
      child: InkWell(
        onTap: _play,
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _isPlaying
                    ? Icons.volume_up_rounded
                    : Icons.play_circle_outline_rounded,
                size: 18,
                color: const Color(0xFF6B583F),
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF6B583F),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
