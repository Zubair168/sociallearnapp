import 'package:flutter/material.dart';
import 'package:sociallearnapp/features/courses/screens/subject_topics_screen.dart';
import 'package:sociallearnapp/features/video/screens/video_player_screen.dart';

class StudyTaskItem {
  final String id;
  final String title;
  final String course;
  final String type; // TYT or AYT
  final int durationMinutes;
  String note;
  bool isCompleted;
  final Color iconBg;
  final IconData icon;

  StudyTaskItem({
    required this.id,
    required this.title,
    required this.course,
    required this.type,
    required this.durationMinutes,
    this.note = '',
    this.isCompleted = false,
    this.iconBg = const Color(0xFFE0F2FE),
    this.icon = Icons.calculate_outlined,
  });
}

class SmartStudyPlanScreen extends StatefulWidget {
  const SmartStudyPlanScreen({super.key});

  @override
  State<SmartStudyPlanScreen> createState() => _SmartStudyPlanScreenState();
}

class _SmartStudyPlanScreenState extends State<SmartStudyPlanScreen> {
  int _selectedTabIndex = 0; // 0: My Plan, 1: Template Library
  int _selectedDayIndex = 0;

  final List<Map<String, dynamic>> _calendarDays = [
    {'dayName': 'Tue', 'date': '28', 'dots': 3},
    {'dayName': 'Wed', 'date': '29', 'dots': 2},
    {'dayName': 'Thu', 'date': '30', 'dots': 2},
    {'dayName': 'Fri', 'date': '31', 'dots': 3},
    {'dayName': 'Sat', 'date': '1', 'dots': 4},
    {'dayName': 'Sun', 'date': '2', 'dots': 4},
    {'dayName': 'Mon', 'date': '3', 'dots': 3},
  ];

  final List<StudyTaskItem> _tasks = [
    StudyTaskItem(
      id: '1',
      title: 'Linear Equations',
      course: 'Mathematics',
      type: 'TYT',
      durationMinutes: 60,
      note: 'Complete this and revise it after 2 days. This is an example of a key note for exam prep.',
      isCompleted: true,
      icon: Icons.calculate_outlined,
      iconBg: const Color(0xFFE0F2FE),
    ),
    StudyTaskItem(
      id: '2',
      title: 'Tanzimat Literature',
      course: 'Turkish',
      type: 'AYT',
      durationMinutes: 30,
      note: 'Complete this and revise it after 2 days',
      isCompleted: false,
      icon: Icons.auto_stories_outlined,
      iconBg: const Color(0xFFFFE4E6),
    ),
    StudyTaskItem(
      id: '3',
      title: 'Polynomials',
      course: 'Mathematics',
      type: 'AYT',
      durationMinutes: 45,
      note: 'Focus on remainder theorem and roots.',
      isCompleted: true,
      icon: Icons.functions_rounded,
      iconBg: const Color(0xFFE0F2FE),
    ),
    StudyTaskItem(
      id: '4',
      title: 'Electrostatics & Electric Fields',
      course: 'Physics',
      type: 'AYT',
      durationMinutes: 60,
      note: 'Solve 20 past ÖSYM questions.',
      isCompleted: false,
      icon: Icons.electric_bolt_rounded,
      iconBg: const Color(0xFFFEF3C7),
    ),
  ];

  String _selectedTemplateCategory = 'All';

