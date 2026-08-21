import 'package:flutter/material.dart';

class NotificationData {
  final String id;
  final String title;
  final String body;
  final String time;
  final String dateGroup;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  bool isRead;

  NotificationData({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.dateGroup,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    this.isRead = false,
  });
}

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationData> _items = [
    // Today
    NotificationData(
      id: '1',
      title: 'Special Offer',
      body: 'Get 25% off on your first book order with Tudu',
      time: '10:28 AM',
      dateGroup: 'Today, Oct 20',
      icon: Icons.percent_rounded,
      iconBg: const Color(0xFFFFF7ED),
      iconColor: const Color(0xFFF97316),
      isRead: false,
    ),
    NotificationData(
      id: '2',
      title: 'Book Out for Delivery',
      body: 'Your Book No. 3 is out for delivery and expected today, use OTP: 3122 to receive the delivery.',
      time: '10:28 AM',
      dateGroup: 'Today, Oct 20',
      icon: Icons.local_shipping_outlined,
      iconBg: const Color(0xFFEEF2FF),
      iconColor: const Color(0xFF4F46E5),
      isRead: false,
    ),
    NotificationData(
      id: '3',
      title: 'Reminder: Exam in 3 Days',
      body: 'Your Physics exam is coming up in 3 days. Don\'t forget to review the important topics!',
      time: '10:28 AM',
      dateGroup: 'Today, Oct 20',
      icon: Icons.notifications_none_rounded,
      iconBg: const Color(0xFFFEF2F2),
      iconColor: const Color(0xFFEF4444),
      isRead: false,
    ),

    // Yesterday
    NotificationData(
      id: '4',
      title: 'Password Changed Successfully',
      body: 'Your password was successfully updated. If this wasn\'t you, please contact support.',
      time: '10:28 AM',
      dateGroup: 'Yesterday, Oct 19',
      icon: Icons.vpn_key_outlined,
      iconBg: const Color(0xFFF0FDF4),
      iconColor: const Color(0xFF16A34A),
      isRead: true,
    ),
    NotificationData(
      id: '5',
      title: 'New Question Bank Available',
      body: 'The latest question bank for Mathematics is now available. Start practicing today!',
      time: '10:28 AM',
      dateGroup: 'Yesterday, Oct 19',
      icon: Icons.menu_book_rounded,
      iconBg: const Color(0xFFEFF6FF),
      iconColor: const Color(0xFF2A3BD4),
      isRead: true,
    ),
    NotificationData(
      id: '6',
      title: 'Reminder: Exam in 4 Days',
      body: 'Your Physics exam is coming up in 4 days. Don\'t forget to review the important topics!',
      time: '10:28 AM',
      dateGroup: 'Yesterday, Oct 19',
      icon: Icons.notifications_none_rounded,
      iconBg: const Color(0xFFFEF2F2),
      iconColor: const Color(0xFFEF4444),
      isRead: true,
    ),
  ];

  void _markAllAsRead() {
    setState(() {
      for (final i in _items) {
        i.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read'), behavior: SnackBarBehavior.floating),
    );
  }

  void _clearAll() {
    setState(() {
      _items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final groups = <String, List<NotificationData>>{};
    for (final item in _items) {
      groups.putIfAbsent(item.dateGroup, () => []).add(item);
    }

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
          'Notifications',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF1E293B), size: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            onSelected: (val) {
              if (val == 'read') _markAllAsRead();
              if (val == 'clear') _clearAll();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'read',
                child: Text('Mark all as read', style: TextStyle(fontSize: 13, fontFamily: 'Poppins')),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear all', style: TextStyle(fontSize: 13, fontFamily: 'Poppins', color: Color(0xFFEF4444))),
              ),
            ],
          ),
        ],
      ),
      body: _items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 54, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  const Text(
                    'No notifications',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Color(0xFF64748B), fontFamily: 'Poppins'),
                  ),
                ],
              ),
            )
          : ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 32),
              children: groups.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 6),
                      child: Text(
                        entry.key,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                    ...entry.value.map((item) => _buildNotificationCard(item)),
                    const SizedBox(height: 14),
                  ],
                );
              }).toList(),
            ),
    );
  }

  Widget _buildNotificationCard(NotificationData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          setState(() {
            _items.removeWhere((i) => i.id == item.id);
          });
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFEF4444),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.cancel_outlined, color: Colors.white, size: 26),
        ),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFF1F5F9)),
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
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(item.icon, color: item.iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                        color: const Color(0xFF1E293B),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.body,
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.grey.shade600,
                        fontFamily: 'Poppins',
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.time,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade400,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
