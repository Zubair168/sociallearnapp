import 'package:flutter_test/flutter_test.dart';
import 'package:sociallearnapp/features/courses/models/course_model.dart';
import 'package:sociallearnapp/features/courses/screens/courses_screen.dart';
import 'package:sociallearnapp/features/courses/widgets/course_subject_icon.dart';
import 'package:flutter/material.dart';

void main() {
  group('CourseModel Tests', () {
    test('CourseModel correctly initializes and exports toMap', () {
      const course = CourseModel(
        id: 'tyt_math_01',
        title: 'TYT Mathematics: Core Equations',
        instructor: 'Prof. Ahmet Yilmaz',
        thumbnail: 'https://images.unsplash.com/photo-1234',
        description: 'Master core mathematics equations and problem solving.',
        videoUrl: 'https://example.com/video.mp4',
        duration: '14 hours',
        rating: 4.85,
        enrolledCount: 3200,
        category: 'TYT',
        lessons: 36,
        solvedInfo: '24/36 Solved',
      );

      expect(course.id, 'tyt_math_01');
      expect(course.title, 'TYT Mathematics: Core Equations');
      expect(course.instructor, 'Prof. Ahmet Yilmaz');
      expect(course.rating, 4.85);
      expect(course.enrolledCount, 3200);
      expect(course.category, 'TYT');
      expect(course.lessons, 36);
      expect(course.solvedInfo, '24/36 Solved');

      final map = course.toMap();
      expect(map['title'], 'TYT Mathematics: Core Equations');
      expect(map['instructor'], 'Prof. Ahmet Yilmaz');
      expect(map['duration'], '14 hours');
      expect(map['rating'], 4.85);
      expect(map['enrolledCount'], 3200);
      expect(map['category'], 'TYT');
      expect(map['lessons'], 36);
      expect(map['solvedInfo'], '24/36 Solved');
    });

    test('CourseSubjectItem converts cleanly to CourseModel', () {
      const subjectItem = CourseSubjectItem(
        title: 'Physics',
        type: SubjectType.physics,
        iconBg: Color(0xFFE0F7FE),
        solvedText: '18/45 Solved',
        progress: 18 / 45,
        totalQuestions: 45,
        solvedQuestions: 18,
      );

      final model = subjectItem.toCourseModel('AYT');
      expect(model.id, 'ayt_physics');
      expect(model.title, 'Physics');
      expect(model.category, 'AYT');
      expect(model.lessons, 45);
      expect(model.solvedInfo, '18/45 Solved');
      expect(model.rating, 4.9);
      expect(model.instructor, 'Expert Educator');
    });
  });
}
