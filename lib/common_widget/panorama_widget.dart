import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:panorama_image/panorama_image.dart';

class PanoramaWidget extends StatefulWidget {
  final ImageProvider image;
  final double degPerSecond; // speed

  const PanoramaWidget({Key? key, required this.image, this.degPerSecond = 6.0}) : super(key: key);

  @override
  State<PanoramaWidget> createState() => _PanoramaWidgetState();
}

class _PanoramaWidgetState extends State<PanoramaWidget> with SingleTickerProviderStateMixin {
  final PanoramaController _panController = PanoramaController();
  late final Ticker _ticker;
  DateTime _lastTick = DateTime.now();
  bool _userInteracting = false;
  Timer? _resumeTimer;
  double _longitude = 0.0;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted || _userInteracting) {
      _lastTick = DateTime.now();
      return;
    }

    final now = DateTime.now();
    final dt = now.difference(_lastTick).inMilliseconds / 1000.0;
    _lastTick = now;

    // Move right to left → subtract
    _longitude = (_longitude + widget.degPerSecond * dt) % 360.0;
    if (_longitude < 0) _longitude += 360.0;

    _panController.updateView(longitude: _longitude);
  }

  void _onUserInteractionStart() {
    _userInteracting = true;
    _resumeTimer?.cancel();
  }

  void _onUserInteractionEnd() {
    _resumeTimer?.cancel();
    _resumeTimer = Timer(const Duration(seconds: 2), () {
      _userInteracting = false;
      _lastTick = DateTime.now();
    });
  }

  @override
  void dispose() {
    _resumeTimer?.cancel();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: (_) => _onUserInteractionStart(),
      onPanStart: (_) => _onUserInteractionStart(),
      onPanEnd: (_) => _onUserInteractionEnd(),
      onTapDown: (_) => _onUserInteractionStart(),
      onTapUp: (_) => _onUserInteractionEnd(),
      child: PanoramaViewer(
        minFOV: 10,
        image: widget.image,
        controller: _panController,
        onViewChanged: (details) {
          _longitude = details.longitude;
        },
      ),
    );
  }
}
