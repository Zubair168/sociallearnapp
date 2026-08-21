import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProgressStorageService {
  static const String _kWatchedVideosKey = 'progress_watched_videos';
  static const String _kSolvedCountKey = 'progress_solved_count';
  static const String _kCorrectCountKey = 'progress_correct_count';
  static const String _kIncorrectCountKey = 'progress_incorrect_count';
  static const String _kDailyGoalKey = 'progress_daily_goal';
  static const String _kDailySolvedKey = 'progress_daily_solved';
  static const String _kStreakDaysKey = 'progress_streak_days';
  static const String _kLastSolvedDateKey = 'progress_last_solved_date';

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

  int get solved => _solved;
  int get correct => _correct;
  int get incorrect => _incorrect;
  int get unanswered => _unanswered;
  int get dailyGoal => _dailyGoal;
  int get dailySolved => _dailySolved;
  int get streak => _streak;
  Set<String> get watchedVideos => _watchedVideos;

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
    notifyListeners();
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
  }) async {
    await ProgressStorageService.recordTestResult(
      correct: correct,
      incorrect: incorrect,
      unanswered: unanswered,
    );
    _solved += (correct + incorrect + unanswered);
    _correct += correct;
    _incorrect += incorrect;
    _unanswered = unanswered;
    _dailySolved += (correct + incorrect + unanswered);
    notifyListeners();
  }

  Future<void> updateDailyGoal(int goal) async {
    _dailyGoal = goal;
    await ProgressStorageService.setDailyGoal(goal);
    notifyListeners();
  }
}
