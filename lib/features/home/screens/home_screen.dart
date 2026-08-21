import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/courses/screens/courses_screen.dart';
import 'package:sociallearnapp/features/courses/screens/favorited_questions_screen.dart';
import 'package:sociallearnapp/features/courses/screens/smart_study_plan_screen.dart';
import 'package:sociallearnapp/features/courses/screens/trial_exams_screen.dart';
import 'package:sociallearnapp/features/stats/screens/stats_screen.dart';
import 'package:sociallearnapp/features/video/screens/video_player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Onboarding tasks tracking
  final List<Map<String, dynamic>> _onboardingTasks = [
    {'title': 'Set your study goal', 'icon': Icons.track_changes_rounded, 'done': true},
    {'title': 'Solve one test', 'icon': Icons.description_outlined, 'done': true},
    {'title': 'Solve one "0 mistake" test', 'icon': Icons.fact_check_outlined, 'done': true},
    {'title': 'Solve one mock exam (deneme)', 'icon': Icons.assignment_outlined, 'done': false},
    {'title': 'Add a favorite or mistaken question', 'icon': Icons.star_border_rounded, 'done': false},
  ];

  // Survey state
  int _selectedSurveyOption = 3; // Social media
  final List<String> _surveyOptions = [
    'Play Store / App Store',
    'Friends',
    'Teachers or Mentors',
    'Social Media (Instagram, TikTok)',
    'YouTube',
    'Other',
  ];

  // Tour state
  bool _showingTour = false;
  int _tourStep = 0;
  static bool _hasShownInitialTour = false;

  // Drawer expandable state
  bool _questionsExpanded = false;
  bool _printedBooksExpanded = false;

  @override
  void initState() {
    super.initState();
    // Automatically show survey dialog once, then tour overlay
    if (!_hasShownInitialTour) {
      _hasShownInitialTour = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            _showSurveyDialog(
              onCompleted: () {
                if (mounted) {
                  setState(() {
                    _showingTour = true;
                    _tourStep = 0;
                  });
                }
              },
            );
          }
        });
      });
    }
  }

  String _formatCurrentDate() {
    final now = DateTime.now();
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final weekday = weekdays[now.weekday - 1];
    final day = now.day.toString().padLeft(2, '0');
    final month = months[now.month - 1];
    return '$weekday, $day $month';
  }

  int get _completedTasksCount =>
      _onboardingTasks.where((t) => t['done'] == true).length;

  double get _tasksProgress =>
      _completedTasksCount / _onboardingTasks.length;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F8FC),
      drawer: _buildDrawer(user, auth),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedTab,
            children: [
              _buildDashboard(user),
              CoursesScreen(
                onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
              ),
              _buildSolvedQuestionsTab(),
              StatsScreen(
                onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
                onSolveQuestions: () => setState(() => _selectedTab = 1),
              ),
            ],
          ),
          // Interactive Tour Overlay
          if (_showingTour) _buildTourOverlay(),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }


  // ─── Main Dashboard ─────────────────────────────────────────────────────────

  Widget _buildDashboard(User? user) {
    final name = user?.displayName?.split(' ').first ?? 'Harsh';
    final dateStr = _formatCurrentDate();

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 1. Top Bar ──────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Menu & Greeting
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: const Icon(
                        Icons.notes_rounded,
                        color: AppColors.textPrimary,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dateStr,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Welcome back, $name',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Right Actions: Bell with red dot + Avatar
                Row(
                  children: [
                    // Notification Bell
                    GestureDetector(
                      onTap: _showYearlyPlannerDialog,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            color: Color(0xFF1E293B),
                            size: 26,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 9,
                              height: 9,
                              decoration: const BoxDecoration(
                                color: Color(0xFFEF4444),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Avatar
                    GestureDetector(
                      onTap: () => _scaffoldKey.currentState?.openDrawer(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFE2E8F0),
                          image: user?.photoURL != null
                              ? DecorationImage(
                                  image: NetworkImage(user!.photoURL!),
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: NetworkImage(
                                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 16),

            // ── 2. Top Stats Row (Days Until Exam & Daily Goal) ──────────────
            Row(
              children: [
                // Days until exam
                Expanded(
                  child: GestureDetector(
                    onTap: _showOnboardingTasksSheet,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Days Until Exam',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.calendar_today_rounded,
                                    color: AppColors.primary, size: 18),
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                '16',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Daily Goal Card matching Screenshot
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFF1F5F9)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Blue Target Icon
                        Container(
                          width: 38,
                          height: 38,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEFF4FF),
                          ),
                          child: const Icon(
                            Icons.track_changes_rounded,
                            color: Color(0xFF2A3BD4),
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Daily Goal',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: Colors.grey.shade500,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Icon(
                                    Icons.edit_outlined,
                                    size: 13,
                                    color: Colors.grey.shade400,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              RichText(
                                text: const TextSpan(
                                  text: '10 ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E293B),
                                    fontFamily: 'Poppins',
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Questions',
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF64748B),
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: const LinearProgressIndicator(
                                  value: 0.45,
                                  minHeight: 4,
                                  backgroundColor: Color(0xFFE2E8F0),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF2A3BD4),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 14),

            // ── 4. My Plan Card (Empty State) ────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'My Plan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SmartStudyPlanScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              'Plan Details',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(Icons.chevron_right_rounded,
                                size: 16, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Checklist icon in grey circle
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3F9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.assignment_outlined,
                        color: Colors.grey.shade400, size: 24),
                  ),
                  const SizedBox(height: 10),

                  const Text(
                    'No Active Study Plan',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 14),

                  GestureDetector(
                    onTap: _showYearlyPlannerDialog,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 9),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'Create a study plan',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
              ),
            ).animate().fadeIn(delay: 150.ms),

            const SizedBox(height: 14),

            // ── 5. 2x3 Grid Feature Cards (Empty States) ─────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // Coaching
                      _buildGridCard(
                        icon: Icons.record_voice_over_outlined,
                        title: 'Coaching',
                        content: Column(
                          children: [
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFF1F3F9),
                              child: Icon(Icons.person,
                                  color: Colors.grey.shade400, size: 22),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No Active Coach',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        btnText: 'Buy Coaching Package',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),

                      // Latest Rank
                      _buildGridCard(
                        icon: Icons.trending_up_rounded,
                        title: 'Your Latest Rank',
                        content: Column(
                          children: [
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFF1F3F9),
                              child: Icon(Icons.military_tech_outlined,
                                  color: Colors.grey.shade400, size: 22),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No Ranks Found',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        btnText: 'Calculate Rank',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),

                      // Video Lecture
                      _buildGridCard(
                        icon: Icons.videocam_outlined,
                        title: 'Video Lecture',
                        content: Column(
                          children: [
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFF1F3F9),
                              child: Icon(Icons.movie_creation_outlined,
                                  color: Colors.grey.shade400, size: 22),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No Lectures Watched',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        btnText: 'Go to Video Lectures',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VideoPlayerScreen(
                                title: 'Introductory Lecture',
                                videoUrl:
                                    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    children: [
                      // Study Templates
                      _buildGridCard(
                        icon: Icons.description_outlined,
                        title: 'Study Templates',
                        content: Column(
                          children: [
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFF1F3F9),
                              child: Icon(Icons.menu_book_outlined,
                                  color: Colors.grey.shade400, size: 22),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No Templates Found',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        btnText: 'View Study Templates',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),

                      // University Goal
                      _buildGridCard(
                        icon: Icons.school_outlined,
                        title: 'University Goal',
                        content: Column(
                          children: [
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFF1F3F9),
                              child: Icon(Icons.school_outlined,
                                  color: Colors.grey.shade400, size: 22),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No Preference List Found',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        btnText: 'Create Preference List',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12),

                      // Trial Exams
                      _buildGridCard(
                        icon: Icons.assignment_outlined,
                        title: 'Trial Exams',
                        content: Column(
                          children: [
                            const SizedBox(height: 8),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFFF1F3F9),
                              child: Icon(Icons.edit_note_outlined,
                                  color: Colors.grey.shade400, size: 22),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'No Trial Exams Taken',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                        btnText: 'Go to Trial Exams',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TrialExamsScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 14),

            // ── 6. Question Bank Banner ──────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5FE),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.menu_book_rounded,
                        color: Color(0xFF0288D1), size: 22),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      'Create a personalized Question Bank',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  Icon(Icons.chevron_right_rounded,
                      color: Colors.grey.shade400, size: 22),
                ],
              ),
            ).animate().fadeIn(delay: 250.ms),
          ],
        ),
      ),
    );
  }

  // ─── Modal 1: Onboarding Tasks Bottom Sheet ─────────────────────────────────

  void _showOnboardingTasksSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final allDone = _completedTasksCount == _onboardingTasks.length;
          final pct = (_tasksProgress * 100).toInt();

          return Container(
            padding: const EdgeInsets.fromLTRB(22, 16, 22, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top drag handle
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (allDone) ...[
                  // 100% Celebration Screen
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF50),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded,
                              color: Colors.white, size: 48),
                        ).animate().scale(duration: 400.ms, curve: Curves.elasticOut),
                        const SizedBox(height: 16),
                        const Text(
                          'You are all set to use EduVerse!',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "You're ready to enjoy personalized learning, question solving & exams.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              "Let's Go  ›",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Task list view
                  const Text(
                    "Let's Get Started",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "You're close to using EduVerse to its full potential. Complete some of the tasks to get most out of EduVerse",
                    style: TextStyle(
                      fontSize: 11.5,
                      color: Colors.grey.shade600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Progress bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: _tasksProgress,
                      backgroundColor: const Color(0xFFE8F5E9),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF4CAF50)),
                      minHeight: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Completed : $_completedTasksCount/${_onboardingTasks.length} ($pct%)',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Tasks items
                  ...List.generate(_onboardingTasks.length, (i) {
                    final item = _onboardingTasks[i];
                    final isDone = item['done'] == true;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _onboardingTasks[i]['done'] = !isDone;
                        });
                        setModalState(() {});
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDone
                              ? const Color(0xFFE8F5E9).withValues(alpha: 0.4)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDone
                                ? const Color(0xFF81C784)
                                : Colors.grey.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(item['icon'] as IconData,
                                size: 18, color: AppColors.primary),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item['title'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: isDone
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  color: isDone
                                      ? const Color(0xFF2E7D32)
                                      : AppColors.textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: isDone
                                    ? const Color(0xFF4CAF50)
                                    : AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                isDone
                                    ? Icons.check_rounded
                                    : Icons.chevron_right_rounded,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Modal 2: Yearly Planner Center Popup Dialog ────────────────────────────

  void _showYearlyPlannerDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon illustration
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.track_changes_rounded,
                    color: AppColors.primary, size: 40),
              ),
              const SizedBox(height: 16),

              const Text(
                'Ready to Achieve your Goals?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Based on your goals, EduVerse can design an exceptional personalized study system to help you reach your university dreams! Would you like to create a yearly study plan?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontFamily: 'Poppins',
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),

              // Yes, Create My Plan
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Yearly Plan created!'),
                      backgroundColor: AppColors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'Yes, Create My Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Maybe Later
              GestureDetector(
                onTap: () => Navigator.pop(ctx),
                child: Container(
                  width: double.infinity,
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Maybe Later',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Modal 3: Survey Popup Dialog (Dark Glass Overlay) ──────────────────────

  void _showSurveyDialog({VoidCallback? onCompleted}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2024),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      onCompleted?.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),

                const Text(
                  'Take a Quick Survey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Where did you hear about us?',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withValues(alpha: 0.7),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),

                // Radio options list
                ...List.generate(_surveyOptions.length, (i) {
                  final selected = _selectedSurveyOption == i;
                  return GestureDetector(
                    onTap: () {
                      setDialogState(() => _selectedSurveyOption = i);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF2C3036)
                            : const Color(0xFF23262B),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF4CAF50)
                              : Colors.white.withValues(alpha: 0.08),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked_rounded,
                            color: selected
                                ? const Color(0xFF4CAF50)
                                : Colors.white.withValues(alpha: 0.4),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              _surveyOptions[i],
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 10),

                // Submit button
                GestureDetector(
                  onTap: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Thank you for your feedback!'),
                        backgroundColor: AppColors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                    onCompleted?.call();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Modal 4: Instructing Screen (Feature Tour Overlay) ─────────────────────

  Widget _buildTourOverlay() {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: Colors.black.withValues(alpha: 0.60),
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Highlighted Daily Goal Card on top of overlay (Step 0)
            Positioned(
              top: 66,
              right: 18,
              left: (screenWidth / 2) + 6,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.25),
                      blurRadius: 16,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Blue Target Icon
                    Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEFF4FF),
                      ),
                      child: const Icon(
                        Icons.track_changes_rounded,
                        color: Color(0xFF2A3BD4),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Daily Goal',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Icon(
                                Icons.edit_outlined,
                                size: 13,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          RichText(
                            text: const TextSpan(
                              text: '10 ',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Poppins',
                              ),
                              children: [
                                TextSpan(
                                  text: 'Questions',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF64748B),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: const LinearProgressIndicator(
                              value: 0.45,
                              minHeight: 4,
                              backgroundColor: Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF2A3BD4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 2. Upward Triangle Pointer on top of the Tooltip
            Positioned(
              top: 150,
              right: 64,
              child: CustomPaint(
                size: const Size(18, 11),
                painter: _UpwardTrianglePainter(color: Colors.white),
              ),
            ),

            // 3. Instruction Popover Card (Matching Screenshot exactly)
            Positioned(
              top: 160,
              left: 18,
              right: 18,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Top Progress Indicator Line on the Card Border
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          width: ((screenWidth - 36) / 4) * (_tourStep + 1),
                          height: 3.5,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2A3BD4),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16),
                            ),
                          ),
                        ),
                      ),

                      // Card Content
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title + Close icon top right
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    _tourStep == 0
                                        ? 'View your daily study goal.'
                                        : _tourStep == 1
                                            ? 'Track days until exam.'
                                            : _tourStep == 2
                                                ? 'Resume active lessons.'
                                                : 'Personalized study plans.',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E293B),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => _showingTour = false),
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Description Text
                            Text(
                              _tourStep == 0
                                  ? 'Set your personalized goal and see your progress everyday.'
                                  : _tourStep == 1
                                      ? 'Stay on schedule with real-time countdown to exam date.'
                                      : _tourStep == 2
                                          ? 'Jump straight into practice questions and mock tests.'
                                          : 'Access curated mentor templates and targeted plans.',
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF475569),
                                fontFamily: 'Poppins',
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 22),

                            // Action Buttons: Skip Tour & Next
                            Row(
                              children: [
                                // Skip Tour Button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        setState(() => _showingTour = false),
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: const Color(0xFF2A3BD4),
                                          width: 1.3,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: const Text(
                                        'Skip Tour',
                                        style: TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2A3BD4),
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                // Next Button
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      if (_tourStep < 3) {
                                        setState(() => _tourStep++);
                                      } else {
                                        setState(() => _showingTour = false);
                                      }
                                    },
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF2A3BD4),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF2A3BD4)
                                                .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        _tourStep < 3 ? 'Next' : 'Finish',
                                        style: const TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 250.ms).slideY(begin: -0.05, end: 0),

            // 4. Stepper Dots Centered Below the Instruction Card
            Positioned(
              top: 362,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (i) {
                  final active = _tourStep == i;
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 16 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // ─── Grid Feature Card ─────────────────────────────────────────────────────

  Widget _buildGridCard({
    required IconData icon,
    required String title,
    required Widget content,
    required String btnText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontFamily: 'Poppins',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content,
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                btnText,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Solved Questions Tab ────────────────────────────────────────────────────

  Widget _buildSolvedQuestionsTab() {
    return _SolvedQuestionsTab(
      onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      onSolveQuestions: () => setState(() => _selectedTab = 1),
    );
  }

  // ─── Bottom Navigation ──────────────────────────────────────────────────────

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) => setState(() => _selectedTab = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 10,
          fontFamily: 'Poppins',
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Solve Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in_rounded),
            label: 'Solved Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Stats',
          ),
        ],
      ),
    );
  }

  // ─── Drawer ─────────────────────────────────────────────────────────────────

  Widget _buildDrawer(User? user, AuthService auth) {
    final name = user?.displayName ?? 'Harsh Jain';

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // 1. Profile Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE2E8F0),
                      border: Border.all(color: const Color(0xFFE0E7FF), width: 2),
                      image: user?.photoURL != null
                          ? DecorationImage(
                              image: NetworkImage(user!.photoURL!),
                              fit: BoxFit.cover,
                            )
                          : const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150',
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded,
                                size: 16, color: Colors.grey.shade600),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Member Since : Jun 2024',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade500,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 2. Menu Items (Scrollable)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Duels
                  _buildDrawerItem(
                    icon: Icons.sports_martial_arts_rounded,
                    title: 'Duels',
                    onTap: () => Navigator.pop(context),
                  ),

                  // Questions (Expandable)
                  _buildDrawerExpandableItem(
                    icon: Icons.assignment_outlined,
                    title: 'Questions',
                    isExpanded: _questionsExpanded,
                    onTap: () => setState(
                        () => _questionsExpanded = !_questionsExpanded),
                    children: [
                      _buildDrawerSubItem(
                        icon: Icons.star_border_rounded,
                        title: 'Favorite Questions',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const FavoritedQuestionsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildDrawerSubItem(
                        icon: Icons.close_rounded,
                        title: 'Incorrect Questions',
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildDrawerSubItem(
                        icon: Icons.info_outline_rounded,
                        title: 'Unattempted Questions',
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  // Printed Books (Expandable)
                  _buildDrawerExpandableItem(
                    icon: Icons.menu_book_outlined,
                    title: 'Printed Books',
                    isExpanded: _printedBooksExpanded,
                    onTap: () => setState(
                        () => _printedBooksExpanded = !_printedBooksExpanded),
                    children: [
                      _buildDrawerSubItem(
                        title: 'Create Personalized Question Bank',
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildDrawerSubItem(
                        title: 'Smart Books',
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildDrawerSubItem(
                        title: 'My Books & Orders',
                        onTap: () => Navigator.pop(context),
                      ),
                      _buildDrawerSubItem(
                        title: 'Check Answers',
                        onTap: () => Navigator.pop(context),
                      ),
                    ],
                  ),

                  // Summary Notes
                  _buildDrawerItem(
                    icon: Icons.edit_note_rounded,
                    title: 'Summary Notes',
                    onTap: () => Navigator.pop(context),
                  ),

                  // Study Plans
                  _buildDrawerItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Study Plans',
                    onTap: () => Navigator.pop(context),
                  ),

                  // AI Assistant
                  _buildDrawerItem(
                    icon: Icons.smart_toy_outlined,
                    title: 'AI Assistant',
                    onTap: () => Navigator.pop(context),
                  ),

                  // About
                  _buildDrawerItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // 3. Follow Us Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Follow us here',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Instagram
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1306C).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Color(0xFFE1306C), size: 15),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Instagram',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 18),

                      // TikTok
                      Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(Icons.music_note_rounded,
                                color: Colors.black, size: 15),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            'Tiktok',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 4. Logout Item
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFF1F5F9), width: 1),
                ),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFEF4444), width: 1.5),
                  ),
                  child: const Icon(Icons.logout_rounded,
                      color: Color(0xFFEF4444), size: 14),
                ),
                title: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                  ),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await auth.signOut();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade800, size: 20),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
          fontFamily: 'Poppins',
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      dense: true,
      onTap: onTap,
    );
  }

  Widget _buildDrawerExpandableItem({
    required IconData icon,
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<Widget> children,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.grey.shade800, size: 20),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
              fontFamily: 'Poppins',
            ),
          ),
          trailing: Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_rounded
                : Icons.keyboard_arrow_down_rounded,
            color: Colors.grey.shade600,
            size: 20,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
          dense: true,
          onTap: onTap,
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 36, bottom: 4),
            child: Column(children: children),
          ),
      ],
    );
  }

  Widget _buildDrawerSubItem({
    IconData? icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: icon != null
          ? Icon(icon, color: Colors.grey.shade600, size: 16)
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Colors.grey.shade700,
          fontFamily: 'Poppins',
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      dense: true,
      minLeadingWidth: 16,
      onTap: onTap,
    );
  }
}

