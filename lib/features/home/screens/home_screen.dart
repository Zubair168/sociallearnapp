import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/core/theme/theme_provider.dart';
import 'package:sociallearnapp/features/courses/screens/courses_screen.dart';
import 'package:sociallearnapp/features/courses/screens/subject_topics_screen.dart';
import 'package:sociallearnapp/features/courses/screens/favorited_questions_screen.dart';
import 'package:sociallearnapp/features/courses/screens/smart_study_plan_screen.dart';
import 'package:sociallearnapp/features/courses/screens/trial_exams_screen.dart';
import 'package:sociallearnapp/features/courses/screens/test_result_screen.dart';
import 'package:sociallearnapp/features/notifications/screens/notifications_screen.dart';
import 'package:sociallearnapp/features/notifications/services/notification_service.dart';
import 'package:sociallearnapp/features/profile/screens/profile_screen.dart';
import 'package:sociallearnapp/features/progress/services/progress_storage_service.dart';
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
    {'title': 'Solve one mock exam (Practice Exam)', 'icon': Icons.assignment_outlined, 'done': false},
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FC),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimary;

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
                Expanded(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => _scaffoldKey.currentState?.openDrawer(),
                        child: Icon(
                          Icons.notes_rounded,
                          color: textPrimary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dateStr,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade500,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Welcome back, $name',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Actions: Bell with red dot + Avatar
                Row(
                  children: [
                    // Notification Bell
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationsScreen(),
                        ),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.notifications_none_rounded,
                            color: textPrimary,
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

                    // Avatar → open Profile
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfileScreen(),
                        ),
                      ),
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

            // ── 2. Top Stats Row (Days Until Exam & Daily Goal) Exact Match ─
            Row(
              children: [
                // ── Card 1: Days Until Exam ──
                Expanded(
                  child: GestureDetector(
                    onTap: _showExamCountdownModal,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                            width: 1.2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.025),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Days Until Exam',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Blue Calendar Icon
                              const Icon(
                                Icons.calendar_today_rounded,
                                color: Color(0xFF2A3BD4),
                                size: 26,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '16',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                                  fontFamily: 'Poppins',
                                  height: 1.1,
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

                // ── Card 2: Daily Goal Exact Match ──
                Expanded(
                  child: Consumer<ProgressProvider>(
                    builder: (context, progress, _) {
                      final current = progress.dailySolved;
                      final goal = progress.dailyGoal;
                      final pct = (current / (goal > 0 ? goal : 1)).clamp(0.0, 1.0);

                      return GestureDetector(
                        onTap: _showDailyGoalPickerModal,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                width: 1.2),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.025),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Target Icon (Bullseye)
                              const Icon(
                                Icons.track_changes_rounded,
                                color: Color(0xFF2A3BD4),
                                size: 36,
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
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w500,
                                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        const Icon(
                                          Icons.edit_outlined,
                                          size: 15,
                                          color: Color(0xFF2A3BD4),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    RichText(
                                      text: TextSpan(
                                        text: '$goal ',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                                          fontFamily: 'Poppins',
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Questions',
                                            style: TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w500,
                                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF1E293B),
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(3),
                                      child: LinearProgressIndicator(
                                        value: pct,
                                        minHeight: 4.5,
                                        backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
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
                      );
                    },
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 14),

            // ── 4. My Plan Container (Dynamic Live Tasks with Interactive Checkmarks) ──
            Consumer<ProgressProvider>(
              builder: (context, progress, _) {
                final tasks = progress.studyTasks;
                final completedCount = progress.completedTasksCount;
                final totalCount = progress.totalTasksCount;
                final remainingCount = progress.remainingTasksCount;
                final progressFraction = progress.tasksProgress;

                return Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.025),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: My Plan + Plan Details >
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Plan',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : const Color(0xFF1E293B),
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
                            child: const Row(
                              children: [
                                Text(
                                  'Plan Details',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF2A3BD4),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(width: 2),
                                Icon(Icons.chevron_right_rounded,
                                    size: 16, color: Color(0xFF2A3BD4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Progress description
                      RichText(
                        text: TextSpan(
                          text: remainingCount > 0 ? 'You need to solve ' : 'Great job! You completed all ',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            TextSpan(
                              text: remainingCount > 0 ? '$remainingCount more ' : '$completedCount ',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                              ),
                            ),
                            TextSpan(
                              text: remainingCount > 0 ? 'tasks to complete daily plan' : 'tasks today!',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Progress Bar with completed and total labels
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progressFraction,
                          minHeight: 6,
                          backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xFF2A3BD4),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$completedCount completed',
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF94A3B8),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '$totalCount tasks',
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF94A3B8),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Today's Pending Tasks Header
                      Text(
                        "Today's Pending Tasks",
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : const Color(0xFF1E293B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Live Dynamic Tasks
                      if (tasks.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: Text(
                              'No study tasks scheduled for today.',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        )
                      else
                        ...List.generate(tasks.take(3).length, (index) {
                          final task = tasks[index];
                          return Column(
                            children: [
                              if (index > 0)
                                Divider(
                                  color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                                  height: 16,
                                ),
                              _buildPendingTaskItem(
                                task: task,
                                onToggle: () => progress.toggleStudyTask(task.id),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SubjectTopicsScreen(
                                        subjectName: task.course.isNotEmpty ? task.course : 'Mathematics',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        }),

                      const SizedBox(height: 14),

                      // View All Button
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SmartStudyPlanScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF2A3BD4).withValues(alpha: 0.2) : const Color(0xFFEBF0FE),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'View All ($totalCount)',
                            style: const TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF2A3BD4),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ).animate().fadeIn(delay: 150.ms),

            const SizedBox(height: 14),

            // ── 5. 2x3 Grid Feature Cards (Active Populated State) ───────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      // 1. Coaching Card
                      _buildGridCard(
                        icon: Icons.record_voice_over_outlined,
                        title: 'Coaching',
                        content: Column(
                          children: [
                            const SizedBox(height: 6),
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage: NetworkImage(
                                'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=150',
                              ),
                            ),
                            SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    'Ayşegül Allen',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                                      fontFamily: 'Poppins',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.verified_rounded,
                                    color: Color(0xFF2A3BD4), size: 14),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Active till: 23 Jul 2025',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Colors.grey.shade500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        btnText: 'Go to Coaching',
                        onTap: _showCoachingModal,
                      ),
                      const SizedBox(height: 12),

                      // 3. Your Latest Rank Card
                      _buildGridCard(
                        icon: Icons.person_outline_rounded,
                        title: 'Your Latest Rank',
                        content: Column(
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              'Score',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const Text(
                              '461.21',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2A3BD4),
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Rank',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              '#15,121',
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                        btnText: 'View Details',
                        onTap: _showRankCalculatorModal,
                      ),
                      const SizedBox(height: 12),

                      // 5. Video Lecture Card
                      _buildGridCard(
                        icon: Icons.videocam_outlined,
                        title: 'Video Lecture',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              'Continue Watching',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 52,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF881337), Color(0xFF4C0519)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Linear Algebra\nFull Course',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white70,
                                          height: 1.1,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.play_circle_fill_rounded,
                                      color: Colors.white, size: 22),
                                  Positioned(
                                    bottom: 3,
                                    right: 4,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.7),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: const Text(
                                        '08:02',
                                        style: TextStyle(
                                          fontSize: 7.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        btnText: 'Go to Video Lectures',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const VideoPlayerScreen(
                                title: 'Word Problems with Linear Equations-1',
                                videoUrl:
                                    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                                category: 'Starter',
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
                      // 2. Study Templates Card
                      _buildGridCard(
                        icon: Icons.description_outlined,
                        title: 'Study Templates',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              'Active templates',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTemplateRow(
                              Icons.calculate_outlined,
                              const Color(0xFFE0F2FE),
                              const Color(0xFF0284C7),
                              '8 Week Math Focus',
                            ),
                            const SizedBox(height: 4),
                            _buildTemplateRow(
                              Icons.science_outlined,
                              const Color(0xFFF0FDF4),
                              const Color(0xFF16A34A),
                              '2-Week Physics M...',
                            ),
                          ],
                        ),
                        btnText: 'View All',
                        onTap: _showStudyTemplatesModal,
                      ),
                      const SizedBox(height: 12),

                      // 4. University Goal Card
                      _buildGridCard(
                        icon: Icons.school_outlined,
                        title: 'University Goal',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              'Boğaziçi University',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF1E293B),
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Computer science',
                              style: TextStyle(
                                fontSize: 9.5,
                                color: Colors.grey.shade500,
                                fontFamily: 'Poppins',
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.people_outline_rounded,
                                    size: 11, color: Color(0xFF2A3BD4)),
                                const SizedBox(width: 2),
                                Text('40',
                                    style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white70 : const Color(0xFF1E293B))),
                                const SizedBox(width: 4),
                                const Icon(Icons.track_changes_rounded,
                                    size: 11, color: Color(0xFF0284C7)),
                                const SizedBox(width: 2),
                                Text('461.2',
                                    style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white70 : const Color(0xFF1E293B))),
                              ],
                            ),
                            const SizedBox(width: 4),
                            Row(
                              children: [
                                const Icon(Icons.military_tech_outlined,
                                    size: 11, color: Color(0xFFEAB308)),
                                const SizedBox(width: 2),
                                Text('#2,121',
                                    style: TextStyle(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? Colors.white70 : const Color(0xFF1E293B))),
                              ],
                            ),
                          ],
                        ),
                        btnText: 'View Details',
                        onTap: _showPreferenceListModal,
                      ),
                      const SizedBox(height: 12),

                      // 6. Trial Exams Card
                      _buildGridCard(
                        icon: Icons.assignment_outlined,
                        title: 'Trial Exams',
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 2),
                            Text(
                              'Next Up',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 6),
                            _buildTemplateRow(
                              Icons.biotech_outlined,
                              const Color(0xFFF0FDF4),
                              const Color(0xFF16A34A),
                              'Biology Trial Exams',
                            ),
                            const SizedBox(height: 4),
                            _buildTemplateRow(
                              Icons.calculate_outlined,
                              const Color(0xFFE0F2FE),
                              const Color(0xFF0284C7),
                              'Maths Trial Exams',
                            ),
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
            GestureDetector(
              onTap: () {
                _showFeatureInfoDialog(
                  title: 'Personalized Question Bank',
                  description:
                      'Generate and print custom question banks structured around your weak topics and ÖSYM past question models.',
                  icon: Icons.auto_stories_rounded,
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F2FE),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.book_rounded,
                          color: Color(0xFF0284C7), size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Create a personalized Question Bank',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 250.ms),
          ],
        ),
      ),
    );
  }

  // ─── Modal: Exam Countdown Details ──────────────────────────────────────────
  void _showExamCountdownModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(
            22, 16, 22, MediaQuery.of(ctx).padding.bottom + 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.event_available_rounded,
                    color: Color(0xFF2A3BD4),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Exam Countdown',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'YKS (TYT & AYT) 2026 Target',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '16 Days Left',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF2A3BD4),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            // Exam Sessions breakdown card
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildExamSessionRow('TYT Session', '14 June 2026', '10:15 AM',
                      const Color(0xFF2A3BD4)),
                  const Divider(height: 16, color: Color(0xFFE2E8F0)),
                  _buildExamSessionRow('AYT Session', '15 June 2026', '10:15 AM',
                      const Color(0xFF0284C7)),
                  const Divider(height: 16, color: Color(0xFFE2E8F0)),
                  _buildExamSessionRow('YDT Session', '15 June 2026', '03:45 PM',
                      const Color(0xFF7C3AED)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SmartStudyPlanScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A3BD4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'View Smart Study Plan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

  Widget _buildExamSessionRow(
      String title, String date, String time, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              time,
              style: TextStyle(
                fontSize: 10.5,
                color: Colors.grey.shade500,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Modal: Edit Daily Question Goal ────────────────────────────────────────
  void _showDailyGoalPickerModal() {
    final progress = context.read<ProgressProvider>();
    int selectedGoal = progress.dailyGoal;
    final goals = [5, 10, 15, 20, 25, 30, 40, 50];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(
              22, 16, 22, MediaQuery.of(ctx).padding.bottom + 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEF2FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.track_changes_rounded,
                      color: Color(0xFF2A3BD4),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Set Daily Goal',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Text(
                          'How many questions to solve each day?',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Grid of quick goals
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1.4,
                ),
                itemCount: goals.length,
                itemBuilder: (_, i) {
                  final g = goals[i];
                  final isSelected = selectedGoal == g;

                  return GestureDetector(
                    onTap: () {
                      setModalState(() {
                        selectedGoal = g;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2A3BD4)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2A3BD4)
                              : const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$g',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1E293B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    await progress.updateDailyGoal(selectedGoal);
                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Daily goal updated to $selectedGoal questions!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A3BD4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Save Goal',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final cardBorder = isDark ? const Color(0xFF334155) : Colors.grey.shade100;
    final titleColor = isDark ? Colors.white : AppColors.textPrimary;
    final btnBg = isDark ? const Color(0xFF2A3BD4).withValues(alpha: 0.22) : const Color(0xFFEBF0FE);
    final btnTextColor = isDark ? const Color(0xFF818CF8) : const Color(0xFF2A3BD4);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cardBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
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
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
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
                color: btnBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                btnText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: btnTextColor,
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

  // ─── Pending Task Item (My Plan section) ────────────────────────────────────

  Widget _buildPendingTaskItem({
    required StudyTaskRecord task,
    required VoidCallback onToggle,
    required VoidCallback onTap,
  }) {
    final isDone = task.isCompleted;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : const Color(0xFF1E293B);

    final iconData = IconData(task.iconCodePoint, fontFamily: 'MaterialIcons');
    final iconBg = Color(task.iconBgColor);
    final iconColor = task.type == 'TYT' ? const Color(0xFF0284C7) : const Color(0xFFEA580C);
    final tierBg = task.type == 'TYT' ? const Color(0xFFEEF2FF) : const Color(0xFFFFF7ED);
    final tierFg = task.type == 'TYT' ? const Color(0xFF2A3BD4) : const Color(0xFFEA580C);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            // Interactive Checkbox circle
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: isDone ? const Color(0xFF22C55E) : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDone ? const Color(0xFF22C55E) : const Color(0xFFCBD5E1),
                    width: 1.5,
                  ),
                ),
                child: isDone
                    ? const Icon(Icons.check_rounded, color: Colors.white, size: 15)
                    : null,
              ),
            ),
            const SizedBox(width: 10),
            // Subject icon
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(iconData, color: iconColor, size: 18),
            ),
            const SizedBox(width: 10),
            // Title
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDone ? const Color(0xFF94A3B8) : titleColor,
                  decoration: isDone ? TextDecoration.lineThrough : null,
                  fontFamily: 'Poppins',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            // Tier pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: tierBg,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                task.type,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: tierFg,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Duration
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.access_time_rounded,
                    size: 11, color: Colors.grey.shade400),
                const SizedBox(width: 2),
                Text(
                  '${task.durationMinutes} mins',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                size: 16, color: Color(0xFF94A3B8)),
          ],
        ),
      ),
    );
  }

  // ─── Template Row (Study Templates & Trial Exams cards) ────────────────────

  Widget _buildTemplateRow(
    IconData icon,
    Color iconBg,
    Color iconColor,
    String title,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            color: iconBg,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: iconColor, size: 13),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : const Color(0xFF1E293B),
              fontFamily: 'Poppins',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: navBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) => setState(() => _selectedTab = i),
        type: BottomNavigationBarType.fixed,
        backgroundColor: navBg,
        selectedItemColor: const Color(0xFF3B4CE8),
        unselectedItemColor: isDark ? const Color(0xFF64748B) : Colors.grey.shade400,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final drawerBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimary;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

    return Drawer(
      backgroundColor: drawerBg,
      child: SafeArea(
        child: Column(
          children: [
            // 1. Profile Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
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
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.chevron_right_rounded,
                                size: 16, color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600),
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
          ),

            // 2. Menu Items (Scrollable)
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  // Getting Started Checklist
                  _buildDrawerItem(
                    icon: Icons.checklist_rtl_rounded,
                    title: 'Getting Started Checklist',
                    onTap: () {
                      Navigator.pop(context);
                      _showOnboardingTasksSheet();
                    },
                  ),

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
                        icon: Icons.info_outline_rounded,
                        title: 'Unattempted Questions',
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
                        onTap: () {
                          Navigator.pop(context);
                          _showFeatureInfoDialog(
                            title: 'Personalized Question Bank',
                            description:
                                'Create custom printed question booklets tailored precisely to your weak areas and study roadmap.',
                            icon: Icons.auto_stories_rounded,
                          );
                        },
                      ),
                      _buildDrawerSubItem(
                        title: 'Smart Books',
                        onTap: () {
                          Navigator.pop(context);
                          _showFeatureInfoDialog(
                            title: 'Smart Books',
                            description:
                                'Scan questions from our printed Smart Books with your phone camera to watch instant video solutions.',
                            icon: Icons.qr_code_scanner_rounded,
                          );
                        },
                      ),
                      _buildDrawerSubItem(
                        title: 'My Books & Orders',
                        onTap: () {
                          Navigator.pop(context);
                          _showFeatureInfoDialog(
                            title: 'My Books & Orders',
                            description:
                                'Track your printed book shipments and view your digital access keys.',
                            icon: Icons.local_shipping_outlined,
                          );
                        },
                      ),
                      _buildDrawerSubItem(
                        title: 'Check Answers',
                        onTap: () {
                          Navigator.pop(context);
                          _showFeatureInfoDialog(
                            title: 'Check Answers',
                            description:
                                'Quickly enter optical test codes from your printed books to calculate your net scores.',
                            icon: Icons.fact_check_outlined,
                          );
                        },
                      ),
                    ],
                  ),

                  // Summary Notes
                  _buildDrawerItem(
                    icon: Icons.edit_note_rounded,
                    title: 'Summary Notes',
                    onTap: () {
                      Navigator.pop(context);
                      _showFeatureInfoDialog(
                        title: 'Summary Notes',
                        description:
                            'High-yield formula cheat sheets, concept maps, and summary notes for all TYT & AYT topics.',
                        icon: Icons.edit_note_rounded,
                      );
                    },
                  ),

                  // Yearly Planner
                  _buildDrawerItem(
                    icon: Icons.event_note_rounded,
                    title: 'Yearly Planner',
                    onTap: () {
                      Navigator.pop(context);
                      _showYearlyPlannerDialog();
                    },
                  ),

                  // Study Plans
                  _buildDrawerItem(
                    icon: Icons.calendar_today_outlined,
                    title: 'Study Plans',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SmartStudyPlanScreen(),
                        ),
                      );
                    },
                  ),

                  // AI Assistant
                  _buildDrawerItem(
                    icon: Icons.smart_toy_outlined,
                    title: 'AI Assistant',
                    onTap: () {
                      Navigator.pop(context);
                      _showFeatureInfoDialog(
                        title: 'AI Study Assistant',
                        description:
                            'Ask step-by-step math, physics, and chemistry solutions or generate personalized test hints with your AI Tutor.',
                        icon: Icons.smart_toy_outlined,
                      );
                    },
                  ),

                  // Dark / Light Theme Toggle
                  Consumer<ThemeProvider>(
                    builder: (context, theme, _) {
                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.isDarkMode
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.isDarkMode
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: SwitchListTile(
                          dense: true,
                          secondary: Icon(
                            theme.isDarkMode
                                ? Icons.dark_mode_rounded
                                : Icons.light_mode_rounded,
                            color: theme.isDarkMode
                                ? const Color(0xFFFBBF24)
                                : const Color(0xFF2A3BD4),
                            size: 20,
                          ),
                          title: Text(
                            theme.isDarkMode ? 'Dark Mode' : 'Light Mode',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          value: theme.isDarkMode,
                          onChanged: (val) => theme.toggleTheme(val),
                        ),
                      );
                    },
                  ),

                  // Push Notification Tester
                  _buildDrawerItem(
                    icon: Icons.notifications_active_outlined,
                    title: 'Test New Lesson Notification',
                    onTap: () {
                      Navigator.pop(context);
                      final notif = context.read<NotificationService>();
                      notif.showNewLessonNotification(
                        title: 'Algebra – Introduction to Equations-2',
                        subject: 'Mathematics',
                        duration: '01:22',
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('🔔 Push notification sent!'),
                          backgroundColor: const Color(0xFF2A3BD4),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                  ),

                  // About
                  _buildDrawerItem(
                    icon: Icons.info_outline_rounded,
                    title: 'About',
                    onTap: () {
                      Navigator.pop(context);
                      _showFeatureInfoDialog(
                        title: 'About EduVerse',
                        description:
                            'EduVerse v1.0.0 — Your unified social learning platform for high-performance exam preparation.',
                        icon: Icons.school_rounded,
                      );
                    },
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
                onTap: () {
                  Navigator.pop(context);
                  _showLogoutConfirmationDialog(auth);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmationDialog(AuthService auth) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Drag Handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Red/Coral subtle icon circle
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFEF4444),
                size: 24,
              ),
            ),
            const SizedBox(height: 14),

            const Text(
              'Log Out',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 6),

            Text(
              'Are you sure you want to log out of your account?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade500,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF64748B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await auth.signOut();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Log Out',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showFeatureInfoDialog({
    required String title,
    required String description,
    required IconData icon,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF4FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF2A3BD4), size: 30),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5,
                color: Colors.grey.shade600,
                fontFamily: 'Poppins',
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A3BD4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Got It',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCoachingModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Exam Coaching & Mentorship',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '1-on-1 guidance with Top 1,000 YKS rankers and experienced teachers.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 16),
            _coachingPackageTile(
              'Sprint Package',
              'Weekly 1-on-1 strategy meeting + Daily question plan',
              '₺450 / mo',
              const Color(0xFF22C55E),
            ),
            const SizedBox(height: 10),
            _coachingPackageTile(
              'Mastery Package',
              '3x weekly meetings + 24/7 WhatsApp question solver + Live trial exam analysis',
              '₺850 / mo',
              const Color(0xFF2A3BD4),
              isRecommended: true,
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Coaching consultation request submitted!'),
                      backgroundColor: const Color(0xFF2A3BD4),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A3BD4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text(
                  'Book Free 15-min Consultation',
                  style: TextStyle(
                    color: Colors.white,
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

  Widget _coachingPackageTile(
      String title, String desc, String price, Color color,
      {bool isRecommended = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isRecommended ? const Color(0xFFEFF4FF) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRecommended ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0),
          width: isRecommended ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    if (isRecommended) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3BD4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'BEST VALUE',
                          style: TextStyle(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            price,
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              color: color,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  void _showRankCalculatorModal() {
    double tytNet = 85.5;
    double aytNet = 62.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          final score = (tytNet * 2.5) + (aytNet * 4.0) + 60.0;
          final estimatedRank = (500000 / (score / 100)).toInt().clamp(1200, 450000);

          return Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'YKS Projected Rank Calculator',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on latest ÖSYM coefficients and score standard deviations.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),

                // Calculated Result Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF4FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF93C5FD)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Estimated Score',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            score.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2A3BD4),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      Container(width: 1, height: 32, color: const Color(0xFFCBD5E1)),
                      Column(
                        children: [
                          const Text(
                            'Projected Ranking',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            '#$estimatedRank',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF16A34A),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TYT Net Score: ${tytNet.toStringAsFixed(1)} / 120',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins')),
                  ],
                ),
                Slider(
                  value: tytNet,
                  min: 0,
                  max: 120,
                  divisions: 120,
                  activeColor: const Color(0xFF2A3BD4),
                  onChanged: (val) => setModalState(() => tytNet = val),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('AYT Net Score: ${aytNet.toStringAsFixed(1)} / 80',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins')),
                  ],
                ),
                Slider(
                  value: aytNet,
                  min: 0,
                  max: 80,
                  divisions: 80,
                  activeColor: const Color(0xFF16A34A),
                  onChanged: (val) => setModalState(() => aytNet = val),
                ),

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2A3BD4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: const Text('Save to My Profile',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Poppins')),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showStudyTemplatesModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'High-Yield Study Templates',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Pre-built revision schedules structured by target score.',
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade600,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 14),
            _studyTemplateItem('90-Day TYT Foundation Sprint', 'Daily 60 Qs • Math & Turkish focus', 'Active', const Color(0xFF16A34A)),
            const SizedBox(height: 8),
            _studyTemplateItem('AYT STEM Mastery Schedule', 'Daily 80 Qs • Physics & Advanced Calc', 'Popular', const Color(0xFF2A3BD4)),
            const SizedBox(height: 8),
            _studyTemplateItem('Weekend Full Trial Exam Simulator', '2 TYT + 2 AYT complete runs per week', 'Intense', const Color(0xFFEF4444)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2A3BD4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('Apply Selected Schedule',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _studyTemplateItem(String title, String desc, String tag, Color tagColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: tagColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.menu_book_rounded, color: tagColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                      decoration: BoxDecoration(color: tagColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(4)),
                      child: Text(tag, style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: tagColor, fontFamily: 'Poppins')),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(desc, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500, fontFamily: 'Poppins')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPreferenceListModal() {
    final List<Map<String, String>> prefs = [
      {'uni': 'Boğaziçi University', 'dept': 'Computer Engineering (English)', 'rank': 'Top 450', 'quota': '75'},
      {'uni': 'Middle East Technical University (ODTÜ)', 'dept': 'Electrical & Electronics Eng.', 'rank': 'Top 1,200', 'quota': '120'},
      {'uni': 'Istanbul Technical University (ITU)', 'dept': 'Artificial Intelligence & Data Eng.', 'rank': 'Top 2,100', 'quota': '60'},
      {'uni': 'Bilkent University', 'dept': 'Industrial Engineering (Full Schol.)', 'rank': 'Top 850', 'quota': '30'},
      {'uni': 'Koç University', 'dept': 'Faculty of Medicine (Full Schol.)', 'rank': 'Top 120', 'quota': '20'},
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Target University Preferences',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Your target departments and past YKS baseline cutoff percentiles.',
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.grey.shade600,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 14),
            Expanded(
              child: ListView.separated(
                itemCount: prefs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final p = prefs[i];
                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: i == 0 ? const Color(0xFFEFF4FF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: i == 0 ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFF2A3BD4).withValues(alpha: 0.1),
                          child: Text('${i + 1}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2A3BD4), fontFamily: 'Poppins')),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['uni']!, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
                              Text(p['dept']!, style: TextStyle(fontSize: 10.5, color: Colors.grey.shade600, fontFamily: 'Poppins')),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(4)),
                          child: Text(p['rank']!, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: Color(0xFF16A34A), fontFamily: 'Poppins')),
                        ),
                      ],
                    ),
                  );
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
  final Set<String> _expandedDays = {'Today'};

  String _formatCurrentDate() {
    final now = DateTime.now();
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${weekdays[now.weekday - 1]}, ${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]}';
  }

  String _formatDateHeader(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final itemDate = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(itemDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final progress = context.watch<ProgressProvider>();
    final user = auth.currentUser;
    final name = user?.displayName?.split(' ').first ?? 'Harsh';
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

    final allTests = progress.solvedTests;

    // Group tests by date label
    final Map<String, List<SolvedTestRecord>> grouped = {};
    for (final test in allTests) {
      final key = _formatDateHeader(test.timestamp);
      grouped.putIfAbsent(key, () => []).add(test);
    }

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top Header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Menu & Greeting
                  Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onOpenDrawer,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.notes_rounded,
                            size: 26,
                            color: textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _formatCurrentDate(),
                            style: TextStyle(
                              fontSize: 11.5,
                              color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade500,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text(
                            'Solved Questions ($name)',
                            style: const TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2A3BD4),
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Actions: Bell + Avatar
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotificationsScreen(),
                          ),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.notifications_none_rounded,
                              color: textPrimary,
                              size: 24,
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Container(
                                width: 8,
                                height: 8,
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
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ProfileScreen(),
                          ),
                        ),
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                            image: user?.photoURL != null
                                ? DecorationImage(
                                    image: NetworkImage(user!.photoURL!),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: NetworkImage(
                                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=150'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: allTests.isNotEmpty
                  ? _buildSolvedList(grouped, cardColor, textPrimary, borderColor, isDark)
                  : _buildEmptyState(cardColor, textPrimary, isDark),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Empty State ──────────────────────────────────────────────────────────
  Widget _buildEmptyState(Color cardColor, Color textPrimary, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.08),
                  blurRadius: 16,
                )
              ],
            ),
            child: const Icon(
              Icons.assignment_outlined,
              size: 36,
              color: Color(0xFF2A3BD4),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Start solving questions to see\nyour progress here.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: textPrimary,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: widget.onSolveQuestions,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
              decoration: BoxDecoration(
                color: const Color(0xFF2A3BD4),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF2A3BD4).withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_rounded, color: Colors.white, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Solve Questions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  // ─── Solved List ──────────────────────────────────────────────────────────
  Widget _buildSolvedList(
    Map<String, List<SolvedTestRecord>> grouped,
    Color cardColor,
    Color textPrimary,
    Color borderColor,
    bool isDark,
  ) {
    final keys = grouped.keys.toList();
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final dateKey = keys[index];
        final tests = grouped[dateKey] ?? [];
        return _buildDayCard(dateKey, tests, cardColor, textPrimary, borderColor, isDark);
      },
    );
  }

  Widget _buildDayCard(
    String dateKey,
    List<SolvedTestRecord> tests,
    Color cardColor,
    Color textPrimary,
    Color borderColor,
    bool isDark,
  ) {
    final expanded = _expandedDays.contains(dateKey);
    final totalSolved = tests.fold<int>(0, (sum, t) => sum + t.totalQuestions);
    final totalCorrect = tests.fold<int>(0, (sum, t) => sum + t.correct);
    final totalIncorrect = tests.fold<int>(0, (sum, t) => sum + t.incorrect);
    final totalUnanswered = tests.fold<int>(0, (sum, t) => sum + t.unanswered);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Header (tappable to expand/collapse)
          GestureDetector(
            onTap: () {
              setState(() {
                if (expanded) {
                  _expandedDays.remove(dateKey);
                } else {
                  _expandedDays.add(dateKey);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        dateKey,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
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
                      _miniStat(
                        Icons.check_circle_outline_rounded,
                        '$totalSolved Solved',
                        const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 10),
                      _miniStat(
                        Icons.topic_outlined,
                        '${tests.length} Tests',
                        const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Acc: ${totalSolved > 0 ? ((totalCorrect / totalSolved) * 100).toInt() : 0}%',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF16A34A),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Correct / Incorrect / Unanswered pills
                  Row(
                    children: [
                      _resultPill(const Color(0xFF22C55E), '$totalCorrect Correct', textPrimary),
                      const SizedBox(width: 8),
                      _resultPill(const Color(0xFFEF4444), '$totalIncorrect Incorrect', textPrimary),
                      const SizedBox(width: 8),
                      _resultPill(const Color(0xFFF59E0B), '$totalUnanswered Unanswered', textPrimary),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Expanded tests
          if (expanded && tests.isNotEmpty) ...[
            Divider(height: 1, color: borderColor),
            ...tests.map((test) => _buildTestRow(test, textPrimary, borderColor, isDark)),
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
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _resultPill(Color color, String text, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: textColor,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildTestRow(
    SolvedTestRecord test,
    Color textPrimary,
    Color borderColor,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TestResultScreen(
              testTitle: test.title,
              totalQuestions: test.totalQuestions,
              correct: test.correct,
              incorrect: test.incorrect,
              unanswered: test.unanswered,
              timeTakenSeconds: 480,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: borderColor, width: 0.8)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Test icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.description_outlined,
                size: 18,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 10),

            // Test details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    test.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: textPrimary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _tagChip(
                        test.subject,
                        const Color(0xFFEDE9FE),
                        const Color(0xFF7C3AED),
                      ),
                      const SizedBox(width: 6),
                      _tagChip(
                        test.type,
                        const Color(0xFFDCFCE7),
                        const Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 6),
                      _tagChip(
                        test.difficulty,
                        Color(test.diffColor).withValues(alpha: 0.12),
                        Color(test.diffColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _miniStat(
                        Icons.check_circle_outline_rounded,
                        '${test.totalQuestions} Solved',
                        const Color(0xFF64748B),
                      ),
                      const SizedBox(width: 10),
                      _miniStat(
                        Icons.access_time_rounded,
                        test.timeSpent,
                        const Color(0xFF64748B),
                      ),
                      const Spacer(),
                      // Score chip
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF16A34A).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '${test.correct}/${test.totalQuestions} Correct',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF16A34A),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 3-dot menu
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_rounded, size: 18, color: Color(0xFF94A3B8)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              onSelected: (val) {
                if (val == 'view') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TestResultScreen(
                        testTitle: test.title,
                        totalQuestions: test.totalQuestions,
                        correct: test.correct,
                        incorrect: test.incorrect,
                        unanswered: test.unanswered,
                        timeTakenSeconds: 480,
                      ),
                    ),
                  );
                } else if (val == 'resolve') {
                  _showWarningDialog(
                    icon: Icons.refresh_rounded,
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Solve Again',
                    message: 'Would you like to restart and practice this test again?',
                    actionText: 'Start Test',
                    actionColor: const Color(0xFF2A3BD4),
                  );
                } else if (val == 'delete') {
                  _showWarningDialog(
                    icon: Icons.delete_outline_rounded,
                    iconColor: const Color(0xFFEF4444),
                    title: 'Delete Record',
                    message: 'Are you sure you want to remove this test session from history?',
                    actionText: 'Delete',
                    actionColor: const Color(0xFFEF4444),
                  );
                }
              },
              itemBuilder: (_) => [
                _popupItem('view', Icons.visibility_outlined, 'View Details'),
                _popupItem('resolve', Icons.refresh_rounded, 'Solve Again'),
                _popupItem('delete', Icons.delete_outline_rounded, 'Delete'),
              ],
            ),
          ],
        ),
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
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 380),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon circle
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 30, color: iconColor),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF64748B),
                  fontFamily: 'Poppins',
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 46),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(
                          color: Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: actionColor,
                        minimumSize: const Size(0, 46),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          actionText,
                          maxLines: 1,
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
              const SizedBox(height: 14),

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
                        borderRadius: BorderRadius.circular(4),
                      ),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Do not show again',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
