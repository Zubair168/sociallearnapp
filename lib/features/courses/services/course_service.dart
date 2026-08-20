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
        'title': 'Flutter Masterclass 2024',
        'instructor': 'John Martinez',
        'thumbnail':
            'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=800',
        'description':
            'Master Flutter from scratch to advanced. Build stunning cross-platform apps with Firebase, state management, animations and much more.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        'duration': '12h 30m',
        'rating': 4.8,
        'enrolledCount': 3240,
        'category': 'Mobile Dev',
        'lessons': 48,
      },
      {
        'title': 'Firebase for Flutter Developers',
        'instructor': 'Sarah Chen',
        'thumbnail':
            'https://images.unsplash.com/photo-1555949963-ff9fe0c870eb?w=800',
        'description':
            'Learn Firebase Auth, Firestore, Storage, Cloud Functions and more. Build production-ready apps with the full Firebase suite.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        'duration': '8h 15m',
        'rating': 4.9,
        'enrolledCount': 2180,
        'category': 'Backend',
        'lessons': 32,
      },
      {
        'title': 'UI/UX Design Fundamentals',
        'instructor': 'Priya Sharma',
        'thumbnail':
            'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=800',
        'description':
            'Learn design principles, color theory, typography, and how to create beautiful user interfaces using Figma and Flutter.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        'duration': '6h 45m',
        'rating': 4.7,
        'enrolledCount': 1890,
        'category': 'Design',
        'lessons': 26,
      },
      {
        'title': 'Python for Data Science',
        'instructor': 'Alex Johnson',
        'thumbnail':
            'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=800',
        'description':
            'Complete Python course for data science. Pandas, NumPy, Matplotlib, Scikit-Learn and machine learning fundamentals.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
        'duration': '15h 20m',
        'rating': 4.6,
        'enrolledCount': 4560,
        'category': 'Data Science',
        'lessons': 60,
      },
      {
        'title': 'React Native Zero to Hero',
        'instructor': 'David Kim',
        'thumbnail':
            'https://images.unsplash.com/photo-1618761714954-0b8cd0026356?w=800',
        'description':
            'Build cross-platform mobile apps with React Native. Redux, Navigation, Native modules, and publishing to App Store.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4',
        'duration': '10h 00m',
        'rating': 4.5,
        'enrolledCount': 2900,
        'category': 'Mobile Dev',
        'lessons': 40,
      },
      {
        'title': 'Machine Learning with TensorFlow',
        'instructor': 'Fatima Al-Rashid',
        'thumbnail':
            'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?w=800',
        'description':
            'Deep learning, neural networks, CNNs, RNNs and deployment. Real-world ML projects from image classification to NLP.',
        'videoUrl':
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
        'duration': '18h 45m',
        'rating': 4.9,
        'enrolledCount': 5200,
        'category': 'AI/ML',
        'lessons': 72,
      },
    ];

    for (final course in courses) {
      final ref = _db.collection('courses').doc();
      batch.set(ref, course);
    }
    await batch.commit();
  }
}
