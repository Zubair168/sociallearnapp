import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/features/auth/screens/login_screen.dart';
import 'package:sociallearnapp/features/auth/screens/register_screen.dart';
import 'package:sociallearnapp/shared/widgets/support_chip.dart';

enum UserRole { student, teacher, coach, parent }

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  UserRole _selectedRole = UserRole.student;
  bool _showingPanel = false;

  void _onContinue() {
    setState(() {
      _showingPanel = true;
    });
  }

  void _onBack() {
    setState(() {
      _showingPanel = false;
    });
  }

  void _goToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _goToSignup() {
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
          child: _showingPanel ? _buildRolePanel() : _buildRoleSelection(),
        ),
      ),
    );
  }

  // ─── 1. Role Selection Screen (First Screen) ──────────────────────────────

  Widget _buildRoleSelection() {
    return Column(
      key: const ValueKey('role_selection'),
      children: [
        // ── Top Blue Header with Brand Title & Testimonials ──
        Expanded(
          child: Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                // Brand Name centered closely above cards
                const Text(
                  'EduVerse',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 12),

                // Testimonial Cards Stack
                Expanded(
                  flex: 6,
                  child: Image.asset(
                    'assets/images/Frame 1261155657.png',
                    width: double.infinity,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ).animate().fadeIn(duration: 400.ms),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),

        // ── Bottom White Card ──
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome title + Support Chip (with Expanded to prevent overflow)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Text(
                      'Welcome to EduVerse',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2A3BD4),
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const SupportChip(),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Lets get to know you',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 16),

              // 4 Role Options with exact Radio design
              _buildRoleRadio(
                title: 'I am Student preparing for YKS',
                role: UserRole.student,
              ),
              const SizedBox(height: 10),
              _buildRoleRadio(
                title: 'I am teacher',
                role: UserRole.teacher,
              ),
              const SizedBox(height: 10),
              _buildRoleRadio(
                title: 'I am student coach',
                role: UserRole.coach,
              ),
              const SizedBox(height: 10),
              _buildRoleRadio(
                title: 'I am parent',
                role: UserRole.parent,
              ),
              const SizedBox(height: 20),

              // Continue Button
              GestureDetector(
                onTap: _onContinue,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3BD4),
                    borderRadius: BorderRadius.circular(14),
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

  Widget _buildRoleRadio({required String title, required UserRole role}) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEDF0FB) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF7489EE) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            // Checkmark or Radio Icon
            isSelected
                ? Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF22C55E),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  )
                : Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 2.0,
                      ),
                    ),
                  ),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? const Color(0xFF2A3BD4) : const Color(0xFF334155),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 2. Role Panel Screen ──────────────────────────────────────────────────

  Widget _buildRolePanel() {
    final info = _getRoleInfo(_selectedRole);

    return Column(
      key: ValueKey('role_panel_${_selectedRole.name}'),
      children: [
        // Top Header with brand name and exact Role Illustration
        Expanded(
          child: Container(
            width: double.infinity,
            color: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                // Centered EduVerse Logo
                const Text(
                  'EduVerse',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 12),

                // Role SVG Illustration
                Expanded(
                  flex: 6,
                  child: SvgPicture.asset(
                    info.svgAsset,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                  ).animate().fadeIn(duration: 350.ms).slideY(
                        begin: 0.08,
                        end: 0,
                        duration: 350.ms,
                        curve: Curves.easeOut,
                      ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          ),
        ),

        // Bottom White Card
        Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar: < Back and Support Chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _onBack,
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_rounded,
                            size: 14, color: AppColors.primary),
                        SizedBox(width: 4),
                        Text(
                          'Back',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SupportChip(),
                ],
              ),
              const SizedBox(height: 14),

              // Title and Description
              Text(
                info.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                info.description,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey.shade600,
                  fontFamily: 'Poppins',
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),

              // Login Button
              GestureDetector(
                onTap: _goToLogin,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_outline_rounded,
                          color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Login',
                        style: TextStyle(
                          color: AppColors.primary,
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

              // Signup Button
              GestureDetector(
                onTap: _goToSignup,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add_outlined,
                          color: AppColors.primary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Signup',
                        style: TextStyle(
                          color: AppColors.primary,
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

  _RolePanelInfo _getRoleInfo(UserRole role) {
    switch (role) {
      case UserRole.teacher:
        return _RolePanelInfo(
          title: 'Teacher Panel',
          description: 'Teacher Portal - Your teaching tools, all in one place.',
          svgAsset: 'assets/images/Frame (14).svg',
        );
      case UserRole.coach:
        return _RolePanelInfo(
          title: 'Student Coach Panel',
          description: 'Teacher Portal - Your teaching tools, all in one place.',
          svgAsset: 'assets/images/Frame (15).svg',
        );
      case UserRole.parent:
        return _RolePanelInfo(
          title: 'Parent Panel',
          description: 'Teacher Portal - Your teaching tools, all in one place.',
          svgAsset: 'assets/images/Frame (17).svg',
        );
      case UserRole.student:
        return _RolePanelInfo(
          title: 'Lets Start',
          description: 'Teacher Portal - Your teaching tools, all in one place.',
          svgAsset: 'assets/images/Frame (18).svg',
        );
    }
  }
}

class _RolePanelInfo {
  final String title;
  final String description;
  final String svgAsset;

  _RolePanelInfo({
    required this.title,
    required this.description,
    required this.svgAsset,
  });
}
