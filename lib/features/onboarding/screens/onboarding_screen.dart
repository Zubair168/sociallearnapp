import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/features/home/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Step 2 — Profile
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  int _selectedCourse = 0; // 0 = 2025, 1 = 2026

  // Step 3 — Goal
  int _selectedGoal = -1; // 0=Easy,1=Medium,2=Challenging,3=Custom
  int _customGoal = 10;

  // Step 4 — Branch
  int _selectedBranch = 0; // 0=TYT

  final List<String> _branches = [
    'TYT',
    'Quantitative',
    'Verbal',
    'Equal Weight',
    'Foreign Language',
    "I'm not sure yet",
  ];

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _finishOnboarding() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [
                _buildWelcomePage(),
                _buildProfilePage(),
                _buildGoalPage(),
                _buildBranchPage(),
                _buildNotificationsPage(),
              ],
            ),
          ),
          // Dot indicator
          if (_currentPage > 0)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final active = (i == _currentPage - 1);
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primary
                          : AppColors.primary.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  // ─── PAGE 1: Welcome ──────────────────────────────────────────────────────

  Widget _buildWelcomePage() {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const Spacer(flex: 1),
              // Illustration
              SvgPicture.asset(
                'assets/images/Attached files-bro (1) 1.svg',
                height: 280,
                fit: BoxFit.contain,
              ).animate().fadeIn(duration: 400.ms),
              const Spacer(flex: 1),
              // Title
              const Text(
                'Welcome to EduVerse',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2A3BD4),
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              // Subtitle
              Text(
                'EduVerse allows users to solve\nquestions directly on their mobile devices',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade500,
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(flex: 2),
              // Button
              GestureDetector(
                onTap: _nextPage,
                child: Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3BD4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded,
                          color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // ─── PAGE 2: Profile ─────────────────────────────────────────────────────

  Widget _buildProfilePage() {
    return Column(
      children: [
        // Top Blue Header with Book lover illustration
        Expanded(
          flex: 4,
          child: Container(
            width: double.infinity,
            color: AppColors.primary,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SvgPicture.asset(
                'assets/images/Book lover-bro 1.svg',
                height: 240,
                fit: BoxFit.contain,
              ).animate().fadeIn(duration: 400.ms),
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
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Let’s get yo know you',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2A3BD4),
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Please fill in the details below to get started',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.grey.shade500,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 18),

              // Name
              const Text(
                'Name',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameCtrl,
                style: const TextStyle(fontSize: 13.5, fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2A3BD4), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Surname
              const Text(
                'Surname',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _surnameCtrl,
                style: const TextStyle(fontSize: 13.5, fontFamily: 'Poppins'),
                decoration: InputDecoration(
                  hintText: 'Enter your surname',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFF2A3BD4), width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Course
              const Text(
                'Course',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),

              // 2 horizontal course chips matching screenshot
              Row(
                children: [
                  Expanded(
                    child: _buildCourseSelectionChip(
                      label: 'YKS 2025',
                      isSelected: _selectedCourse == 0,
                      onTap: () => setState(() => _selectedCourse = 0),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCourseSelectionChip(
                      label: 'YKS 2026',
                      isSelected: _selectedCourse == 1,
                      onTap: () => setState(() => _selectedCourse = 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Continue Button
              GestureDetector(
                onTap: _nextPage,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A3BD4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.center,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.chevron_right_rounded,
                          color: Colors.white, size: 20),
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

  Widget _buildCourseSelectionChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF22C55E) : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color:
                  isSelected ? const Color(0xFF22C55E) : Colors.grey.shade300,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF2A3BD4)
                    : const Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── PAGE 3: Define Goal ─────────────────────────────────────────────────

  Widget _buildGoalPage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/images/Attached files-bro (1) 1 (1).svg',
                height: 180,
                fit: BoxFit.contain,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Lets Define Goal',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                'You can change the goal later on settings',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            _GoalOption(
              label: 'Easy Start',
              sub: '20 questions per day',
              selected: _selectedGoal == 0,
              onTap: () => setState(() => _selectedGoal = 0),
            ),
            const SizedBox(height: 12),
            _GoalOption(
              label: 'Medium Level',
              sub: '40 questions per day',
              selected: _selectedGoal == 1,
              onTap: () => setState(() => _selectedGoal = 1),
            ),
            const SizedBox(height: 12),
            _GoalOption(
              label: 'Challenging',
              sub: '60 questions per day',
              selected: _selectedGoal == 2,
              onTap: () => setState(() => _selectedGoal = 2),
            ),
            const SizedBox(height: 12),
            // Custom goal panel
            GestureDetector(
              onTap: () => setState(() => _selectedGoal = 3),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: _selectedGoal == 3
                      ? AppColors.primary.withValues(alpha: 0.06)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: _selectedGoal == 3
                        ? AppColors.primary
                        : Colors.grey.shade200,
                    width: _selectedGoal == 3 ? 2 : 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          _selectedGoal == 3
                              ? Icons.check_circle_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: _selectedGoal == 3
                              ? AppColors.green
                              : Colors.grey.shade400,
                          size: 20,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Define you own goal',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _selectedGoal == 3
                                ? AppColors.primary
                                : Colors.grey.shade700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        'You can change the goal later on settings',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    if (_selectedGoal == 3) ...[
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _CircleIconButton(
                            icon: Icons.remove_rounded,
                            onTap: () {
                              if (_customGoal > 1) {
                                setState(() => _customGoal--);
                              }
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Text(
                              '$_customGoal',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                          _CircleIconButton(
                            icon: Icons.add_rounded,
                            onTap: () => setState(() => _customGoal++),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            _PrimaryButton(label: 'Save', onTap: _nextPage),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: _nextPage,
                child: Text(
                  "I'll do it Later",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── PAGE 4: Branch ──────────────────────────────────────────────────────

  Widget _buildBranchPage() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/images/Layer_1.svg',
                height: 160,
                fit: BoxFit.contain,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Branch',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Text(
                'Let us know which brand are you preparing for',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(_branches.length, (i) {
              final selected = _selectedBranch == i;
              return GestureDetector(
                onTap: () => setState(() => _selectedBranch = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 12),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: selected
                        ? AppColors.primary.withValues(alpha: 0.06)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          selected ? AppColors.primary : Colors.grey.shade200,
                      width: selected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        selected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: selected
                            ? AppColors.green
                            : Colors.grey.shade400,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _branches[i],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: selected
                              ? AppColors.primary
                              : Colors.grey.shade700,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            _PrimaryButton(label: 'Save', onTap: _nextPage),
          ],
        ),
      ),
    );
  }

  // ─── PAGE 5: Notifications ───────────────────────────────────────────────

  Widget _buildNotificationsPage() {
    final features = [
      'Daily practice suggestions',
      'Session reminders',
      'Deadline alerts',
      'Motivation boosts',
    ];
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 36),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SvgPicture.asset(
                'assets/images/Frame (14).svg',
                height: 200,
                fit: BoxFit.contain,
              ),
            ).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Stay on Track with Smart\nReminders',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  fontFamily: 'Poppins',
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                "We'll send you helpful study nudges — just when you need them.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 28),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: AppColors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_rounded,
                            color: Colors.white, size: 14),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        f,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 14, color: Colors.grey),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'We promise not to spam. Just the right push at the right time',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            _PrimaryButton(
              label: 'Allow Notifications',
              onTap: _finishOnboarding,
            ),
            const SizedBox(height: 12),
            Center(
              child: GestureDetector(
                onTap: _finishOnboarding,
                child: Text(
                  "I'll do it Later",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Shared Widgets ──────────────────────────────────────────────────────────

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        alignment: Alignment.center,
        child: Text(
          '$label  ›',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  final String label;
  final String sub;
  final bool selected;
  final VoidCallback onTap;

  const _GoalOption({
    required this.label,
    required this.sub,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.06)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade200,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color:
                      selected ? AppColors.primary : Colors.grey.shade400,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    color: selected
                        ? AppColors.primary
                        : Colors.grey.shade700,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            Text(
              sub,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, size: 18, color: Colors.grey.shade700),
      ),
    );
  }
}
