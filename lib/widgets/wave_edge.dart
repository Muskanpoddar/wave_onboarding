// lib/widgets/wave_edge.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';

enum WaveSide { left, right }

class EdgeWave extends StatelessWidget {
  final Animation<double> time;
  final double intensity;
  final WaveSide side;
  final Color edgeColor;
  final Color innerColor;
  final double devicePixelRatio;
  final double phaseBias;

  const EdgeWave({
    super.key,
    required this.time,
    required this.intensity,
    required this.side,
    required this.edgeColor,
    required this.innerColor,
    required this.devicePixelRatio,
    required this.phaseBias,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: time,
      builder: (_, _) => CustomPaint(
        painter: _EdgeWavePainter(
          t: time.value,
          k: intensity,
          side: side,
          edge: edgeColor,
          inner: innerColor,
          dpr: devicePixelRatio,
          phaseBias: phaseBias,
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _EdgeWavePainter extends CustomPainter {
  final double t;
  final double k;
  final WaveSide side;
  final Color edge;
  final Color inner;
  final double dpr;
  final double phaseBias;

  _EdgeWavePainter({
    required this.t,
    required this.k,
    required this.side,
    required this.edge,
    required this.inner,
    required this.dpr,
    required this.phaseBias,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final thickness = 40.0 * (0.25 + 0.75 * k);
    final baseAmp = 11.0 * (0.35 + 0.65 * k);
    final waveLen = size.height / 2.0;
    final flow =
        t * 0.85 + phaseBias * 0.35 * (side == WaveSide.right ? 1.0 : -1.0);
    final phase = 2 * math.pi * flow;
    final step = math.max(1.0, 3.0 / dpr);

    double fx(double y) {
      final a1 = baseAmp;
      final a2 = baseAmp * 0.6;
      final a3 = baseAmp * 0.32;
      final s1 = math.sin((2 * math.pi * y / waveLen) + phase);
      final s2 = math.sin((2 * math.pi * y / (waveLen * 0.7)) - phase * 1.4);
      final s3 = math.sin((2 * math.pi * y / (waveLen * 1.6)) + phase * 2.1);
      return thickness + a1 * s1 + a2 * s2 + a3 * s3;
    }

    final path = Path();
    if (side == WaveSide.left) {
      path.moveTo(0, 0);
      for (double y = 0; y <= size.height; y += step) {
        final x = fx(y).clamp(0.0, size.width);
        path.lineTo(x, y);
      }
      path.lineTo(0, size.height);
      path.close();
    } else {
      path.moveTo(size.width, 0);
      for (double y = 0; y <= size.height; y += step) {
        final x = (size.width - fx(y)).clamp(0.0, size.width);
        path.lineTo(x, y);
      }
      path.lineTo(size.width, size.height);
      path.close();
    }

    final widthForGrad = (thickness + baseAmp * 2.4).clamp(24.0, size.width);
    final rect = side == WaveSide.left
        ? Rect.fromLTWH(0, 0, widthForGrad, size.height)
        : Rect.fromLTWH(
            size.width - widthForGrad,
            0,
            widthForGrad,
            size.height,
          );

    final grad = LinearGradient(
      begin: side == WaveSide.left
          ? Alignment.centerLeft
          : Alignment.centerRight,
      end: side == WaveSide.left ? Alignment.centerRight : Alignment.centerLeft,
      colors: [
        edge,
        Color.alphaBlend(inner.withOpacity(0.8), edge.withOpacity(0.2)),
        inner.withOpacity(0.4),
        inner.withOpacity(0.0),
      ],
      stops: const [0.0, 0.35, 0.7, 1.0],
    ).createShader(rect);

    final wavePaint = Paint()
      ..shader = grad
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.medium
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1.0 * dpr);

    canvas.drawPath(path, wavePaint);

    final crest = Path();
    final crestShift = 10 * (0.3 + 0.7 * k);
    if (side == WaveSide.left) {
      crest.moveTo(0, 0);
      for (double y = 0; y <= size.height; y += step) {
        final x = (fx(y) - crestShift).clamp(0.0, size.width);
        crest.lineTo(x, y);
      }
      crest.lineTo(0, size.height);
      crest.close();
    } else {
      crest.moveTo(size.width, 0);
      for (double y = 0; y <= size.height; y += step) {
        final x = (size.width - (fx(y) - crestShift)).clamp(0.0, size.width);
        crest.lineTo(x, y);
      }
      crest.lineTo(size.width, size.height);
      crest.close();
    }

    final crestPaint = Paint()
      ..shader = LinearGradient(
        begin: side == WaveSide.left
            ? Alignment.centerLeft
            : Alignment.centerRight,
        end: side == WaveSide.left
            ? Alignment.centerRight
            : Alignment.centerLeft,
        colors: [
          edge.withOpacity(0.95),
          inner.withOpacity(0.55),
          inner.withOpacity(0.0),
        ],
        stops: const [0.0, 0.45, 1.0],
      ).createShader(rect)
      ..isAntiAlias = true
      ..filterQuality = FilterQuality.low
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 0.6 * dpr);

    canvas.drawPath(crest, crestPaint);
  }

  @override
  bool shouldRepaint(covariant _EdgeWavePainter old) {
    const tol = 0.0008;
    return (old.t - t).abs() > tol ||
        (old.k - k).abs() > tol ||
        old.side != side ||
        old.edge != edge ||
        old.inner != inner ||
        old.dpr != dpr ||
        (old.phaseBias - phaseBias).abs() > tol;
  }
}
