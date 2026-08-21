import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/courses/models/course_model.dart';
import 'package:sociallearnapp/features/courses/screens/subject_topics_screen.dart';
import 'package:sociallearnapp/features/courses/widgets/course_subject_icon.dart';
import 'package:sociallearnapp/features/notifications/screens/notifications_screen.dart';
import 'package:sociallearnapp/features/profile/screens/profile_screen.dart';

class CourseSubjectItem {
  final String title;
  final SubjectType type;
  final Color iconBg;
  final String solvedText;
  final double progress;
  final int totalQuestions;
  final int solvedQuestions;

  const CourseSubjectItem({
    required this.title,
    required this.type,
    required this.iconBg,
    required this.solvedText,
    required this.progress,
    required this.totalQuestions,
    required this.solvedQuestions,
  });

  CourseModel toCourseModel(String category) {
    return CourseModel(
      id: '${category.toLowerCase()}_${title.toLowerCase().replaceAll(' ', '_')}',
      title: title,
      instructor: 'Expert Educator',
      thumbnail: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?w=500',
      description: 'Comprehensive $title preparation course with video lessons, topic summaries, and solved practice questions for $category exams.',
      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      duration: '32 hours',
      rating: 4.9,
      enrolledCount: 1420,
      category: category,
      lessons: totalQuestions,
      solvedInfo: solvedText,
    );
  }
}

class CoursesScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final bool showHeader;

  const CoursesScreen({
    super.key,
    this.onOpenDrawer,
    this.showHeader = true,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ─── TYT Subjects (10 Items) ───────────────────────────────────────────────
  final List<CourseSubjectItem> _tytSubjects = const [
    CourseSubjectItem(
      title: 'Turkish',
      type: SubjectType.turkish,
      iconBg: Color(0xFFFFE8EC),
      solvedText: '24/85 Solved',
      progress: 24 / 85,
      totalQuestions: 85,
      solvedQuestions: 24,
    ),
    CourseSubjectItem(
      title: 'Mathematics',
      type: SubjectType.mathematics,
      iconBg: Color(0xFFE0F7FE),
      solvedText: '56/86 Solved',
      progress: 56 / 86,
      totalQuestions: 86,
      solvedQuestions: 56,
    ),
    CourseSubjectItem(
      title: 'Geometry',
      type: SubjectType.geometry,
      iconBg: Color(0xFFFDE8F3),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
    CourseSubjectItem(
      title: 'History',
      type: SubjectType.history,
      iconBg: Color(0xFFFFF3DB),
      solvedText: '1 out of 16 Solved',
      progress: 1 / 16,
      totalQuestions: 16,
      solvedQuestions: 1,
    ),
    CourseSubjectItem(
      title: 'Geography',
      type: SubjectType.geography,
      iconBg: Color(0xFFE1F5FE),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
    CourseSubjectItem(
      title: 'Philosophy',
      type: SubjectType.philosophy,
      iconBg: Color(0xFFF4EFE6),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
    CourseSubjectItem(
      title: 'Religion',
      type: SubjectType.religion,
      iconBg: Color(0xFFE8F8EE),
      solvedText: '24/85 Solved',
      progress: 24 / 85,
      totalQuestions: 85,
      solvedQuestions: 24,
    ),
    CourseSubjectItem(
      title: 'Physics',
      type: SubjectType.physics,
      iconBg: Color(0xFFF3E8FF),
      solvedText: '1 out of 16 Solved',
      progress: 1 / 16,
      totalQuestions: 16,
      solvedQuestions: 1,
    ),
    CourseSubjectItem(
      title: 'Chemistry',
      type: SubjectType.chemistry,
      iconBg: Color(0xFFFFF9E6),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
    CourseSubjectItem(
      title: 'Biology',
      type: SubjectType.biology,
      iconBg: Color(0xFFEBF3FF),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
  ];

  // ─── AYT Subjects (11 Items) ───────────────────────────────────────────────
  final List<CourseSubjectItem> _aytSubjects = const [
    CourseSubjectItem(
      title: 'Literature',
      type: SubjectType.literature,
      iconBg: Color(0xFFEDE9FE),
      solvedText: '24/85 Solved',
      progress: 24 / 85,
      totalQuestions: 85,
      solvedQuestions: 24,
    ),
    CourseSubjectItem(
      title: 'Mathematics',
      type: SubjectType.mathematics,
      iconBg: Color(0xFFE0F7FE),
      solvedText: '56/86 Solved',
      progress: 56 / 86,
      totalQuestions: 86,
      solvedQuestions: 56,
    ),
    CourseSubjectItem(
      title: 'Geometry',
      type: SubjectType.geometry,
      iconBg: Color(0xFFFDE8F3),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
    CourseSubjectItem(
      title: 'Physics',
      type: SubjectType.physics,
      iconBg: Color(0xFFF3E8FF),
      solvedText: '1 out of 16 Solved',
      progress: 1 / 16,
      totalQuestions: 16,
      solvedQuestions: 1,
    ),
    CourseSubjectItem(
      title: 'Chemistry',
      type: SubjectType.chemistry,
      iconBg: Color(0xFFFFF9E6),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
    CourseSubjectItem(
      title: 'Biology',
      type: SubjectType.biology,
      iconBg: Color(0xFFEBF3FF),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
    CourseSubjectItem(
      title: 'History',
      type: SubjectType.history,
      iconBg: Color(0xFFFFF3DB),
      solvedText: '1 out of 16 Solved',
      progress: 1 / 16,
      totalQuestions: 16,
      solvedQuestions: 1,
    ),
    CourseSubjectItem(
      title: 'Geography',
      type: SubjectType.geography,
      iconBg: Color(0xFFE1F5FE),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
    CourseSubjectItem(
      title: 'Philosophy',
      type: SubjectType.philosophy,
      iconBg: Color(0xFFF4EFE6),
      solvedText: '13 out of 24 Solved',
      progress: 13 / 24,
      totalQuestions: 24,
      solvedQuestions: 13,
    ),
    CourseSubjectItem(
      title: 'Religion',
      type: SubjectType.religion,
      iconBg: Color(0xFFE8F8EE),
      solvedText: '24/85 Solved',
      progress: 24 / 85,
      totalQuestions: 85,
      solvedQuestions: 24,
    ),
    CourseSubjectItem(
      title: 'Foreign Language',
      type: SubjectType.foreignLanguage,
      iconBg: Color(0xFFFFE8EC),
      solvedText: '1 out of 16 Solved',
      progress: 1 / 16,
      totalQuestions: 16,
      solvedQuestions: 1,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    final name = user?.displayName?.split(' ').first ?? 'Harsh';
    final dateStr = _formatCurrentDate();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F172A) : const Color(0xFFFAFAFC);
    final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Top Header Bar ──────────────────────────────────────────────
            if (widget.showHeader) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Menu & Greeting
                    Row(
                      children: [
                        GestureDetector(
                          onTap: widget.onOpenDrawer ?? () => Navigator.maybePop(context),
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
                              dateStr,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Text(
                              'Welcome back, $name',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF2A3BD4),
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Notification bell + User profile avatar
                    Row(
                      children: [
                        // Bell with red dot
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
                              Container(
                                width: 38,
                                height: 38,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.notifications_none_rounded,
                                  color: textPrimary,
                                  size: 24,
                                ),
                              ),
                              Positioned(
                                top: 6,
                                right: 6,
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
                        const SizedBox(width: 8),

                        // Profile Avatar
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
                ),
              ),
            ],

            // ── Tab Bar (TYT / AYT) ──────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(
                  bottom: BorderSide(
                    color: borderColor,
                    width: 1.0,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFF2A3BD4),
                indicatorWeight: 2.5,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: const Color(0xFF2A3BD4),
                unselectedLabelColor: const Color(0xFF94A3B8),
                labelStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.5,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.5,
                ),
                tabs: const [
                  Tab(text: 'TYT'),
                  Tab(text: 'AYT'),
                ],
              ),
            ),

            // ── Tab Views (Course Grids) ─────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCourseGrid(_tytSubjects, 'TYT', cardColor, textPrimary, borderColor, isDark),
                  _buildCourseGrid(_aytSubjects, 'AYT', cardColor, textPrimary, borderColor, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── 2-Column Grid of Course Cards ────────────────────────────────────────
  Widget _buildCourseGrid(
    List<CourseSubjectItem> subjects,
    String category,
    Color cardColor,
    Color textPrimary,
    Color borderColor,
    bool isDark,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.86,
      ),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final item = subjects[index];
        return _buildCourseCard(item, category, index, cardColor, textPrimary, borderColor, isDark);
      },
    );
  }

  // ─── Single Course Card matching Screenshot ──────────────────────────────
  Widget _buildCourseCard(
    CourseSubjectItem item,
    String category,
    int index,
    Color cardColor,
    Color textPrimary,
    Color borderColor,
    bool isDark,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubjectTopicsScreen(
              subjectName: item.title,
              trialExamsCompleted: 5,
              trialExamsTotal: 10,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.025),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Subject Icon Pastel Container
            Container(
              width: double.infinity,
              height: 78,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: CourseSubjectIcon(
                type: item.type,
                size: 46,
              ),
            ),

            // Title, Solved Subtitle, and Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Subject Title
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),

                // Solved Information with Document/Check icon
                Row(
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 12,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.solvedText,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Progress Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: item.progress.clamp(0.0, 1.0),
                    minHeight: 3.2,
                    backgroundColor: const Color(0xFFF1F5F9),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF22C55E),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate(delay: (index * 40).ms).fadeIn(duration: 300.ms).slideY(
          begin: 0.05,
          end: 0,
          duration: 300.ms,
          curve: Curves.easeOut,
        );
  }
}