class _UpwardTrianglePainter extends CustomPainter {
  final Color color;

  const _UpwardTrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Solved Questions Tab ─────────────────────────────────────────────────────

class _SolvedQuestionsTab extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onSolveQuestions;

  const _SolvedQuestionsTab({this.onOpenDrawer, this.onSolveQuestions});

  @override
  State<_SolvedQuestionsTab> createState() => _SolvedQuestionsTabState();
}

class _SolvedQuestionsTabState extends State<_SolvedQuestionsTab> {
  final bool _hasData = true;

  // Mock data grouped by day
  final List<Map<String, dynamic>> _days = [
    {
      'date': 'Today',
      'totalSolved': 48,
      'time': '04:26',
      'topicCount': 4,
      'correct': 40,
      'incorrect': 6,
      'unanswered': 2,
      'expanded': true,
      'avatars': 4,
      'tests': [
        {
          'title': 'Linear Equations that has a lon...',
          'subject': 'Mathematics',
          'type': 'TYT',
          'difficulty': 'Past Exam',
          'diffColor': 0xFFEF4444,
          'solved': 8,
          'time': '00:26',
          'correct': 8,
          'incorrect': 1,
          'unanswered': 1,
        },
        {
          'title': 'Algebra',
          'subject': 'Mathematics',
          'type': 'AYT',
          'difficulty': 'Easy',
          'diffColor': 0xFF22C55E,
          'solved': 8,
          'time': '00:26',
          'correct': 6,
          'incorrect': 1,
          'unanswered': 1,
        },
        {
          'title': 'Probability',
          'subject': 'Mathematics',
          'type': 'AYT',
          'difficulty': 'Easy',
          'diffColor': 0xFF22C55E,
          'solved': 8,
          'time': '00:26',
          'correct': 6,
          'incorrect': 1,
          'unanswered': 1,
        },
        {
          'title': 'Pythagoras',
          'subject': 'Mathematics',
          'type': 'AYT',
          'difficulty': 'Past Exam',
          'diffColor': 0xFFEF4444,
          'solved': 8,
          'time': '00:26',
          'correct': 6,
          'incorrect': 1,
          'unanswered': 1,
        },
      ],
    },
    {
      'date': 'Yesterday',
      'totalSolved': 48,
      'time': '04:26',
      'topicCount': 6,
      'correct': 40,
      'incorrect': 6,
      'unanswered': 2,
      'expanded': false,
      'avatars': 5,
      'tests': <Map<String, dynamic>>[],
    },
    {
      'date': '12 Jun 2025',
      'totalSolved': 48,
      'time': '04:26',
      'topicCount': 2,
      'correct': 40,
      'incorrect': 6,
      'unanswered': 2,
      'expanded': false,
      'avatars': 2,
      'tests': <Map<String, dynamic>>[],
    },
    {
      'date': '11 Jun 2025',
      'totalSolved': 48,
      'time': '04:26',
      'topicCount': 2,
      'correct': 40,
      'incorrect': 6,
      'unanswered': 2,
      'expanded': false,
      'avatars': 2,
      'tests': <Map<String, dynamic>>[],
    },
    {
      'date': '10 Jun 2025',
      'totalSolved': 48,
      'time': '04:26',
      'topicCount': 2,
      'correct': 40,
      'incorrect': 6,
      'unanswered': 2,
      'expanded': false,
      'avatars': 2,
      'tests': <Map<String, dynamic>>[],
    },
  ];

