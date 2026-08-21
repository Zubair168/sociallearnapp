import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Fetch all courses ────────────────────────────────────────────────────
  Stream<List<CourseModel>> getCourses() {
    return _db.collection('courses').snapshots().map(
          (snap) => snap.docs.map(CourseModel.fromFirestore).toList(),
        );
  }

  // ─── Fetch courses by category ────────────────────────────────────────────
  Stream<List<CourseModel>> getCoursesByCategory(String category) {
    return _db
        .collection('courses')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snap) => snap.docs.map(CourseModel.fromFirestore).toList());
  }

  // ─── Enroll user in a course ─────────────────────────────────────────────
  Future<void> enrollUser(String userId, String courseId) async {
    await _db
        .collection('users')
        .doc(userId)
        .collection('enrollments')
        .doc(courseId)
        .set({
      'enrolledAt': FieldValue.serverTimestamp(),
      'courseId': courseId,
    });
    // Increment enrolled count
    await _db
        .collection('courses')
        .doc(courseId)
        .update({'enrolledCount': FieldValue.increment(1)});
  }

  // ─── Check if user is enrolled ───────────────────────────────────────────
  Future<bool> isEnrolled(String userId, String courseId) async {
    final doc = await _db
        .collection('users')
        .doc(userId)
        .collection('enrollments')
        .doc(courseId)
        .get();
    return doc.exists;
  }

  // ─── Get enrolled courses ────────────────────────────────────────────────
  Stream<List<String>> getEnrolledCourseIds(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('enrollments')
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.id).toList());
  }

  // ─── Seed sample courses (call once from dev) ─────────────────────────────
  Future<void> seedSampleCourses() async {
    final batch = _db.batch();
    final courses = [
      {
        'title': 'TYT Mathematics: Complete Problem Solving & Equations',
        'instructor': 'Prof. Ahmet Yılmaz',
        'thumbnail':
            'https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=800',
        'description':
            'Comprehensive TYT Mathematics curriculum covering Linear Equations, Quadratic Systems, Polynomials, and high-yield problem solving strategies.',
        'videoUrl':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        'duration': '12h 30m',
        'rating': 4.9,
        'enrolledCount': 8420,
        'category': 'TYT',
        'lessons': 48,
      },
      {
        'title': 'AYT Advanced Mathematics: Functions, Derivatives & Integrals',
        'instructor': 'Prof. Ahmet Yılmaz',
        'thumbnail':
            'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=800',
        'description':
            'Master advanced functions, limits, continuity, derivative applications, and definite integration for AYT success.',
        'videoUrl':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        'duration': '16h 20m',
        'rating': 4.95,
        'enrolledCount': 6180,
        'category': 'AYT',
        'lessons': 54,
      },
      {
        'title': 'TYT-AYT Physics: Mechanics, Optics & Thermodynamics',
        'instructor': 'Dr. Zeynep Kaya',
        'thumbnail':
            'https://images.unsplash.com/photo-1636466497217-26a8cbeaf0aa?w=800',
        'description':
            'Detailed conceptual physics with ÖSYM question analysis, visual experiments, and formula shortcuts.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        'duration': '10h 15m',
        'rating': 4.85,
        'enrolledCount': 5290,
        'category': 'TYT',
        'lessons': 36,
      },
      {
        'title': 'TYT Turkish: Grammar Mastery & Reading Comprehension',
        'instructor': 'Mehmet Demir',
        'thumbnail':
            'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=800',
        'description':
            'Speed reading techniques, paragraph tactics, spelling rules, and punctuation questions to maximize TYT Turkish net score.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        'duration': '8h 45m',
        'rating': 4.8,
        'enrolledCount': 7890,
        'category': 'TYT',
        'lessons': 30,
      },
      {
        'title': 'TYT-AYT Chemistry: Organic & Modern Chemistry',
        'instructor': 'Dr. Elif Arslan',
        'thumbnail':
            'https://images.unsplash.com/photo-1532094349884-543bc11b234d?w=800',
        'description':
            'Chemical equilibria, electrochemistry, and organic chemistry reaction mechanisms with step-by-step solutions.',
        'videoUrl':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
        'duration': '9h 10m',
        'rating': 4.75,
        'enrolledCount': 4120,
        'category': 'AYT',
        'lessons': 28,
      },
      {
        'title': 'TYT-AYT Biology: Genetics, Ecology & Human Systems',
        'instructor': 'Dr. Canan Yıldız',
        'thumbnail':
            'https://images.unsplash.com/photo-1530210124550-912dc1381cb8?w=800',
        'description':
            'High-yield biology concept maps, endocrine system, nervous system, and Mendel genetics.',
        'videoUrl':
            'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
        'duration': '11h 00m',
        'rating': 4.9,
        'enrolledCount': 5600,
        'category': 'TYT',
        'lessons': 42,
      },
    ];

    for (final course in courses) {
      final ref = _db.collection('courses').doc();
      batch.set(ref, course);
    }
    await batch.commit();
  }
}
