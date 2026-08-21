import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/core/constants/app_text_styles.dart';
import 'package:sociallearnapp/features/courses/models/course_model.dart';
import 'package:sociallearnapp/features/courses/screens/course_detail_screen.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final bool isEnrolled;

  const CourseCard({
    super.key,
    required this.course,
    this.isEnrolled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CourseDetailScreen(
            course: course,
            isEnrolled: isEnrolled,
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: course.thumbnail,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        child: const Icon(Icons.play_lesson_rounded,
                            color: AppColors.primary, size: 36),
                      ),
                    ),
                    // Play button overlay
                    Center(
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.play_arrow_rounded,
                            color: AppColors.primary, size: 22),
                      ),
                    ),
                    // Enrolled badge
                    if (isEnrolled)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Enrolled',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ),
                      ),
                    // Category badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          course.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
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

            // Info
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: AppTextStyles.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.instructor,
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Rating
                      const Icon(Icons.star_rounded,
                          color: AppColors.starColor, size: 14),
                      const SizedBox(width: 3),
                      Text(
                        course.rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                          width: 1,
                          height: 10,
                          color: AppColors.border),
                      const SizedBox(width: 8),
                      const Icon(Icons.access_time_rounded,
                          color: AppColors.textHint, size: 12),
                      const SizedBox(width: 3),
                      Text(
                        course.duration,
                        style: AppTextStyles.caption
                            .copyWith(fontSize: 11),
                      ),
                      const Spacer(),
                      Text(
                        '${course.lessons} lessons',
                        style: AppTextStyles.caption
                            .copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
