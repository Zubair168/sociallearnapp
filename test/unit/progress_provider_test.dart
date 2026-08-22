import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sociallearnapp/features/progress/services/progress_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ProgressProvider and StudyTask Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('StudyTaskRecord serialization toMap and fromMap works correctly', () {
      final task = StudyTaskRecord(
        id: 'task_test_1',
        title: 'Trigonometry Formulas',
        course: 'Mathematics',
        type: 'AYT',
        durationMinutes: 45,
        note: 'Review unit circle and radian conversions.',
        isCompleted: false,
        iconBgColor: 0xFFE0F2FE,
        iconCodePoint: 0xe123,
      );

      final map = task.toMap();
      expect(map['id'], 'task_test_1');
      expect(map['title'], 'Trigonometry Formulas');
      expect(map['course'], 'Mathematics');
      expect(map['type'], 'AYT');
      expect(map['durationMinutes'], 45);
      expect(map['isCompleted'], false);

      final reconstructed = StudyTaskRecord.fromMap(map);
      expect(reconstructed.id, task.id);
      expect(reconstructed.title, task.title);
      expect(reconstructed.course, task.course);
      expect(reconstructed.type, task.type);
      expect(reconstructed.durationMinutes, task.durationMinutes);
    });

    test('SolvedTestRecord calculation and json encoding works correctly', () {
      final record = SolvedTestRecord(
        id: 'test_record_1',
        title: 'Linear Equations Test-1',
        subject: 'Mathematics',
        type: 'TYT',
        difficulty: 'Past Exam',
        diffColor: 0xFFEF4444,
        totalQuestions: 10,
        correct: 8,
        incorrect: 2,
        unanswered: 0,
        timeSpent: '00:26',
        timestamp: DateTime(2026, 1, 15, 10, 30),
      );

      final jsonStr = record.toJson();
      final decoded = SolvedTestRecord.fromJson(jsonStr);

      expect(decoded.id, 'test_record_1');
      expect(decoded.correct, 8);
      expect(decoded.incorrect, 2);
      expect(decoded.unanswered, 0);
      expect(decoded.totalQuestions, 10);
      expect(decoded.timeSpent, '00:26');
    });

    test('ProgressProvider initializes and calculates progress ratios correctly', () async {
      final provider = ProgressProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      await provider.loadProgress();

      expect(provider.totalTasksCount, equals(4));
      expect(provider.completedTasksCount, equals(2));
      expect(provider.tasksProgress, equals(0.5));

      final firstTask = provider.studyTasks.first;
      expect(firstTask.isCompleted, isTrue);

      await provider.toggleStudyTask(firstTask.id);

      expect(provider.completedTasksCount, equals(1));
      expect(provider.studyTasks.first.isCompleted, isFalse);
    });

    test('Adding a new task increases task count and updates provider state', () async {
      final provider = ProgressProvider();
      await Future.delayed(const Duration(milliseconds: 50));
      await provider.loadProgress();

      final initialCount = provider.totalTasksCount;
      await provider.addStudyTask(
        StudyTaskRecord(
          id: 'test_task_new',
          title: 'Derivatives & Applications',
          course: 'Mathematics',
          type: 'AYT',
          durationMinutes: 60,
          note: 'Complete 30 practice problems',
        ),
      );

      expect(provider.totalTasksCount, equals(initialCount + 1));
      expect(provider.studyTasks.any((t) => t.title == 'Derivatives & Applications'), isTrue);
    });
  });
}