  String _formatCurrentDate() {
    final now = DateTime.now();
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${weekdays[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    final name = user?.displayName?.split(' ').first ?? 'Harsh';

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onOpenDrawer,
                        child: const Icon(Icons.notes_rounded,
                            size: 26, color: Color(0xFF1E293B)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(_formatCurrentDate(),
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                  fontFamily: 'Poppins')),
                          Text('Welcome back, $name',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2A3BD4),
                                  fontFamily: 'Poppins')),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.notifications_none_rounded,
                              color: Color(0xFF1E293B), size: 24),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  shape: BoxShape.circle),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: const Color(0xFFE2E8F0), width: 1.5),
                          image: user?.photoURL != null
                              ? DecorationImage(
                                  image: NetworkImage(user!.photoURL!),
                                  fit: BoxFit.cover)
                              : const DecorationImage(
                                  image: NetworkImage(
                                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150'),
                                  fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: _hasData ? _buildSolvedList() : _buildEmptyState(),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16)
              ],
            ),
            child: const Icon(Icons.assignment_outlined,
                size: 36, color: Color(0xFF2A3BD4)),
          ),
          const SizedBox(height: 22),
          const Text(
            'Start solving questions to see\nyour progress here.',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
                height: 1.4),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: widget.onSolveQuestions,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFF2A3BD4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: const Color(0xFF2A3BD4).withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4))
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_rounded,
                      color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text('Solve Questions',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  // ─── Solved List ──────────────────────────────────────────────────────────
  Widget _buildSolvedList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: _days.length,
      itemBuilder: (context, index) {
        final day = _days[index];
        return _buildDayCard(day, index);
      },
    );
  }

  Widget _buildDayCard(Map<String, dynamic> day, int dayIndex) {
    final expanded = day['expanded'] as bool;
    final tests = day['tests'] as List<Map<String, dynamic>>;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header (tappable to expand/collapse)
          GestureDetector(
            onTap: () =>
                setState(() => _days[dayIndex]['expanded'] = !expanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(day['date'] as String,
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1E293B),
                              fontFamily: 'Poppins')),
                      Icon(
                        expanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: const Color(0xFF94A3B8),
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Stats row
                  Row(
                    children: [
                      _miniStat(Icons.check_circle_outline_rounded,
                          '${day['totalSolved']} Solved',
                          const Color(0xFF64748B)),
                      const SizedBox(width: 10),
                      _miniStat(Icons.access_time_rounded,
                          day['time'] as String,
                          const Color(0xFF64748B)),
                      const SizedBox(width: 10),
                      // Avatar stack
                      SizedBox(
                        width: 40,
                        height: 20,
                        child: Stack(
                          children: List.generate(
                            (day['avatars'] as int).clamp(0, 3),
                            (i) => Positioned(
                              left: i * 12.0,
                              child: Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: [
                                    const Color(0xFF3B4CE8),
                                    const Color(0xFFF59E0B),
                                    const Color(0xFFEF4444),
                                  ][i % 3],
                                  border: Border.all(
                                      color: Colors.white, width: 1.5),
                                ),
                                child: const Icon(Icons.person,
                                    size: 11, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text('From ${day['topicCount']} Topics',
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                              fontFamily: 'Poppins')),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Correct / Incorrect / Unanswered pills
                  Row(
                    children: [
                      _resultPill(const Color(0xFF22C55E),
                          '${day['correct']} Correct'),
                      const SizedBox(width: 8),
                      _resultPill(const Color(0xFFEF4444),
                          '${day['incorrect']} Incorrect'),
                      const SizedBox(width: 8),
                      _resultPill(const Color(0xFFF59E0B),
                          '${day['unanswered']} Unanswered'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded tests
          if (expanded && tests.isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            ...tests.map((test) => _buildTestRow(test, dayIndex)),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _miniStat(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(text,
            style: TextStyle(
                fontSize: 11,
                color: color,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _resultPill(Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins')),
      ],
    );
  }

  Widget _buildTestRow(Map<String, dynamic> test, int dayIndex) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 6, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Test icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.description_outlined,
                size: 18, color: Color(0xFF64748B)),
          ),
          const SizedBox(width: 10),

          // Test details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(test['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Poppins')),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _tagChip(test['subject'] as String,
                        const Color(0xFFEDE9FE), const Color(0xFF7C3AED)),
                    const SizedBox(width: 6),
                    _tagChip(test['type'] as String,
                        const Color(0xFFDCFCE7), const Color(0xFF16A34A)),
                    const SizedBox(width: 6),
                    _tagChip(
                        test['difficulty'] as String,
                        Color(test['diffColor'] as int).withValues(alpha: 0.12),
                        Color(test['diffColor'] as int)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _miniStat(Icons.check_circle_outline_rounded,
                        '${test['solved']} Solved', const Color(0xFF64748B)),
                    const SizedBox(width: 10),
                    _miniStat(Icons.access_time_rounded,
                        test['time'] as String, const Color(0xFF64748B)),
                    const Spacer(),
                    // Small result dots
                    _dotCount(const Color(0xFF22C55E), test['correct'] as int),
                    const SizedBox(width: 4),
                    _dotCount(const Color(0xFFEF4444), test['incorrect'] as int),
                    const SizedBox(width: 4),
                    _dotCount(const Color(0xFFF59E0B), test['unanswered'] as int),
                  ],
                ),
              ],
            ),
          ),

          // 3-dot menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded,
                size: 18, color: Color(0xFF94A3B8)),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (val) {
              if (val == 'delete') {
                _showWarningDialog(
                  icon: Icons.delete_outline_rounded,
                  iconColor: const Color(0xFFEF4444),
                  title: 'Warning',
                  message:
                      'If you delete this test record, you will lose all related\nnotes, favorites, etc.',
                  actionText: 'Delete',
                  actionColor: const Color(0xFFEF4444),
                );
              } else if (val == 'resolve') {
                _showWarningDialog(
                  icon: Icons.refresh_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: 'Warning',
                  message:
                      'Are you sure you want to re-solve this test, you will lose all\nrelated notes, favorites, etc.',
                  actionText: 'Re-solve',
                  actionColor: const Color(0xFF2A3BD4),
                );
              }
            },
            itemBuilder: (_) => [
              _popupItem('view', Icons.visibility_outlined, 'View'),
              _popupItem('resolve', Icons.refresh_rounded, 'Solve Again'),
              _popupItem('delete', Icons.delete_outline_rounded, 'Delete'),
            ],
          ),
        ],
      ),
    );
  }

  PopupMenuItem<String> _popupItem(
      String value, IconData icon, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFF64748B)),
          const SizedBox(width: 10),
          Text(text,
              style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Poppins',
                  color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _tagChip(String text, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(text,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: fg,
              fontFamily: 'Poppins')),
    );
  }

  Widget _dotCount(Color color, int count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 2),
        Text('$count',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Poppins')),
      ],
    );
  }

  void _showWarningDialog({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String actionText,
    required Color actionColor,
  }) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (ctx) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: iconColor),
              ),
              const SizedBox(height: 16),
              Text(title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: iconColor,
                      fontFamily: 'Poppins')),
              const SizedBox(height: 10),
              Text(message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontFamily: 'Poppins',
                      height: 1.4)),
              const SizedBox(height: 20),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        side: const BorderSide(
                            color: Color(0xFFE2E8F0), width: 1.5),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                              fontFamily: 'Poppins')),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: actionColor,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(actionText,
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontFamily: 'Poppins')),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Do not show again
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: false,
                      onChanged: (_) {},
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('Do not show again',
                      style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Poppins')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
