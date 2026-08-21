import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/core/constants/app_text_styles.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/courses/models/course_model.dart';
import 'package:sociallearnapp/features/courses/services/course_service.dart';
import 'package:sociallearnapp/features/video/screens/video_player_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseModel course;
  final bool isEnrolled;

  const CourseDetailScreen({
    super.key,
    required this.course,
    this.isEnrolled = false,
  });

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late bool _enrolled;
  bool _enrolling = false;
  final CourseService _courseService = CourseService();

  @override
  void initState() {
    super.initState();
    _enrolled = widget.isEnrolled;
  }

  Future<void> _enroll() async {
    final user = context.read<AuthService>().currentUser;
    if (user == null) return;
    setState(() => _enrolling = true);
    await _courseService.enrollUser(user.uid, widget.course.id);
    setState(() {
      _enrolled = true;
      _enrolling = false;
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Successfully enrolled! 🎉'),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _watchVideo() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          videoUrl: widget.course.videoUrl,
          title: widget.course.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimary;

    return Scaffold(
      backgroundColor: scaffoldBg,
      body: CustomScrollView(
        slivers: [
          // ── Header with thumbnail ─────────────────────────────────
          SliverAppBar(
            expandedHeight: 230,
            pinned: true,
            backgroundColor: AppColors.primary,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: course.thumbnail,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      color: AppColors.primary,
                      child: const Icon(Icons.play_lesson_rounded,
                          color: Colors.white, size: 64),
                    ),
                  ),
                  // Dark overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Play button
                  Center(
                    child: GestureDetector(
                      onTap: _watchVideo,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            color: AppColors.primary, size: 36),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Course info ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      course.category,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ).animate().fadeIn(),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    course.title,
                    style: AppTextStyles.headlineLarge.copyWith(color: textPrimary),
                  ).animate().fadeIn(delay: 100.ms),
                  const SizedBox(height: 8),

                  // Instructor
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                        child: Text(
                          course.instructor[0].toUpperCase(),
                          style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(course.instructor,
                          style: AppTextStyles.bodyMedium
                              .copyWith(fontWeight: FontWeight.w500, color: textPrimary)),
                    ],
                  ).animate().fadeIn(delay: 150.ms),
                  const SizedBox(height: 16),

                  // Stats row
                  Row(
                    children: [
                      _statChip(Icons.star_rounded, AppColors.starColor,
                          course.rating.toStringAsFixed(1)),
                      const SizedBox(width: 12),
                      _statChip(Icons.access_time_rounded,
                          AppColors.primary, course.duration),
                      const SizedBox(width: 12),
                      _statChip(Icons.play_circle_outline_rounded,
                          AppColors.orange,
                          '${course.lessons} lessons'),
                      const SizedBox(width: 12),
                      _statChip(Icons.people_outline_rounded,
                          AppColors.green,
                          '${course.enrolledCount}'),
                    ],
                  ).animate().fadeIn(delay: 200.ms),
                  const SizedBox(height: 20),

                  // Divider
                  Divider(color: isDark ? const Color(0xFF334155) : AppColors.divider),
                  const SizedBox(height: 16),

                  // Description
                  Text('About this course',
                          style: AppTextStyles.titleLarge.copyWith(color: textPrimary))
                      .animate()
                      .fadeIn(delay: 250.ms),
                  const SizedBox(height: 8),
                  Text(course.description,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: isDark ? const Color(0xFF94A3B8) : null,
                          ))
                      .animate()
                      .fadeIn(delay: 280.ms),
                  const SizedBox(height: 32),

                  // Enroll / Watch buttons
                  if (_enrolled)
                    GestureDetector(
                      onTap: _watchVideo,
                      child: Container(
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.play_arrow_rounded,
                                color: Colors.white, size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Watch Video',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 300.ms)
                  else
                    Column(
                      children: [
                        GestureDetector(
                          onTap: _enrolling ? null : _enroll,
                          child: Container(
                            width: double.infinity,
                            height: 54,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: _enrolling
                                ? const Center(
                                    child: SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.5,
                                      ),
                                    ),
                                  )
                                : const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.school_rounded,
                                          color: Colors.white, size: 20),
                                      SizedBox(width: 8),
                                      Text(
                                        'Enroll Now',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _watchVideo,
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: AppColors.primary, width: 1.5),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.play_circle_outline_rounded,
                                    color: AppColors.primary, size: 20),
                                SizedBox(width: 8),
                                Text(
                                  'Preview Video',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: 340.ms),
                      ],
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, Color color, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark ? Colors.white : AppColors.textPrimary;
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}
