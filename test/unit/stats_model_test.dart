import 'package:flutter_test/flutter_test.dart';
import 'package:sociallearnapp/features/courses/screens/topic_analysis_screen.dart';

void main() {
  group('Stats and Analysis Model Tests', () {
    test('TopicAnalysisItem calculates accuracy percentages correctly', () {
      final item = TopicAnalysisItem(
        title: 'Linear Equations',
        solvedQuestions: 10,
        correct: 8,
        incorrect: 1,
        unanswered: 1,
        askedIn2025: 10,
        yearlyStats: {
          'YKS 2023': 12,
          'YKS 2024': 15,
          'YKS 2025': 4,
        },
        isExpanded: false,
      );

      final total = item.correct + item.incorrect + item.unanswered;
      expect(total, 10);
      final accuracy = (item.correct / total) * 100;
      expect(accuracy, 80.0);
      expect(item.yearlyStats.length, 3);
      expect(item.yearlyStats['YKS 2024'], 15);

      item.isExpanded = true;
      expect(item.isExpanded, true);
    });

    test('Topic item edge cases with 0 solved handled gracefully', () {
      final item = TopicAnalysisItem(
        title: 'Integral Calculus',
        solvedQuestions: 0,
        correct: 0,
        incorrect: 0,
        unanswered: 0,
        askedIn2025: 6,
        yearlyStats: {},
        isExpanded: false,
      );

      final total = item.correct + item.incorrect + item.unanswered;
      final accuracy = total == 0 ? 0.0 : (item.correct / total) * 100;
      expect(total, 0);
      expect(accuracy, 0.0);
    });
  });
}
