import 'package:cloud_firestore/cloud_firestore.dart';

class CourseModel {
  final String id;
  final String title;
  final String instructor;
  final String thumbnail;
  final String description;
  final String videoUrl;
  final String duration;
  final double rating;
  final int enrolledCount;
  final String category;
  final int lessons;
  final String? svgAsset;
  final String? solvedInfo;

  const CourseModel({
    required this.id,
    required this.title,
    required this.instructor,
    required this.thumbnail,
    required this.description,
    required this.videoUrl,
    required this.duration,
    required this.rating,
    required this.enrolledCount,
    required this.category,
    required this.lessons,
    this.svgAsset,
    this.solvedInfo,
  });

  factory CourseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CourseModel(
      id: doc.id,
      title: data['title'] ?? '',
      instructor: data['instructor'] ?? '',
      thumbnail: data['thumbnail'] ?? '',
      description: data['description'] ?? '',
      videoUrl: data['videoUrl'] ?? '',
      duration: data['duration'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      enrolledCount: (data['enrolledCount'] ?? 0) as int,
      category: data['category'] ?? '',
      lessons: (data['lessons'] ?? 0) as int,
      svgAsset: data['svgAsset'],
      solvedInfo: data['solvedInfo'],
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'instructor': instructor,
        'thumbnail': thumbnail,
        'description': description,
        'videoUrl': videoUrl,
        'duration': duration,
        'rating': rating,
        'enrolledCount': enrolledCount,
        'category': category,
        'lessons': lessons,
        'svgAsset': svgAsset,
        'solvedInfo': solvedInfo,
      };
}
