import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/core/constants/app_text_styles.dart';
import 'package:sociallearnapp/features/auth/screens/login_screen.dart';
import 'package:sociallearnapp/features/auth/screens/register_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _selectedRole = 0; // 0: Student, 1: Teacher, 2: Student Coach, 3: Parent
  bool _showPanel = false;

  final List<Map<String, dynamic>> _roles = [
    {
      'title': 'I am Student preparing for YKS',
      'panelTitle': 'Lets Start',
      'panelSubtitle': 'Your learning tools, all in one place.',
      'image': 'assets/images/Studying-bro 1.svg',
    },
    {
      'title': 'I am teacher',
      'panelTitle': 'Teacher Panel',
      'panelSubtitle': 'Teacher Portal – Your teaching tools, all in one place.',
      'image': 'assets/images/Attached files-bro (1) 1.svg',
    },
    {
      'title': 'I am student coach',
      'panelTitle': 'Student Coach Panel',
      'panelSubtitle': 'Coach Portal – Track and guide students easily.',
      'image': 'assets/images/Book lover-bro 1.svg',
    },
    {
      'title': 'I am parent',
      'panelTitle': 'Parent Panel',
      'panelSubtitle': 'Parent Portal – Monitor and support your student.',
      'image': 'assets/images/Attached files-bro (1) 1 (1).svg',
    },
  ];

  void _onContinue() {
    setState(() {
      _showPanel = true;
    });
  }

  void _onBack() {
    setState(() {
      _showPanel = false;
    });
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _showPanel
              ? _buildRolePanelScreen(context)
              : _buildRoleSelectionScreen(context),
        ),
      ),
    );
  }

  // ─── 1. Role Selection Screen (Screenshot 1, Top Left) ─────────────────────
  Widget _buildRoleSelectionScreen(BuildContext context) {
    return Column(
      key: const ValueKey('role_selection'),
      children: [
        // Top section with TUDU logo & Testimonial Badges
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                // TUDU Logo
                const Text(
                  'TUDU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontFamily: 'Poppins',
                  ),
                ).animate().fadeIn(duration: 400.ms),
                const SizedBox(height: 24),

                // Review Cards
                _buildReviewCard(
                  name: 'Merve',
                  stars: 5,
                  comment: "1 ayda TYT'de 20 net arttırdım",
                  avatarLetter: 'M',
                ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1),
                const SizedBox(height: 10),

                _buildReviewCard(
                  name: 'Berk',
                  stars: 5,
                  comment: 'Tartışmasız en iyi YKS uygulaması',
                  avatarLetter: 'B',
                ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),
                const SizedBox(height: 10),

                _buildReviewCard(
                  name: null,
                  stars: 5,
                  comment: "İlk 100'e derecemi TUDU'ya borçluyum",
                  avatarLetter: '⭐',
                ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.1),
              ],
            ),
          ),
        ),

        // Bottom white card with role options
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with support chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Welcome to TUDU',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Let\'s get to know you',
                        style: AppTextStyles.caption.copyWith(fontSize: 12),
                      ),
                    ],
                  ),
                  _buildSupportChip(),
                ],
              ),
              const SizedBox(height: 20),

              // Role radio items
              ...List.generate(_roles.length, (index) {
                final selected = _selectedRole == index;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedRole = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary.withOpacity(0.04)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : AppColors.border,
                          width: selected ? 1.8 : 1.2,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Radio circle
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected
                                  ? const Color(0xFF4CAF50)
                                  : Colors.transparent,
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF4CAF50)
                                    : AppColors.border,
                                width: 2,
                              ),
                            ),
                            child: selected
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 14)
                                : null,
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              _roles[index]['title'],
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: selected
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 14),

              // Continue Button
              GestureDetector(
                onTap: _onContinue,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── 2. Role Panel Screen (Screenshot 1: Teacher/Coach/Parent Panel) ────────
  Widget _buildRolePanelScreen(BuildContext context) {
    final roleData = _roles[_selectedRole];

    return Column(
      key: const ValueKey('role_panel'),
      children: [
        // Top section with Illustration
        Expanded(
          flex: 5,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'TUDU',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SvgPicture.asset(
                    roleData['image'],
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Bottom white card with Login / Signup options
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Back link & Support
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _onBack,
                    child: const Row(
                      children: [
                        Icon(Icons.chevron_left,
                            color: AppColors.textPrimary, size: 20),
                        SizedBox(width: 4),
                        Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSupportChip(),
                ],
              ),
              const SizedBox(height: 16),

              // Title & Subtitle
              Text(
                roleData['panelTitle'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                roleData['panelSubtitle'],
                style: AppTextStyles.caption.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 24),

              // Login Button (Card style)
              GestureDetector(
                onTap: _goToLogin,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline_rounded,
                          color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Signup Button (Card style)
              GestureDetector(
                onTap: _goToRegister,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border, width: 1.5),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_outlined,
                          color: AppColors.primary, size: 20),
                      SizedBox(width: 10),
                      Text(
                        'Signup',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Support Chip Widget ──────────────────────────────────────────────────
  Widget _buildSupportChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_bubble_outline_rounded,
              color: Color(0xFF2E7D32), size: 14),
          SizedBox(width: 4),
          Text(
            'Support',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  // ─── Review Card Widget ───────────────────────────────────────────────────
  Widget _buildReviewCard({
    String? name,
    required int stars,
    required String comment,
    required String avatarLetter,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white.withOpacity(0.25),
            child: Text(
              avatarLetter,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (name != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Row(
                        children: List.generate(
                          stars,
                          (_) => const Icon(Icons.star_rounded,
                              color: Color(0xFFFFD700), size: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                ] else ...[
                  Row(
                    children: List.generate(
                      stars,
                      (_) => const Icon(Icons.star_rounded,
                          color: Color(0xFFFFD700), size: 14),
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                Text(
                  comment,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
