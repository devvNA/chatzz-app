import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: controller,
      builder: (context) {
        return const Scaffold(body: _SplashContent());
      },
    );
  }
}

class _SplashContent extends StatefulWidget {
  const _SplashContent();

  @override
  State<_SplashContent> createState() => _SplashContentState();
}

class _SplashContentState extends State<_SplashContent>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _breathingController;
  late AnimationController _logoController;
  late AnimationController _shimmerController;
  late AnimationController _particleController;
  late AnimationController _loadingController;

  // Animations
  late Animation<double> _breathingAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _taglineAnimation;
  late Animation<double> _loadingAnimation;

  // Particle positions
  final List<_Particle> _particles = [];
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _initParticles();
    _initAnimations();
    _startAnimations();
  }

  void _initParticles() {
    for (int i = 0; i < 15; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 20 + 10,
          speed: _random.nextDouble() * 0.3 + 0.1,
          opacity: _random.nextDouble() * 0.3 + 0.1,
          delay: _random.nextDouble(),
        ),
      );
    }
  }

  void _initAnimations() {
    // Breathing background animation (continuous)
    _breathingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _logoOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );

    // Shimmer animation (continuous)
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _shimmerController, curve: Curves.easeInOut),
    );

    // Tagline animation
    _taglineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Particle animation (continuous)
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // Loading animation
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _loadingAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.linear),
    );
  }

  void _startAnimations() {
    // Start logo animation after a short delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _logoController.forward();
      }
    });
  }

  @override
  void dispose() {
    _breathingController.dispose();
    _logoController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedBuilder(
      animation: Listenable.merge([
        _breathingController,
        _logoController,
        _shimmerController,
        _particleController,
        _loadingController,
      ]),
      builder: (context, child) {
        return Stack(
          children: [
            // Animated gradient background
            _buildAnimatedBackground(size),

            // Floating particles
            ..._buildParticles(size),

            // Decorative blobs
            _buildDecorativeBlobs(size),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Logo with animations
                  _buildAnimatedLogo(),

                  const SizedBox(height: 16),

                  // Tagline
                  _buildTagline(),

                  const Spacer(flex: 2),

                  // Custom loading indicator
                  _buildLoadingIndicator(),

                  const SizedBox(height: 40),

                  // Version text
                  _buildVersionText(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnimatedBackground(Size size) {
    final breathValue = _breathingAnimation.value;

    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.lerp(
              const Color(0xFF5DC286),
              const Color(0xFF4DB87A),
              breathValue,
            )!,
            Color.lerp(
              const Color(0xFF00B089),
              const Color(0xFF009E7A),
              breathValue,
            )!,
            Color.lerp(
              const Color(0xFF007A5E),
              const Color(0xFF006B52),
              breathValue,
            )!,
          ],
          stops: [0.0 + (breathValue * 0.1), 0.5, 1.0 - (breathValue * 0.1)],
        ),
      ),
    );
  }

  List<Widget> _buildParticles(Size size) {
    return _particles.map((particle) {
      final animValue = (_particleController.value + particle.delay) % 1.0;
      final y = (particle.y - animValue * particle.speed * 3) % 1.2 - 0.1;

      return Positioned(
        left: particle.x * size.width,
        top: y * size.height,
        child: _buildChatBubbleParticle(particle),
      );
    }).toList();
  }

  Widget _buildChatBubbleParticle(_Particle particle) {
    return Opacity(
      opacity: particle.opacity,
      child: Container(
        width: particle.size,
        height: particle.size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(particle.size / 2),
            topRight: Radius.circular(particle.size / 2),
            bottomRight: Radius.circular(particle.size / 2),
            bottomLeft: Radius.circular(particle.size / 6),
          ),
        ),
      ),
    );
  }

  Widget _buildDecorativeBlobs(Size size) {
    final breathValue = _breathingAnimation.value;

    return Stack(
      children: [
        // Top right blob
        Positioned(
          top: -size.height * 0.15,
          right: -size.width * 0.2,
          child: Transform.scale(
            scale: 1.0 + (breathValue * 0.1),
            child: Container(
              width: size.width * 0.6,
              height: size.width * 0.6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom left blob
        Positioned(
          bottom: -size.height * 0.1,
          left: -size.width * 0.25,
          child: Transform.scale(
            scale: 1.0 + ((1 - breathValue) * 0.1),
            child: Container(
              width: size.width * 0.7,
              height: size.width * 0.7,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.1),
                    Colors.white.withValues(alpha: 0.03),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Center glow behind logo
        Positioned(
          top: size.height * 0.35,
          left: size.width * 0.2,
          child: Container(
            width: size.width * 0.6,
            height: size.width * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.15 + (breathValue * 0.05)),
                  Colors.white.withValues(alpha: 0.05),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnimatedLogo() {
    return Transform.scale(
      scale: _logoScaleAnimation.value,
      child: Opacity(
        opacity: _logoOpacityAnimation.value,
        child: Column(
          children: [
            // Logo image with glow
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.25),
                    blurRadius: 50,
                    spreadRadius: 15,
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/app-logo.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Logo text with shimmer
            ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [Colors.white, Colors.white70, Colors.white],
                  stops: [
                    _shimmerAnimation.value - 0.3,
                    _shimmerAnimation.value,
                    _shimmerAnimation.value + 0.3,
                  ].map((s) => s.clamp(0.0, 1.0)).toList(),
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: const Text(
                'Chatzz',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 2,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagline() {
    return Opacity(
      opacity: _taglineAnimation.value,
      child: Transform.translate(
        offset: Offset(0, 20 * (1 - _taglineAnimation.value)),
        child: Text(
          'Connect instantly',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.8),
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Outer rotating ring
          Transform.rotate(
            angle: _loadingAnimation.value * 2 * math.pi,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2),
                  width: 2,
                ),
              ),
              child: CustomPaint(
                painter: _ArcPainter(
                  progress: _loadingAnimation.value,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Inner pulsing dot
          Transform.scale(
            scale: 0.8 + (_breathingAnimation.value * 0.2),
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionText() {
    return Opacity(
      opacity: _taglineAnimation.value * 0.6,
      child: Text(
        'v1.0.0',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.white.withValues(alpha: 0.5),
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// Particle data class
class _Particle {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double opacity;
  final double delay;

  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
    required this.delay,
  });
}

// Custom arc painter for loading indicator
class _ArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _ArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const startAngle = -math.pi / 2;
    const sweepAngle = math.pi * 0.7;

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ArcPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
