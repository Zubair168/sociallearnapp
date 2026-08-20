import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/core/constants/app_text_styles.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/courses/models/course_model.dart';
import 'package:sociallearnapp/features/courses/services/course_service.dart';
import 'package:sociallearnapp/shared/widgets/course_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;
  int _selectedCategory = 0;
  final CourseService _courseService = CourseService();

  final List<String> _categories = [
    'All',
    'Mobile Dev',
    'Backend',
    'Design',
    'Data Science',
    'AI/ML',
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _seedCourses() async {
    await _courseService.seedSampleCourses();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Sample courses added to Firestore!'),
          backgroundColor: AppColors.green,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    final name = user?.displayName?.split(' ').first ?? 'Learner';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: _buildDrawer(user, auth),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _HomeTab(
            scaffoldKey: _scaffoldKey,
            userName: name,
            categories: _categories,
            selectedCategory: _selectedCategory,
            onCategoryChanged: (i) => setState(() => _selectedCategory = i),
            courseService: _courseService,
            userId: user?.uid ?? '',
            onSeed: _seedCourses,
          ),
          _MyCoursesTab(
            userId: user?.uid ?? '',
            courseService: _courseService,
          ),
          _ProfileTab(user: user, auth: auth),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) => setState(() => _selectedTab = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'My Courses'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildDrawer(User? user, AuthService auth) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            // Profile header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: const BoxDecoration(color: AppColors.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Text(
                            (user?.displayName?.isNotEmpty == true)
                                ? user!.displayName![0].toUpperCase()
                                : 'L',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w700),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user?.displayName ?? 'Learner',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  Text(
                    user?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            _drawerItem(Icons.home_rounded, 'Home', () {
              Navigator.pop(context);
              setState(() => _selectedTab = 0);
            }),
            _drawerItem(Icons.menu_book_rounded, 'My Courses', () {
              Navigator.pop(context);
              setState(() => _selectedTab = 1);
            }),
            _drawerItem(Icons.video_library_rounded, 'Video Lectures', () {
              Navigator.pop(context);
            }),
            _drawerItem(Icons.person_rounded, 'Profile', () {
              Navigator.pop(context);
              setState(() => _selectedTab = 2);
            }),
            const Divider(height: 1),
            const Spacer(),
            _drawerItem(
              Icons.logout_rounded,
              'Log Out',
              () async {
                Navigator.pop(context);
                await auth.signOut();
              },
              color: Colors.red,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon,
          color: color ?? AppColors.textSecondary, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      onTap: onTap,
      dense: true,
    );
  }
}

// ─── Home Tab ───────────────────────────────────────────────────────────────

