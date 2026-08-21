import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolvedTestRecord {
  final String id;
  final String title;
  final String subject;
  final String type; // TYT or AYT
  final String difficulty;
  final int diffColor;
  final int totalQuestions;
  final int correct;
  final int incorrect;
  final int unanswered;
  final String timeSpent;
  final DateTime timestamp;

  const SolvedTestRecord({
    required this.id,
    required this.title,
    required this.subject,
    required this.type,
    required this.difficulty,
    required this.diffColor,
    required this.totalQuestions,
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    required this.timeSpent,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'subject': subject,
        'type': type,
        'difficulty': difficulty,
        'diffColor': diffColor,
        'totalQuestions': totalQuestions,
        'correct': correct,
        'incorrect': incorrect,
        'unanswered': unanswered,
        'timeSpent': timeSpent,
        'timestamp': timestamp.toIso8601String(),
      };

  factory SolvedTestRecord.fromMap(Map<String, dynamic> map) =>
      SolvedTestRecord(
        id: map['id'] ?? '',
        title: map['title'] ?? 'General Test',
        subject: map['subject'] ?? 'Mathematics',
        type: map['type'] ?? 'TYT',
        difficulty: map['difficulty'] ?? 'Medium',
        diffColor: map['diffColor'] ?? 0xFF2A3BD4,
        totalQuestions: map['totalQuestions'] ?? 8,
        correct: map['correct'] ?? 0,
        incorrect: map['incorrect'] ?? 0,
        unanswered: map['unanswered'] ?? 0,
        timeSpent: map['timeSpent'] ?? '00:25',
        timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      );

  String toJson() => jsonEncode(toMap());
  factory SolvedTestRecord.fromJson(String source) =>
      SolvedTestRecord.fromMap(jsonDecode(source));
}

class StudyTaskRecord {
  final String id;
  final String title;
  final String course;
  final String type; // TYT or AYT
  final int durationMinutes;
  String note;
  bool isCompleted;
  final int iconBgColor;
  final int iconCodePoint;

  StudyTaskRecord({
    required this.id,
    required this.title,
    required this.course,
    required this.type,
    required this.durationMinutes,
    this.note = '',
    this.isCompleted = false,
    this.iconBgColor = 0xFFE0F2FE,
    this.iconCodePoint = 0xe123,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'course': course,
        'type': type,
        'durationMinutes': durationMinutes,
        'note': note,
        'isCompleted': isCompleted,
        'iconBgColor': iconBgColor,
        'iconCodePoint': iconCodePoint,
      };

  factory StudyTaskRecord.fromMap(Map<String, dynamic> map) => StudyTaskRecord(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        course: map['course'] ?? 'General',
        type: map['type'] ?? 'TYT',
        durationMinutes: map['durationMinutes'] ?? 30,
        note: map['note'] ?? '',
        isCompleted: map['isCompleted'] ?? false,
        iconBgColor: map['iconBgColor'] ?? 0xFFE0F2FE,
        iconCodePoint: map['iconCodePoint'] ?? 0xe123,
      );

  String toJson() => jsonEncode(toMap());
  factory StudyTaskRecord.fromJson(String source) =>
      StudyTaskRecord.fromMap(jsonDecode(source));
}

class ProgressStorageService {
  static const String _kWatchedVideosKey = 'progress_watched_videos';
  static const String _kSolvedCountKey = 'progress_solved_count';
  static const String _kCorrectCountKey = 'progress_correct_count';
  static const String _kIncorrectCountKey = 'progress_incorrect_count';
  static const String _kDailyGoalKey = 'progress_daily_goal';
  static const String _kDailySolvedKey = 'progress_daily_solved';
  static const String _kStreakDaysKey = 'progress_streak_days';
  static const String _kLastSolvedDateKey = 'progress_last_solved_date';
  static const String _kSolvedTestsKey = 'progress_solved_tests_list';
  static const String _kStudyTasksKey = 'progress_study_tasks_list';

  // ── Save / Toggle Watched Video ───────────────────────────────────────────
  static Future<bool> toggleVideoWatched(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kWatchedVideosKey) ?? [];
    if (list.contains(videoId)) {
      list.remove(videoId);
    } else {
      list.add(videoId);
    }
    await prefs.setStringList(_kWatchedVideosKey, list);
    return list.contains(videoId);
  }

  static Future<bool> isVideoWatched(String videoId) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_kWatchedVideosKey) ?? [];
    return list.contains(videoId);
  }

  static Future<List<String>> getWatchedVideoIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_kWatchedVideosKey) ?? [];
  }

  // ── Question Stats Storage ────────────────────────────────────────────────
  static Future<void> recordTestResult({
    required int correct,
    required int incorrect,
    required int unanswered,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final totalSolved = (prefs.getInt(_kSolvedCountKey) ?? 48) + (correct + incorrect + unanswered);
    final totalCorrect = (prefs.getInt(_kCorrectCountKey) ?? 40) + correct;
    final totalIncorrect = (prefs.getInt(_kIncorrectCountKey) ?? 6) + incorrect;

    await prefs.setInt(_kSolvedCountKey, totalSolved);
    await prefs.setInt(_kCorrectCountKey, totalCorrect);
    await prefs.setInt(_kIncorrectCountKey, totalIncorrect);

    // Update Daily Solved
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final lastDate = prefs.getString(_kLastSolvedDateKey) ?? '';
    int daily = prefs.getInt(_kDailySolvedKey) ?? 10;

    if (lastDate == todayStr) {
      daily += (correct + incorrect + unanswered);
    } else {
      daily = (correct + incorrect + unanswered);
      await prefs.setString(_kLastSolvedDateKey, todayStr);
    }
    await prefs.setInt(_kDailySolvedKey, daily);
  }

  static Future<Map<String, int>> getOverallProgressStats() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'solved': prefs.getInt(_kSolvedCountKey) ?? 48,
      'correct': prefs.getInt(_kCorrectCountKey) ?? 40,
      'incorrect': prefs.getInt(_kIncorrectCountKey) ?? 6,
      'dailyGoal': prefs.getInt(_kDailyGoalKey) ?? 10,
      'dailySolved': prefs.getInt(_kDailySolvedKey) ?? 10,
      'streak': prefs.getInt(_kStreakDaysKey) ?? 5,
    };
  }

  static Future<void> setDailyGoal(int goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kDailyGoalKey, goal);
  }

  // ── Solved Tests History List ─────────────────────────────────────────────
  static Future<List<SolvedTestRecord>> getSolvedTestRecords() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_kSolvedTestsKey);
    if (rawList == null || rawList.isEmpty) {
      // Seed default real solved history
      final now = DateTime.now();
      final defaultList = [
        SolvedTestRecord(
          id: 'test_1',
          title: 'Linear Equations & Systems Test-1',
          subject: 'Mathematics',
          type: 'TYT',
          difficulty: 'Past Exam',
          diffColor: 0xFFEF4444,
          totalQuestions: 8,
          correct: 8,
          incorrect: 0,
          unanswered: 0,
          timeSpent: '00:26',
          timestamp: now.subtract(const Duration(minutes: 35)),
        ),
        SolvedTestRecord(
          id: 'test_2',
          title: 'Algebra - Quadratic Polynomials',
          subject: 'Mathematics',
          type: 'AYT',
          difficulty: 'Easy',
          diffColor: 0xFF22C55E,
          totalQuestions: 8,
          correct: 6,
          incorrect: 1,
          unanswered: 1,
          timeSpent: '00:22',
          timestamp: now.subtract(const Duration(hours: 2, minutes: 10)),
        ),
        SolvedTestRecord(
          id: 'test_3',
          title: 'Probability & Permutations Practice',
          subject: 'Mathematics',
          type: 'AYT',
          difficulty: 'Easy',
          diffColor: 0xFF22C55E,
          totalQuestions: 8,
          correct: 6,
          incorrect: 2,
          unanswered: 0,
          timeSpent: '00:24',
          timestamp: now.subtract(const Duration(hours: 4)),
        ),
        SolvedTestRecord(
          id: 'test_4',
          title: 'Pythagorean Theorem & Trigonometry',
          subject: 'Mathematics',
          type: 'AYT',
          difficulty: 'Past Exam',
          diffColor: 0xFFEF4444,
          totalQuestions: 8,
          correct: 7,
          incorrect: 1,
          unanswered: 0,
          timeSpent: '00:28',
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
        SolvedTestRecord(
          id: 'test_5',
          title: 'Newtonian Dynamics & Forces Review',
          subject: 'Physics',
          type: 'TYT',
          difficulty: 'Medium',
          diffColor: 0xFFF59E0B,
          totalQuestions: 10,
          correct: 8,
          incorrect: 1,
          unanswered: 1,
          timeSpent: '00:30',
          timestamp: now.subtract(const Duration(days: 1, hours: 3)),
        ),
        SolvedTestRecord(
          id: 'test_6',
          title: 'Chemical Bonds & Stoichiometry Drill',
          subject: 'Chemistry',
          type: 'TYT',
          difficulty: 'Easy',
          diffColor: 0xFF22C55E,
          totalQuestions: 8,
          correct: 7,
          incorrect: 1,
          unanswered: 0,
          timeSpent: '00:20',
          timestamp: now.subtract(const Duration(days: 2, hours: 4)),
        ),
      ];
      await saveSolvedTestRecords(defaultList);
      return defaultList;
    }
    return rawList.map((str) => SolvedTestRecord.fromJson(str)).toList();
  }

  static Future<void> saveSolvedTestRecords(List<SolvedTestRecord> records) async {
    final prefs = await SharedPreferences.getInstance();
    final strList = records.map((r) => r.toJson()).toList();
    await prefs.setStringList(_kSolvedTestsKey, strList);
  }

  static Future<void> addSolvedTestRecord(SolvedTestRecord record) async {
    final current = await getSolvedTestRecords();
    current.insert(0, record);
    await saveSolvedTestRecords(current);
  }

  static Future<void> clearAllProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kWatchedVideosKey);
    await prefs.remove(_kSolvedCountKey);
    await prefs.remove(_kCorrectCountKey);
    await prefs.remove(_kIncorrectCountKey);
    await prefs.remove(_kDailyGoalKey);
    await prefs.remove(_kDailySolvedKey);
    await prefs.remove(_kStreakDaysKey);
    await prefs.remove(_kLastSolvedDateKey);
    await prefs.remove(_kSolvedTestsKey);
    await prefs.remove(_kStudyTasksKey);
  }

  // ── Study Plan Tasks Persistent Storage ─────────────────────────────────────
  static Future<List<StudyTaskRecord>> getStudyTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = prefs.getStringList(_kStudyTasksKey);
    if (rawList == null || rawList.isEmpty) {
      final initialTasks = [
        StudyTaskRecord(
          id: 'task_1',
          title: 'Linear Equations',
          course: 'Mathematics',
          type: 'TYT',
          durationMinutes: 60,
          note: 'Complete this and revise it after 2 days. This is an example of a key note for exam prep.',
          isCompleted: true,
          iconBgColor: 0xFFE0F2FE,
          iconCodePoint: 0xe123,
        ),
        StudyTaskRecord(
          id: 'task_2',
          title: 'World Literature & Poetry',
          course: 'Literature',
          type: 'AYT',
          durationMinutes: 30,
          note: 'Complete this and revise key periods after 2 days.',
          isCompleted: false,
          iconBgColor: 0xFFFFE4E6,
          iconCodePoint: 0xe3e3,
        ),
        StudyTaskRecord(
          id: 'task_3',
          title: 'Polynomials & Functions',
          course: 'Mathematics',
          type: 'AYT',
          durationMinutes: 45,
          note: 'Focus on remainder theorem and root factorization.',
          isCompleted: true,
          iconBgColor: 0xFFE0F2FE,
          iconCodePoint: 0xe2c6,
        ),
        StudyTaskRecord(
          id: 'task_4',
          title: 'Electrostatics & Electric Fields',
          course: 'Physics',
          type: 'AYT',
          durationMinutes: 60,
          note: 'Solve 20 past official exam questions.',
          isCompleted: false,
          iconBgColor: 0xFFFEF3C7,
          iconCodePoint: 0xe231,
        ),
      ];
      await saveStudyTasks(initialTasks);
      return initialTasks;
    }
    return rawList.map((str) => StudyTaskRecord.fromJson(str)).toList();
  }

  static Future<void> saveStudyTasks(List<StudyTaskRecord> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final strList = tasks.map((t) => t.toJson()).toList();
    await prefs.setStringList(_kStudyTasksKey, strList);
  }

  static Future<void> addStudyTask(StudyTaskRecord task) async {
    final current = await getStudyTasks();
    current.add(task);
    await saveStudyTasks(current);
  }

  static Future<void> toggleStudyTask(String id) async {
    final current = await getStudyTasks();
    final idx = current.indexWhere((t) => t.id == id);
    if (idx != -1) {
      current[idx].isCompleted = !current[idx].isCompleted;
      await saveStudyTasks(current);
    }
  }

  static Future<void> updateStudyTaskNote(String id, String note) async {
    final current = await getStudyTasks();
    final idx = current.indexWhere((t) => t.id == id);
    if (idx != -1) {
      current[idx].note = note;
      await saveStudyTasks(current);
    }
  }

  static Future<void> deleteStudyTask(String id) async {
    final current = await getStudyTasks();
    current.removeWhere((t) => t.id == id);
    await saveStudyTasks(current);
  }
}

