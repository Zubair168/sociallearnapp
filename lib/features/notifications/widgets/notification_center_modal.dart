import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/features/notifications/services/notification_service.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String category;
  final DateTime timestamp;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.category,
    required this.timestamp,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.isRead = false,
  });
}

class NotificationCenterModal extends StatefulWidget {
  const NotificationCenterModal({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const NotificationCenterModal(),
    );
  }

  @override
  State<NotificationCenterModal> createState() => _NotificationCenterModalState();
}

class _NotificationCenterModalState extends State<NotificationCenterModal> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'New Video Lesson Added',
      body: 'Quadratic Equations Part 3 is now available in AYT Mathematics.',
      category: 'Courses',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      icon: Icons.play_circle_fill_rounded,
      iconBg: const Color(0xFFEFF6FF),
      iconColor: const Color(0xFF2A3BD4),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Daily Goal Reminder',
      body: 'You are just 4 questions away from reaching your daily target!',
      category: 'Study Goal',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      icon: Icons.track_changes_rounded,
      iconBg: const Color(0xFFFEF3C7),
      iconColor: const Color(0xFFD97706),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Trial Exam Result Ready',
      body: 'Your TYT Full Mock Exam #4 results and detailed net scores are ready.',
      category: 'Exams',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      icon: Icons.assignment_turned_in_rounded,
      iconBg: const Color(0xFFDCFCE7),
      iconColor: const Color(0xFF16A34A),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Weekly Study Streak: 5 Days! 🔥',
      body: 'Keep up the consistent momentum to unlock the Platinum Learner badge.',
      category: 'Achievement',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      icon: Icons.local_fire_department_rounded,
      iconBg: const Color(0xFFFFE4E6),
      iconColor: const Color(0xFFE11D48),
      isRead: true,
    ),
  ];

  String _formatTimeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _notifications) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearAll() {
    setState(() {
      _notifications.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifService = context.watch<NotificationService>();
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          const SizedBox(height: 12),
          Center(
            child: Container(
              width: 38,
              height: 4.5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.notifications_active_rounded,
                    color: Color(0xFF2A3BD4),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      unreadCount > 0
                          ? '$unreadCount unread updates'
                          : 'All caught up!',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade500,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                if (_notifications.isNotEmpty) ...[
                  TextButton(
                    onPressed: _markAllAsRead,
                    child: const Text(
                      'Mark read',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2A3BD4),
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_sweep_outlined,
                        size: 20, color: Colors.grey.shade500),
                    onPressed: _clearAll,
                    tooltip: 'Clear All',
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // FCM Test Banner Action
          Container(
            margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Push Notification Test',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        'Trigger a live device notification test',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Colors.grey.shade500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await notifService.showNewLessonNotification(
                      title: 'Quadratic Equations Practice 2',
                      subject: 'AYT Mathematics',
                      duration: '15 min',
                    );
                    setState(() {
                      _notifications.insert(
                        0,
                        NotificationItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          title: '🔔 Test Notification Triggered',
                          body: 'Test push notification sent successfully.',
                          category: 'System',
                          timestamp: DateTime.now(),
                          icon: Icons.check_circle_rounded,
                          iconBg: const Color(0xFFDCFCE7),
                          iconColor: const Color(0xFF16A34A),
                          isRead: false,
                        ),
                      );
                    });
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Push notification delivered!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.send_rounded, size: 14, color: Colors.white),
                  label: const Text(
                    'Test',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A3BD4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                ),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: _notifications.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined,
                            size: 48, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text(
                          'No notifications yet',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF64748B),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Updates and study reminders will appear here',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _notifications.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      return Dismissible(
                        key: Key(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          setState(() {
                            _notifications.removeAt(index);
                          });
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEF4444),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.delete_outline_rounded,
                              color: Colors.white, size: 22),
                        ),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              item.isRead = true;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: item.isRead
                                  ? Colors.white
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: item.isRead
                                    ? const Color(0xFFF1F5F9)
                                    : const Color(0xFFE0E7FF),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: item.iconBg,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Icon(item.icon,
                                      color: item.iconColor, size: 20),
                                ),
                                const SizedBox(width: 12),

                                // Texts
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEEF2FF),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              item.category,
                                              style: const TextStyle(
                                                fontSize: 9.5,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF2A3BD4),
                                                fontFamily: 'Poppins',
                                              ),
                                            ),
                                          ),
                                          Text(
                                            _formatTimeAgo(item.timestamp),
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.shade400,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: item.isRead
                                              ? FontWeight.w600
                                              : FontWeight.w700,
                                          color: const Color(0xFF1E293B),
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        item.body,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: Colors.grey.shade600,
                                          fontFamily: 'Poppins',
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Unread Dot
                                if (!item.isRead) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    width: 8,
                                    height: 8,
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF2A3BD4),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
