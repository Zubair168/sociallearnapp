import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/core/constants/app_text_styles.dart';
import 'package:sociallearnapp/features/auth/screens/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Learn From\nExperts",
      subtitle:
          "Access world-class courses taught by industry experts. Learn at your own pace, anytime anywhere.",
      illustration: _OnboardingIllustration1(),
      bgColor: const Color(0xFF3B4CE8),
      accentColor: const Color(0xFF6B7BF0),
    ),
    OnboardingData(
      title: "Browse & Enroll\nin Courses",
      subtitle:
          "Explore thousands of courses across categories. Enroll with one tap and start learning immediately.",
      illustration: _OnboardingIllustration2(),
      bgColor: const Color(0xFF00BCD4),
      accentColor: const Color(0xFF4DD0E1),
    ),
    OnboardingData(
      title: "Track Your\nProgress",
      subtitle:
          "Monitor your learning journey. Complete lessons, earn certificates and grow your skills every day.",
      illustration: _OnboardingIllustration3(),
      bgColor: const Color(0xFF3B4CE8),
      accentColor: const Color(0xFF6B7BF0),
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _OnboardingPage(data: _pages[index]);
            },
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 40),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Dots
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: WormEffect(
              dotWidth: 8,
              dotHeight: 8,
              activeDotColor: AppColors.primary,
              dotColor: AppColors.border,
              spacing: 6,
            ),
          ),
          const SizedBox(height: 28),

          // Next / Get Started Button
          GestureDetector(
            onTap: _nextPage,
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _currentPage == _pages.length - 1
                        ? 'Get Started'
                        : 'Continue',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded,
                      color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Skip
          if (_currentPage < _pages.length - 1)
            GestureDetector(
              onTap: _goToLogin,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final Widget illustration;
  final Color bgColor;
  final Color accentColor;

  const OnboardingData({
    required this.title,
    required this.subtitle,
    required this.illustration,
    required this.bgColor,
    required this.accentColor,
  });
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        // Blue header with illustration
        Container(
          height: size.height * 0.48,
          width: double.infinity,
          decoration: BoxDecoration(
            color: data.bgColor,
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: data.accentColor.withOpacity(0.3),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
              // Illustration center
              Center(child: data.illustration)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.1, end: 0),
            ],
          ),
        ),

        // White content area
        Expanded(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title, style: AppTextStyles.onboardingTitle)
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideX(begin: -0.1, end: 0),
                const SizedBox(height: 12),
                Text(data.subtitle, style: AppTextStyles.onboardingSubtitle)
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms),
              ],
            ),
          ),
        ),

        // Space for bottom controls
        const SizedBox(height: 140),
      ],
    );
  }
}

// ─── Real SVG Illustrations from Design ───────────────────────────────────

class _OnboardingIllustration1 extends StatelessWidget {
  const _OnboardingIllustration1();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: SvgPicture.asset(
        'assets/images/Book lover-bro 1.svg',
        height: 240,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _OnboardingIllustration2 extends StatelessWidget {
  const _OnboardingIllustration2();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: SvgPicture.asset(
        'assets/images/Attached files-bro (1) 1.svg',
        height: 240,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _OnboardingIllustration3 extends StatelessWidget {
  const _OnboardingIllustration3();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: SvgPicture.asset(
        'assets/images/Studying-bro 1.svg',
        height: 240,
        fit: BoxFit.contain,
      ),
    );
  }
}
