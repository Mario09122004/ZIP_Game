import 'dart:math' as math;
import 'package:material_ui/material_ui.dart';

/// Overlay de confeti festivo que cae suavemente desde la parte superior
/// de la pantalla al completar un nivel con éxito.
class ConfettiOverlay extends StatefulWidget {
  const ConfettiOverlay({
    super.key,
    this.particleCount = 70,
    this.duration = const Duration(milliseconds: 3500),
  });

  final int particleCount;
  final Duration duration;

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<_ConfettiParticle> _particles;
  final math.Random _random = math.Random();

  static const List<Color> _palette = [
    Color(0xFFFF5252), // Rojo coral
    Color(0xFFFFD700), // Oro
    Color(0xFF00E676), // Verde esmeralda
    Color(0xFF00B0FF), // Azul brillante
    Color(0xFFE040FB), // Magenta vívido
    Color(0xFFFF6D00), // Naranja
    Color(0xFF7C4DFF), // Violeta
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);

    _particles = List.generate(widget.particleCount, (index) {
      return _ConfettiParticle(
        relativeX: _random.nextDouble(),
        startDelay: _random.nextDouble() * 0.35,
        speed: 0.75 + _random.nextDouble() * 0.55,
        size: 7.0 + _random.nextDouble() * 8.0,
        aspectRatio: 0.4 + _random.nextDouble() * 0.7,
        color: _palette[_random.nextInt(_palette.length)],
        rotationSpeed: (_random.nextDouble() - 0.5) * 6.0,
        swayAmplitude: 14.0 + _random.nextDouble() * 24.0,
        swayFrequency: 2.0 + _random.nextDouble() * 2.5,
        swayPhase: _random.nextDouble() * math.pi * 2,
        isCircle: _random.nextDouble() > 0.7,
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CustomPaint(
          key: const Key('confetti_canvas'),
          painter: _ConfettiPainter(
            particles: _particles,
            progress: _controller.value,
          ),
          size: Size.infinite,
        );
      },
    );
  }
}

class _ConfettiParticle {
  _ConfettiParticle({
    required this.relativeX,
    required this.startDelay,
    required this.speed,
    required this.size,
    required this.aspectRatio,
    required this.color,
    required this.rotationSpeed,
    required this.swayAmplitude,
    required this.swayFrequency,
    required this.swayPhase,
    required this.isCircle,
  });

  final double relativeX;
  final double startDelay;
  final double speed;
  final double size;
  final double aspectRatio;
  final Color color;
  final double rotationSpeed;
  final double swayAmplitude;
  final double swayFrequency;
  final double swayPhase;
  final bool isCircle;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.progress});

  final List<_ConfettiParticle> particles;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    for (final p in particles) {
      if (progress < p.startDelay) continue;

      final t = (progress - p.startDelay) / (1.0 - p.startDelay);
      if (t < 0 || t > 1) continue;

      // Desvanecimiento suave al final
      final double opacity = t > 0.82 ? (1.0 - t) / 0.18 : 1.0;
      final paint = Paint()
        ..color = p.color.withValues(alpha: opacity.clamp(0.0, 1.0))
        ..style = PaintingStyle.fill;

      // Movimiento vertical de arriba hacia abajo
      final y = -25.0 + t * (size.height + 70.0) * p.speed;
      if (y > size.height + 35) continue;

      // Balanceo lateral suave (viento)
      final sway = math.sin(p.swayPhase + t * math.pi * 2 * p.swayFrequency) * p.swayAmplitude;
      final x = p.relativeX * size.width + sway;

      // Rotación y giro 3D (tumble)
      final angle = t * p.rotationSpeed * math.pi * 2;
      final flipScale = math.cos(angle * 1.6).abs();

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        final w = p.size;
        final h = p.size * p.aspectRatio * flipScale.clamp(0.12, 1.0);
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: w, height: h),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) =>
      oldDelegate.progress != progress;
}

