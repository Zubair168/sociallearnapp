import 'package:flutter/material.dart';
import 'package:sociallearnapp/features/courses/models/course_model.dart';
import 'package:sociallearnapp/features/courses/services/course_service.dart';

class CourseProvider extends ChangeNotifier {
  final CourseService _courseService = CourseService();

  int _selectedCategoryIndex = 0;
  int get selectedCategoryIndex => _selectedCategoryIndex;

  final List<String> _categories = [
    'All',
    'Mobile Dev',
    'Backend',
    'Design',
    'Data Science',
    'AI/ML',
  ];
  List<String> get categories => _categories;

  String get selectedCategory => _categories[_selectedCategoryIndex];

  bool _isEnrolling = false;
  bool get isEnrolling => _isEnrolling;

  String? _enrollingCourseId;
  String? get enrollingCourseId => _enrollingCourseId;

  // Change category
  void setCategory(int index) {
    if (_selectedCategoryIndex != index) {
      _selectedCategoryIndex = index;
      notifyListeners();
    }
  }

  // Course Streams
  Stream<List<CourseModel>> get coursesStream => _courseService.getCourses();

  Stream<List<String>> enrolledCoursesStream(String userId) =>
      _courseService.getEnrolledCourseIds(userId);

  // Enroll in course
  Future<bool> enrollInCourse({
    required String userId,
    required String courseId,
  }) async {
    try {
      _isEnrolling = true;
      _enrollingCourseId = courseId;
      notifyListeners();

      await _courseService.enrollUser(userId, courseId);

      _isEnrolling = false;
      _enrollingCourseId = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isEnrolling = false;
      _enrollingCourseId = null;
      notifyListeners();
      return false;
    }
  }

  // Seed sample data
  Future<void> seedSampleCourses() async {
    await _courseService.seedSampleCourses();
    notifyListeners();
  }
}
