import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sociallearnapp/features/courses/models/course_model.dart';
import 'package:sociallearnapp/shared/widgets/course_card.dart';

void main() {
  testWidgets('CourseCard displays title, instructor, duration, lessons and rating',
      (WidgetTester tester) async {
    const testCourse = CourseModel(
      id: 'math_course_1',
      title: 'TYT Comprehensive Mathematics',
      instructor: 'Dr. Zeynep Kaya',
      thumbnail: 'https://images.unsplash.com/photo-test',
      description: 'Course description for test',
      videoUrl: 'https://example.com/test.mp4',
      duration: '16h 40m',
      rating: 4.9,
      enrolledCount: 1540,
      category: 'TYT',
      lessons: 42,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CourseCard(course: testCourse),
        ),
      ),
    );

    expect(find.text('TYT Comprehensive Mathematics'), findsOneWidget);
    expect(find.text('Dr. Zeynep Kaya'), findsOneWidget);
    expect(find.text('16h 40m'), findsOneWidget);
    expect(find.text('42 lessons'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('TYT'), findsOneWidget);
  });
}