class ProgressProvider extends ChangeNotifier {
  int _solved = 48;
  int _correct = 40;
  int _incorrect = 6;
  int _unanswered = 2;
  int _dailyGoal = 10;
  int _dailySolved = 10;
  int _streak = 5;
  Set<String> _watchedVideos = {'v2', 'v3', 'v4', 'v6', 'v7'};
  List<SolvedTestRecord> _solvedTests = [];
  List<StudyTaskRecord> _studyTasks = [];

  int get solved => _solved;
  int get correct => _correct;
  int get incorrect => _incorrect;
  int get unanswered => _unanswered;
  int get dailyGoal => _dailyGoal;
  int get dailySolved => _dailySolved;
  int get streak => _streak;
  Set<String> get watchedVideos => _watchedVideos;
  List<SolvedTestRecord> get solvedTests => _solvedTests;
  List<StudyTaskRecord> get studyTasks => _studyTasks;

  int get completedTasksCount => _studyTasks.where((t) => t.isCompleted).length;
  int get totalTasksCount => _studyTasks.length;
  int get remainingTasksCount => _studyTasks.where((t) => !t.isCompleted).length;
  double get tasksProgress =>
      totalTasksCount > 0 ? completedTasksCount / totalTasksCount : 0.0;
  int get tasksProgressPct =>
      totalTasksCount > 0 ? ((completedTasksCount / totalTasksCount) * 100).toInt() : 0;