class _HomeTab extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String userName;
  final List<String> categories;
  final int selectedCategory;
  final ValueChanged<int> onCategoryChanged;
  final CourseService courseService;
  final String userId;
  final VoidCallback onSeed;

  const _HomeTab({
    required this.scaffoldKey,
    required this.userName,
    required this.categories,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.courseService,
    required this.userId,
    required this.onSeed,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ── App bar ──────────────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 130,
          floating: false,
          pinned: true,
          backgroundColor: AppColors.primary,
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => scaffoldKey.currentState?.openDrawer(),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Colors.white),
              onPressed: () {},
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () {},
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.white.withOpacity(0.25),
                  child: Text(
                    userName[0].toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(color: AppColors.primary),
              padding: const EdgeInsets.fromLTRB(20, 90, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        fontFamily: 'Poppins'),
                  ),
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // ── Body ─────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Category tabs
              SizedBox(
                height: 38,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (ctx, i) {
                    final selected = i == selectedCategory;
                    return GestureDetector(
                      onTap: () => onCategoryChanged(i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                        child: Text(
                          categories[i],
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // Section title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('All Courses', style: AppTextStyles.headlineMedium),
                    GestureDetector(
                      onTap: onSeed,
                      child: Text(
                        'Add Sample Data',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        // ── Course stream ─────────────────────────────────────────────
        StreamBuilder<List<CourseModel>>(
          stream: courseService.getCourses(),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const SliverToBoxAdapter(
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(40),
                  child: CircularProgressIndicator(color: AppColors.primary),
                )),
              );
            }
            if (!snap.hasData || snap.data!.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Icon(Icons.school_outlined,
                            size: 64, color: AppColors.textHint),
                        const SizedBox(height: 16),
                        Text('No courses yet',
                            style: AppTextStyles.titleMedium),
                        const SizedBox(height: 8),
                        Text('Tap "Add Sample Data" to seed courses',
                            style: AppTextStyles.bodyMedium),
                      ],
                    ),
                  ),
                ),
              );
            }

            final allCourses = snap.data!;
            final filtered = selectedCategory == 0
                ? allCourses
                : allCourses
                    .where((c) =>
                        c.category == categories[selectedCategory])
                    .toList();

            return StreamBuilder<List<String>>(
              stream: courseService.getEnrolledCourseIds(userId),
              builder: (ctx2, enrollSnap) {
                final enrolledIds = enrollSnap.data ?? [];
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => CourseCard(
                        course: filtered[i],
                        isEnrolled: enrolledIds.contains(filtered[i].id),
                      ).animate().fadeIn(delay: (i * 60).ms).slideY(
                          begin: 0.1, end: 0),
                      childCount: filtered.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// ─── My Courses Tab ─────────────────────────────────────────────────────────

class _MyCoursesTab extends StatelessWidget {
  final String userId;
  final CourseService courseService;

  const _MyCoursesTab({required this.userId, required this.courseService});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverAppBar(
          backgroundColor: AppColors.primary,
          pinned: true,
          title: Text('My Courses',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins')),
        ),
        StreamBuilder<List<String>>(
          stream: courseService.getEnrolledCourseIds(userId),
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const SliverToBoxAdapter(
                child: Center(
                    child: Padding(
                  padding: EdgeInsets.all(40),
                  child:
                      CircularProgressIndicator(color: AppColors.primary),
                )),
              );
            }
            final ids = snap.data ?? [];
            if (ids.isEmpty) {
              return SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Icon(Icons.menu_book_outlined,
                            size: 64, color: AppColors.textHint),
                        const SizedBox(height: 16),
                        Text('No enrolled courses',
                            style: AppTextStyles.titleMedium),
                        const SizedBox(height: 8),
                        Text('Browse courses and enroll to see them here',
                            style: AppTextStyles.bodyMedium,
                            textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              );
            }
            return StreamBuilder<List<CourseModel>>(
              stream: courseService.getCourses(),
              builder: (ctx2, allSnap) {
                if (!allSnap.hasData) {
                  return const SliverToBoxAdapter(child: SizedBox());
                }
                final enrolled = allSnap.data!
                    .where((c) => ids.contains(c.id))
                    .toList();
                return SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => CourseCard(
                          course: enrolled[i], isEnrolled: true),
                      childCount: enrolled.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.72,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// ─── Profile Tab ─────────────────────────────────────────────────────────────

class _ProfileTab extends StatelessWidget {
  final User? user;
  final AuthService auth;

  const _ProfileTab({required this.user, required this.auth});

  @override
  Widget build(BuildContext context) {
    final name = user?.displayName ?? 'Learner';
    final email = user?.email ?? '';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: AppColors.primary,
          pinned: true,
          expandedHeight: 200,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              color: AppColors.primary,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? Text(
                            name[0].toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.w700),
                          )
                        : null,
                  ),
                  const SizedBox(height: 10),
                  Text(name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins')),
                  Text(email,
                      style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Poppins')),
                ],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 8),
                _profileItem(Icons.person_outline_rounded, 'Edit Profile',
                    () {}),
                _profileItem(
                    Icons.notifications_outlined, 'Notifications', () {}),
                _profileItem(Icons.help_outline_rounded, 'Help & Support',
                    () {}),
                _profileItem(Icons.info_outline_rounded, 'About', () {}),
                const Divider(height: 24),
                _profileItem(
                  Icons.logout_rounded,
                  'Log Out',
                  () async => await auth.signOut(),
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileItem(IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon,
            color: color ?? AppColors.primary, size: 20),
      ),
      title: Text(
        label,
        style: TextStyle(
          color: color ?? AppColors.textPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      trailing: Icon(Icons.chevron_right_rounded,
          color: AppColors.textHint, size: 20),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