  int get _completedCount => _tasks.where((t) => t.isCompleted).length;
  int get _totalCount => _tasks.length;
  int get _progressPct => _totalCount > 0 ? ((_completedCount / _totalCount) * 100).toInt() : 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.chevron_left_rounded,
            color: Color(0xFF1E293B),
            size: 28,
          ),
        ),
        title: const Text(
          'Smart Study Plan',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: _selectedTabIndex == 0 ? _buildMyPlanView() : _buildTemplateLibraryView(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedTabIndex,
          onTap: (i) => setState(() => _selectedTabIndex = i),
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF2A3BD4),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, fontFamily: 'Poppins'),
          unselectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, fontFamily: 'Poppins'),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment_rounded),
              label: 'My Plan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book_rounded),
              label: 'Template Library',
            ),
          ],
        ),
      ),
    );
  }

  // ─── Tab 1: My Plan View (Screenshots 6 & 7) ──────────────────────────────
  Widget _buildMyPlanView() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      children: [
        // August 2025 Calendar Header
        Center(
          child: Text(
            'August 2025',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Horizontal Days Picker
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_calendarDays.length, (i) {
            final item = _calendarDays[i];
            final isSel = _selectedDayIndex == i;

            return GestureDetector(
              onTap: () => setState(() => _selectedDayIndex = i),
              child: Container(
                width: 44,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSel ? const Color(0xFF2A3BD4) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      item['dayName'] as String,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isSel ? Colors.white70 : const Color(0xFF64748B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['date'] as String,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSel ? Colors.white : const Color(0xFF1E293B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Colored dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF38BDF8), shape: BoxShape.circle)),
                        const SizedBox(width: 2),
                        Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFFBBF24), shape: BoxShape.circle)),
                        if ((item['dots'] as int) > 2) ...[
                          const SizedBox(width: 2),
                          Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFFF87171), shape: BoxShape.circle)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 20),

        // Today's Tasks + Add New Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Today\'s Tasks',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontFamily: 'Poppins',
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => _openAddTaskScreen(context),
              icon: const Icon(Icons.add_rounded, size: 16, color: Color(0xFF2A3BD4)),
              label: const Text(
                'Add New',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2A3BD4),
                  fontFamily: 'Poppins',
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF2A3BD4)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Progress Text
        if (_tasks.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tasks Completed  ($_completedCount/$_totalCount)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$_progressPct%',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
        ],

        // Tasks List or Empty State
        if (_tasks.isEmpty)
          _buildEmptyTasksState()
        else
          ..._tasks.map((task) => _buildTaskCard(task)),
      ],
    );
  }

  Widget _buildEmptyTasksState() {
    return Container(
      padding: const EdgeInsets.all(32),
      alignment: Alignment.center,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: 84,
            height: 84,
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.checklist_rtl_rounded,
              size: 44,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Tasks Added',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'You haven\'t added any task for today. Click on the button below to add new tasks.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontFamily: 'Poppins',
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () => _openAddTaskScreen(context),
              icon: const Icon(Icons.add_rounded, size: 18, color: Colors.white),
              label: const Text('Add New Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A3BD4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(StudyTaskItem task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: task.isCompleted ? const Color(0xFF86EFAC) : const Color(0xFFE2E8F0),
          width: task.isCompleted ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 12, 12, 8),
            child: Row(
              children: [
                const Icon(Icons.drag_indicator_rounded, size: 18, color: Color(0xFFCBD5E1)),
                const SizedBox(width: 4),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: task.iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(task.icon, color: const Color(0xFF2A3BD4), size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showTopicActionModal(task),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              task.title,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1E293B),
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF94A3B8)),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                              decoration: BoxDecoration(
                                color: task.type == 'TYT' ? const Color(0xFFEEF2FF) : const Color(0xFFFFF1F2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                task.type,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: task.type == 'TYT' ? const Color(0xFF2A3BD4) : const Color(0xFFE11D48),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.access_time_rounded, size: 12, color: Colors.grey.shade500),
                            const SizedBox(width: 3),
                            Text(
                              '${task.durationMinutes} mins',
                              style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500, fontFamily: 'Poppins'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => task.isCompleted = !task.isCompleted),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: task.isCompleted ? const Color(0xFF22C55E) : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task.isCompleted ? const Color(0xFF22C55E) : const Color(0xFFCBD5E1),
                        width: 1.5,
                      ),
                    ),
                    child: task.isCompleted
                        ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                        : null,
                  ),
                ),
              ],
            ),
          ),

          // Note container (if any)
          if (task.note.isNotEmpty) ...[
            Container(
              margin: const EdgeInsets.fromLTRB(40, 0, 12, 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.note_alt_outlined, size: 14, color: Color(0xFF2A3BD4)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      task.note,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                        fontFamily: 'Poppins',
                        height: 1.35,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _editNoteDialog(task),
                    child: const Icon(Icons.edit_outlined, size: 13, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _editNoteDialog(StudyTaskItem task) {
    final noteCtrl = TextEditingController(text: task.note);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Task Note', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700, fontSize: 16)),
        content: TextField(
          controller: noteCtrl,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'Enter your note...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => task.note = noteCtrl.text);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4)),
            child: const Text('Save Note', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Modal: Topic Action Sheet (Screenshot 7) ──────────────────────────────
  void _showTopicActionModal(StudyTaskItem task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).padding.bottom + 20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A3BD4),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${task.course} • ${task.durationMinutes} mins',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1E293B)),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 18),

            // 1. Solve A Test
            _buildTopicActionTile(
              icon: Icons.fact_check_outlined,
              iconColor: const Color(0xFF2A3BD4),
              title: 'Solve A Test',
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SubjectTopicsScreen(subjectName: task.course),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // 2. Watch Lecture Videos
            _buildTopicActionTile(
              icon: Icons.video_collection_outlined,
              iconColor: const Color(0xFF0284C7),
              title: 'Watch lecture videos',
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoPlayerScreen(
                      title: '${task.title} Video Solution',
                      videoUrl: 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),

            // 3. Review Past Mistakes
            _buildTopicActionTile(
              icon: Icons.history_edu_rounded,
              iconColor: const Color(0xFFEF4444),
              title: 'Review past mistakes',
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mistake questions loaded!'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8), size: 20),
          ],
        ),
      ),
    );
  }

  // ─── Tab 2: Template Library View (Screenshot 6 middle) ───────────────────
  Widget _buildTemplateLibraryView() {
    final categories = ['All', 'Mathematics', 'Turkish', 'Geometry'];

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
      children: [
        const Text(
          'Template Library',
          style: TextStyle(
            fontSize: 16.5,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 12),

        // Category Filter Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) {
              final isSel = _selectedTemplateCategory == cat;
              return GestureDetector(
                onTap: () => setState(() => _selectedTemplateCategory = cat),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSel ? const Color(0xFF2A3BD4) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Text(
                    cat,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      color: isSel ? Colors.white : const Color(0xFF1E293B),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 18),

        // 8-Week Math Focus Template Card
        _buildTemplateDetailCard(
          title: '8-Week Math Focus',
          course: 'Mathematics',
          duration: '60 mins Daily',
          studentsCount: '210 Students Completed this',
          desc: '8 haftalık matematik odaklı bu çalışma kampı ile temellerini sağlamlaştır.\nToplam Konu: 25\nToplam Süre: 25 saat\nSeviye: Temel',
          topics: [
            {'name': 'Linear Equations', 'type': 'TYT', 'time': '30 mins'},
            {'name': 'Quadratic Equations', 'type': 'AYT', 'time': '30 mins'},
            {'name': 'Polynomials', 'type': 'AYT', 'time': '40 mins'},
          ],
        ),
      ],
    );
  }

  Widget _buildTemplateDetailCard({
    required String title,
    required String course,
    required String duration,
    required String studentsCount,
    required String desc,
    required List<Map<String, String>> topics,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2A3BD4),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$course • $duration\n$studentsCount',
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.grey.shade600,
              fontFamily: 'Poppins',
              height: 1.35,
            ),
          ),
          const SizedBox(height: 14),
          const Text('Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
          const SizedBox(height: 4),
          Text(desc, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontFamily: 'Poppins', height: 1.35)),
          const SizedBox(height: 14),
          const Text('Topics', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          ...topics.map((tp) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: const Color(0xFFEEF2FF), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.calculate_outlined, color: Color(0xFF2A3BD4), size: 16),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(tp['name']!, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                        Text('${tp['type']!} • ${tp['time']!}', style: TextStyle(fontSize: 10.5, color: Colors.grey.shade500, fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Joined $title successfully!'), behavior: SnackBarBehavior.floating),
                );
                setState(() => _selectedTabIndex = 0);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A3BD4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Join to the template plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Add Task Screen Navigator (Screenshot 6 right) ────────────────────────
  void _openAddTaskScreen(BuildContext context) async {
    final newTask = await Navigator.push<StudyTaskItem>(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (newTask != null) {
      setState(() => _tasks.add(newTask));
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add Task Screen (Screenshot 6 right)
// ─────────────────────────────────────────────────────────────────────────────
class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  String _taskType = 'AYT'; // TYT or AYT
  DateTime _taskDate = DateTime.now();
  String _selectedCourse = 'Mathematics';
  String _selectedTopic = 'Polynomials';
  int _studyHours = 1;
  int _studyMinutes = 0;
  final TextEditingController _noteCtrl = TextEditingController();

  final List<String> _courses = ['Mathematics', 'Turkish', 'Physics', 'Chemistry', 'Biology', 'Geometry'];
  final List<String> _topics = ['Polynomials', 'Linear Equations', 'Quadratic Equations', 'Trigonometry', 'Vectors', 'Organic Chemistry'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.chevron_left_rounded, color: Color(0xFF1E293B), size: 28),
        ),
        title: const Text('Add New Task', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Task Type', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: const Color(0xFFE2E8F0), borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                Expanded(child: _buildTypePill('TYT')),
                Expanded(child: _buildTypePill('AYT')),
              ],
            ),
          ),
          const SizedBox(height: 18),

          const Text('Task Date', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _taskDate,
                firstDate: DateTime.now().subtract(const Duration(days: 30)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) setState(() => _taskDate = picked);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${_taskDate.day.toString().padLeft(2, '0')}-${_taskDate.month.toString().padLeft(2, '0')}-${_taskDate.year}',
                    style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B), fontFamily: 'Poppins'),
                  ),
                  const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF64748B)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          const Text('Course', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCourse,
                isExpanded: true,
                items: _courses.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13.5, fontFamily: 'Poppins')))).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedCourse = v);
                },
              ),
            ),
          ),
          const SizedBox(height: 18),

          const Text('Topic', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedTopic,
                isExpanded: true,
                items: _topics.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 13.5, fontFamily: 'Poppins')))).toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _selectedTopic = v);
                },
              ),
            ),
          ),
          const SizedBox(height: 18),

          const Text('Time to Study', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFF2A3BD4)),
                  onPressed: () {
                    if (_studyHours > 0 || _studyMinutes > 15) {
                      setState(() {
                        if (_studyMinutes >= 15) {
                          _studyMinutes -= 15;
                        } else if (_studyHours > 0) {
                          _studyHours -= 1;
                          _studyMinutes = 45;
                        }
                      });
                    }
                  },
                ),
                Text(
                  '${_studyHours.toString().padLeft(2, '0')}:${_studyMinutes.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins'),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF2A3BD4)),
                  onPressed: () {
                    setState(() {
                      if (_studyMinutes < 45) {
                        _studyMinutes += 15;
                      } else {
                        _studyHours += 1;
                        _studyMinutes = 0;
                      }
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          const Text('Note', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 8),
          TextField(
            controller: _noteCtrl,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Add your note...',
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            ),
          ),
          const SizedBox(height: 28),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final totalMins = _studyHours * 60 + _studyMinutes;
                final newTask = StudyTaskItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: _selectedTopic,
                  course: _selectedCourse,
                  type: _taskType,
                  durationMinutes: totalMins > 0 ? totalMins : 30,
                  note: _noteCtrl.text,
                  isCompleted: false,
                );
                Navigator.pop(context, newTask);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2A3BD4),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Text('Create Task', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Poppins')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypePill(String type) {
    final isSel = _taskType == type;
    return GestureDetector(
      onTap: () => setState(() => _taskType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFF2A3BD4) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          type,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSel ? Colors.white : const Color(0xFF64748B),
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
