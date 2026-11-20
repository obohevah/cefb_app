import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';

/// Short, elegant splash screen presenting the official Christ Embassy
/// Farmers Branch gold crest seal with smooth scale, glow, and fade animation.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _glowAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _scaleAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.65, curve: Curves.easeIn),
      ),
    );

    _glowAnimation = Tween<double>(begin: 0.3, end: 0.85).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOutSine),
      ),
    );

    _controller.forward();

    // Short transition timer: ~1.85 seconds total for a snappy, premium feel
    _navigationTimer = Timer(const Duration(milliseconds: 1850), _navigateToHome);
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isCompact = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF0C091C),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF160B2C),
                  Color(0xFF0D0B1E),
                  Color(0xFF070510),
                ],
              ),
            ),
          ),

          // Central Radiant Ambient Glow
          Center(
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  width: 280,
                  height: 280,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFD4AF37)
                            .withValues(alpha: 0.18 * _glowAnimation.value),
                        blurRadius: 90,
                        spreadRadius: 20,
                      ),
                      BoxShadow(
                        color: const Color(0xFF8628E2)
                            .withValues(alpha: 0.25 * _glowAnimation.value),
                        blurRadius: 110,
                        spreadRadius: 30,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Main Animated Logo & Title Content
          SafeArea(
            child: Center(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: child,
                    ),
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Official Gold Crest Seal
                    Container(
                      width: isCompact ? 130 : 160,
                      height: isCompact ? 130 : 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.45),
                            blurRadius: 24,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: const Color(0xFFFFD700)
                                .withValues(alpha: 0.22),
                            blurRadius: 35,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.church_rounded,
                            size: 80,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: isCompact ? 22 : 28),

                    // Primary Church Name
                    Text(
                      'CHRIST EMBASSY',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: isCompact ? 20 : 23,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 3.2,
                      ),
                    ),
                    const SizedBox(height: 5),

                    // Gold Accent Location Subtitle
                    Text(
                      'FARMERS BRANCH',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFFFFC107),
                        fontSize: isCompact ? 13 : 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 4.5,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Subtle Accent Divider Line
                    Container(
                      width: 50,
                      height: 2.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0x00FFD700),
                            Color(0xFFFFD700),
                            Color(0x00FFD700),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Inspiring Motto Tagline
                    Text(
                      'Giving Your Life A Meaning',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontSize: isCompact ? 12 : 13.5,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Subtle Loading Indicator
          Positioned(
            bottom: 36,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 38,
                height: 38,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    const Color(0xFFFFD700).withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