  ProgressProvider() {
    loadProgress();
  }

  Future<void> loadProgress() async {
    final stats = await ProgressStorageService.getOverallProgressStats();
    _solved = stats['solved'] ?? 48;
    _correct = stats['correct'] ?? 40;
    _incorrect = stats['incorrect'] ?? 6;
    _dailyGoal = stats['dailyGoal'] ?? 10;
    _dailySolved = stats['dailySolved'] ?? 10;
    _streak = stats['streak'] ?? 5;

    final watched = await ProgressStorageService.getWatchedVideoIds();
    if (watched.isNotEmpty) {
      _watchedVideos = watched.toSet();
    }

    _solvedTests = await ProgressStorageService.getSolvedTestRecords();
    _studyTasks = await ProgressStorageService.getStudyTasks();
    notifyListeners();
  }

  Future<void> toggleStudyTask(String id) async {
    final idx = _studyTasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _studyTasks[idx].isCompleted = !_studyTasks[idx].isCompleted;
      notifyListeners();
      await ProgressStorageService.saveStudyTasks(_studyTasks);
    }
  }

  Future<void> addStudyTask(StudyTaskRecord task) async {
    _studyTasks.add(task);
    notifyListeners();
    await ProgressStorageService.saveStudyTasks(_studyTasks);
  }

  Future<void> updateStudyTaskNote(String id, String note) async {
    final idx = _studyTasks.indexWhere((t) => t.id == id);
    if (idx != -1) {
      _studyTasks[idx].note = note;
      notifyListeners();
      await ProgressStorageService.saveStudyTasks(_studyTasks);
    }
  }

  Future<void> deleteStudyTask(String id) async {
    _studyTasks.removeWhere((t) => t.id == id);
    notifyListeners();
    await ProgressStorageService.saveStudyTasks(_studyTasks);
  }

  Future<void> toggleWatched(String videoId) async {
    final isWatched = await ProgressStorageService.toggleVideoWatched(videoId);
    if (isWatched) {
      _watchedVideos.add(videoId);
    } else {
      _watchedVideos.remove(videoId);
    }
    notifyListeners();
  }

  bool isWatched(String videoId) => _watchedVideos.contains(videoId);

  Future<void> addTestResult({
    required int correct,
    required int incorrect,
    required int unanswered,
    String title = 'Topic Practice Test',
    String subject = 'Mathematics',
    String type = 'TYT',
    String difficulty = 'Medium',
    int diffColor = 0xFF2A3BD4,
    String timeSpent = '00:25',
  }) async {
    await ProgressStorageService.recordTestResult(
      correct: correct,
      incorrect: incorrect,
      unanswered: unanswered,
    );

    final record = SolvedTestRecord(
      id: 'test_${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      subject: subject,
      type: type,
      difficulty: difficulty,
      diffColor: diffColor,
      totalQuestions: correct + incorrect + unanswered,
      correct: correct,
      incorrect: incorrect,
      unanswered: unanswered,
      timeSpent: timeSpent,
      timestamp: DateTime.now(),
    );

    await ProgressStorageService.addSolvedTestRecord(record);

    _solved += (correct + incorrect + unanswered);
    _correct += correct;
    _incorrect += incorrect;
    _unanswered = unanswered;
    _dailySolved += (correct + incorrect + unanswered);
    _solvedTests.insert(0, record);

    notifyListeners();
  }

  Future<void> updateDailyGoal(int goal) async {
    _dailyGoal = goal;
    await ProgressStorageService.setDailyGoal(goal);
    notifyListeners();
  }

  Future<void> resetHistory() async {
    await ProgressStorageService.clearAllProgress();
    _solved = 0;
    _correct = 0;
    _incorrect = 0;
    _unanswered = 0;
    _dailySolved = 0;
    _watchedVideos.clear();
    _solvedTests.clear();
    _studyTasks = await ProgressStorageService.getStudyTasks();
    notifyListeners();
  }
}
