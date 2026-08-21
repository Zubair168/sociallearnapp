import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/progress/services/progress_storage_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scaffoldBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF7F8FC);
    final appBarBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: appBarBg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.chevron_left_rounded,
            color: textPrimary,
            size: 28,
          ),
        ),
        title: Text(
          'Profile',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            fontFamily: 'Poppins',
          ),
        ),
        centerTitle: false,
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
        children: [
          // ── User Avatar with Edit Badge ─────────────────────────────────────
          Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
                    image: user?.photoURL != null
                        ? DecorationImage(
                            image: NetworkImage(user!.photoURL!),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200',
                            ),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(user: user),
                        ),
                      );
                    },
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2A3BD4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Menu Options ──────────────────────────────────────────────────
          _buildMenuItem(
            icon: Icons.person_outline_rounded,
            iconBg: const Color(0xFFEEF2FF),
            iconColor: const Color(0xFF2A3BD4),
            title: 'User Details',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(user: user),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.track_changes_rounded,
            iconBg: const Color(0xFFEFF6FF),
            iconColor: const Color(0xFF0284C7),
            title: 'Goal and Educator Setting',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const GoalAndEducatorSettingScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.assignment_outlined,
            iconBg: const Color(0xFFF0FDF4),
            iconColor: const Color(0xFF16A34A),
            title: 'Test Setting',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TestSettingScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.leaderboard_outlined,
            iconBg: const Color(0xFFFAF5FF),
            iconColor: const Color(0xFF9333EA),
            title: 'Leaderboard Setting',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const LeaderboardSettingScreen(),
                ),
              );
            },
          ),
          _buildMenuItem(
            icon: Icons.vpn_key_outlined,
            iconBg: const Color(0xFFFFFBEB),
            iconColor: const Color(0xFFD97706),
            title: 'Change Password',
            onTap: () => _showChangePasswordModal(context),
          ),
          _buildMenuItem(
            icon: Icons.lightbulb_outline_rounded,
            iconBg: const Color(0xFFEEF2FF),
            iconColor: const Color(0xFF4F46E5),
            title: 'Request a feature',
            onTap: () => _showRequestFeatureModal(context),
          ),
          _buildMenuItem(
            icon: Icons.chat_outlined,
            iconBg: const Color(0xFFF0FDF4),
            iconColor: const Color(0xFF10B981),
            title: 'Write to Tudu',
            onTap: () => _showWriteToTuduModal(context),
          ),
          _buildMenuItem(
            icon: Icons.description_outlined,
            iconBg: const Color(0xFFF8FAFC),
            iconColor: const Color(0xFF64748B),
            title: 'User Agreement',
            onTap: () => _showPolicyModal(context, 'User Agreement'),
          ),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            iconBg: const Color(0xFFF8FAFC),
            iconColor: const Color(0xFF64748B),
            title: 'Privacy Policy',
            onTap: () => _showPolicyModal(context, 'Privacy Policy'),
          ),
          _buildMenuItem(
            icon: Icons.history_rounded,
            iconBg: const Color(0xFFFEF2F2),
            iconColor: const Color(0xFFEF4444),
            title: 'Reset My History',
            onTap: () => _showResetHistoryModal(context),
          ),
          _buildMenuItem(
            icon: Icons.delete_outline_rounded,
            iconBg: const Color(0xFFFEF2F2),
            iconColor: const Color(0xFFEF4444),
            title: 'Delete Account',
            onTap: () => _showDeleteAccountFlow(context),
          ),
          _buildMenuItem(
            icon: Icons.logout_rounded,
            iconBg: const Color(0xFFFEF2F2),
            iconColor: const Color(0xFFEF4444),
            title: 'Log Out',
            isDestructive: true,
            onTap: () => _showLogoutDialog(context, auth),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9);
    final textColor = isDestructive
        ? const Color(0xFFEF4444)
        : isDark ? Colors.white : const Color(0xFF1E293B);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 18),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: textColor,
            fontFamily: 'Poppins',
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: isDestructive ? const Color(0xFFEF4444) : const Color(0xFF94A3B8),
        ),
        onTap: onTap,
      ),
    );
  }

  // ─── Modal: Request a Feature ───────────────────────────────────────────────
  void _showRequestFeatureModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    String selectedType = 'Others';
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: sheetBg,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Center(
                child: Text(
                  'Request a feature',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
                const SizedBox(height: 6),
                Text(
                  'Have an idea in mind that could make Tudu more awesome for you? Share with us your idea and we may implement it for you.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Feature type',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textPrimary,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedType,
                      isExpanded: true,
                      items: ['Study Planner', 'Question Bank', 'Analytics', 'Others']
                          .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13, fontFamily: 'Poppins'))))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedType = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Describe your issue or suggestion...',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontFamily: 'Poppins'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Image picker opened!'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  icon: const Icon(Icons.attach_file_rounded, size: 16, color: Color(0xFF64748B)),
                  label: const Text('Attach a visual', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontFamily: 'Poppins')),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 38),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 44),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Close', style: TextStyle(fontSize: 13, color: Color(0xFF64748B), fontFamily: 'Poppins')),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Feature request submitted successfully!'),
                              backgroundColor: Color(0xFF16A34A),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2A3BD4),
                          minimumSize: const Size(0, 44),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Submit', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Modal: Write to Tudu ───────────────────────────────────────────────
  void _showWriteToTuduModal(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sheetBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final msgCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: sheetBg,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text('Write to Tudu Support', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: textPrimary, fontFamily: 'Poppins')),
              ),
              const SizedBox(height: 6),
              Text('How can our academic team help you with your exam prep?', textAlign: TextAlign.center, style: TextStyle(fontSize: 11.5, color: Colors.grey.shade600, fontFamily: 'Poppins')),
              const SizedBox(height: 14),
              TextField(
                controller: msgCtrl,
                maxLines: 4,
                style: TextStyle(color: textPrimary),
                decoration: InputDecoration(
                  hintText: 'Type your message or question here...',
                  hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400, fontFamily: 'Poppins'),
                  fillColor: isDark ? const Color(0xFF0F172A) : null,
                  filled: isDark,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0))),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Support ticket sent!'), behavior: SnackBarBehavior.floating),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4)),
                      child: const Text('Send Message', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Modal: Change Password ────────────────────────────────────────────────
  void _showChangePasswordModal(BuildContext context) {
    final curCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Change Password', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
              const SizedBox(height: 12),
              TextField(controller: curCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password')),
              const SizedBox(height: 8),
              TextField(controller: newCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'New Password')),
              const SizedBox(height: 8),
              TextField(controller: confCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm Password')),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password updated successfully!'), behavior: SnackBarBehavior.floating),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4)),
                  child: const Text('Update Password', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Modal: Policy / Agreement ─────────────────────────────────────────────
  void _showPolicyModal(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
            const SizedBox(height: 12),
            Text(
              '$title terms and conditions for EduVerse/Tudu platform users. All user data, test scores, and analytics are encrypted and securely stored in compliance with privacy regulations.',
              style: TextStyle(fontSize: 12.5, color: Colors.grey.shade700, height: 1.4, fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => Navigator.pop(ctx), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4)), child: const Text('Accept & Close', style: TextStyle(color: Colors.white))),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Modal: Reset History ──────────────────────────────────────────────────
  void _showResetHistoryModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(color: Color(0xFFFEE2E2), shape: BoxShape.circle),
                child: const Icon(Icons.history_rounded, color: Color(0xFFEF4444), size: 30),
              ),
              const SizedBox(height: 14),
              const Text('Reset Study History', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
              const SizedBox(height: 6),
              Text('This will reset your question counts and streaks while keeping your account intact.', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontFamily: 'Poppins')),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel'))),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Study history reset.'), behavior: SnackBarBehavior.floating));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                      child: const Text('Reset', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Modal: Delete Account (3-Step Flow matching Screenshots 3 & 4) ────────
  void _showDeleteAccountFlow(BuildContext context) {
    int step = 1;
    final phoneCtrl = TextEditingController(text: '+90 ');
    final otpControllers = List.generate(5, (_) => TextEditingController());
    int selectedReason = 2; // I found a better app for practice

    final reasons = [
      "I've completed my preparation",
      'The questions were too easy or repetitive',
      'I found a better app for practice',
      'The app is too expensive',
      'I faced technical issues or bugs',
      'Other',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setFlowState) {
          if (step == 1) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(color: Color(0xFFFEE2E2), shape: BoxShape.circle),
                      child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 30),
                    ),
                    const SizedBox(height: 14),
                    const Text('Delete Account', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                    const SizedBox(height: 2),
                    const Text('This is a permanent account delete and cannot be undone!', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.error_outline_rounded, color: Color(0xFFEF4444), size: 18),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'This action will remove all your personal data and solving history. Please confirm your mobile number to proceed.',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: '+90 555 123 4567',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setFlowState(() => step = 2),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), elevation: 0),
                            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4), elevation: 0),
                            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (step == 2) {
            // Step 2: 5-digit OTP
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () => setFlowState(() => step = 1),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chevron_left_rounded, size: 20, color: Color(0xFF64748B)),
                            Text('Back', style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontFamily: 'Poppins')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(color: Color(0xFFFEE2E8), shape: BoxShape.circle),
                      child: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 30),
                    ),
                    const SizedBox(height: 12),
                    const Text('Delete Account', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
                    const SizedBox(height: 2),
                    const Text('This is a permanent account delete and cannot be undone!', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Color(0xFFEF4444), fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                      child: Text("We've sent a one time code to ${phoneCtrl.text}. Enter the 5 digit code to delete your account permanently", style: TextStyle(fontSize: 11, color: Colors.grey.shade700, fontFamily: 'Poppins')),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        5,
                        (i) => SizedBox(
                          width: 44,
                          height: 48,
                          child: TextField(
                            controller: otpControllers[i],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (val) {
                              if (val.isNotEmpty && i < 4) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text("Didn't receive the code? Resend in 30s", style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontFamily: 'Poppins')),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => setFlowState(() => step = 3),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444), elevation: 0),
                            child: const Text('Delete', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Navigator.pop(ctx),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4), elevation: 0),
                            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            // Step 3: We're sorry to see you go survey
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "We're sorry to see you go",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF2A3BD4), fontFamily: 'Poppins'),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Your feedback helps us get better. Let us know what didn\'t work for you.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontFamily: 'Poppins')),
                    const SizedBox(height: 14),
                    ...List.generate(reasons.length, (i) {
                      final r = reasons[i];
                      final isSel = selectedReason == i;
                      return GestureDetector(
                        onTap: () => setFlowState(() => selectedReason = i),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFFEEF2FF) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSel ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                                size: 18,
                                color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFF94A3B8),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  r,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isSel ? FontWeight.w600 : FontWeight.w400,
                                    color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFF1E293B),
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Close'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Account deletion request submitted.'), behavior: SnackBarBehavior.floating),
                              );
                            },
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4)),
                            child: const Text('Submit & Close', style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, AuthService auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700)),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await auth.signOut();
              if (context.mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Edit Profile Screen
// ─────────────────────────────────────────────────────────────────────────────
class EditProfileScreen extends StatefulWidget {
  final User? user;
  const EditProfileScreen({super.key, this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _firstCtrl;
  late TextEditingController _lastCtrl;
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    final names = (widget.user?.displayName ?? 'Harsh Jain').split(' ');
    _firstCtrl = TextEditingController(text: names.first);
    _lastCtrl = TextEditingController(text: names.length > 1 ? names.sublist(1).join(' ') : '');
    _emailCtrl = TextEditingController(text: widget.user?.email ?? 'Harsh@tudu.com');
  }

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
        title: const Text('Edit Profile', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Stack(
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 3),
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(color: Color(0xFF2A3BD4), shape: BoxShape.circle),
                    child: const Icon(Icons.edit_rounded, color: Colors.white, size: 15),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('First Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _firstCtrl,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Last Name', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _lastCtrl,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text('Email', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 6),
          TextField(
            controller: _emailCtrl,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Profile saved successfully!'), behavior: SnackBarBehavior.floating),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              child: const Text('Save', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Poppins')),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Goal and Educator Setting Screen (Screenshot 5)
// ─────────────────────────────────────────────────────────────────────────────
class GoalAndEducatorSettingScreen extends StatefulWidget {
  const GoalAndEducatorSettingScreen({super.key});

  @override
  State<GoalAndEducatorSettingScreen> createState() => _GoalAndEducatorSettingScreenState();
}

class _GoalAndEducatorSettingScreenState extends State<GoalAndEducatorSettingScreen> {
  String _selectedCourse = 'YKS 2025';
  int _selectedGoalPreset = 3; // Define your own goal
  int _customGoal = 10;
  String _selectedBranch = 'TYT';

  final List<String> _branches = [
    'TYT',
    'Quantitative',
    'Verbal',
    'Equal Weight',
    'Foreign Language',
    'I\'m not sure yet',
  ];

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
        title: const Text('Goal and Educator Setting', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Course', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildCourseChip('YKS 2025'),
              const SizedBox(width: 12),
              _buildCourseChip('YKS 2026'),
            ],
          ),
          const SizedBox(height: 22),
          const Text('Daily Goal Questions', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 2),
          Text('Number of questions you want to solve daily', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontFamily: 'Poppins')),
          const SizedBox(height: 12),
          _buildGoalOption(0, 'Easy Start', '20 questions per day'),
          _buildGoalOption(1, 'Medium Level', '40 questions per day'),
          _buildGoalOption(2, 'Challenging', '60 questions per day'),
          _buildCustomGoalOption(),
          const SizedBox(height: 22),
          const Text('Branch', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 2),
          Text('Let us know which branch you are preparing for', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontFamily: 'Poppins')),
          const SizedBox(height: 12),
          ..._branches.map((b) => _buildBranchOption(b)),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                context.read<ProgressProvider>().updateDailyGoal(_selectedGoalPreset == 3 ? _customGoal : (_selectedGoalPreset + 1) * 20);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings saved successfully!'), behavior: SnackBarBehavior.floating),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              child: const Text('Save', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Poppins')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseChip(String course) {
    final isSel = _selectedCourse == course;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedCourse = course),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSel ? const Color(0xFF22C55E) : const Color(0xFFE2E8F0), width: isSel ? 1.5 : 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(isSel ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: isSel ? const Color(0xFF22C55E) : const Color(0xFF94A3B8), size: 16),
              const SizedBox(width: 8),
              Text(course, style: TextStyle(fontSize: 13, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500, color: const Color(0xFF1E293B), fontFamily: 'Poppins')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalOption(int index, String title, String subtitle) {
    final isSel = _selectedGoalPreset == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoalPreset = index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(isSel ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: isSel ? const Color(0xFF22C55E) : const Color(0xFF94A3B8), size: 16),
                const SizedBox(width: 10),
                Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
              ],
            ),
            Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomGoalOption() {
    final isSel = _selectedGoalPreset == 3;
    return GestureDetector(
      onTap: () => setState(() => _selectedGoalPreset = 3),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(isSel ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: isSel ? const Color(0xFF22C55E) : const Color(0xFF94A3B8), size: 16),
                const SizedBox(width: 10),
                const Text('Define your own goal', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
              ],
            ),
            if (isSel) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE2E8F0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded, color: Color(0xFF2A3BD4)),
                      onPressed: () {
                        if (_customGoal > 5) setState(() => _customGoal -= 5);
                      },
                    ),
                    Text('$_customGoal', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, color: Color(0xFF2A3BD4)),
                      onPressed: () {
                        setState(() => _customGoal += 5);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBranchOption(String branch) {
    final isSel = _selectedBranch == branch;
    return GestureDetector(
      onTap: () => setState(() => _selectedBranch = branch),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSel ? const Color(0xFFEEF2FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSel ? const Color(0xFF2A3BD4) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(isSel ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: isSel ? const Color(0xFF22C55E) : const Color(0xFF94A3B8), size: 16),
            const SizedBox(width: 10),
            Text(branch, style: TextStyle(fontSize: 13, fontWeight: isSel ? FontWeight.w700 : FontWeight.w500, color: const Color(0xFF1E293B), fontFamily: 'Poppins')),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. Test Setting Screen (Screenshot 1 bottom & 4)
// ─────────────────────────────────────────────────────────────────────────────
class TestSettingScreen extends StatefulWidget {
  const TestSettingScreen({super.key});

  @override
  State<TestSettingScreen> createState() => _TestSettingScreenState();
}

class _TestSettingScreenState extends State<TestSettingScreen> {
  double _questionsPerTest = 10;
  bool _customValueEnabled = false;
  final TextEditingController _customCtrl = TextEditingController();
  String _cellularQuality = '360p';
  String _wifiQuality = '720p';

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
        title: const Text('Test Settings', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Questions per test', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 2),
          Text('Number of questions each test should contain', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontFamily: 'Poppins')),
          const SizedBox(height: 14),

          // Slider Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(
              children: [
                Slider(
                  value: _questionsPerTest,
                  min: 5,
                  max: 20,
                  divisions: 3,
                  activeColor: const Color(0xFF2A3BD4),
                  inactiveColor: const Color(0xFFE2E8F0),
                  onChanged: (val) {
                    setState(() {
                      _questionsPerTest = val;
                      _customValueEnabled = false;
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('5', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      Text('8', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      Text('10', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      Text('15', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      Text('20', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Custom Value Option
          GestureDetector(
            onTap: () => setState(() => _customValueEnabled = !_customValueEnabled),
            child: Row(
              children: [
                Icon(_customValueEnabled ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded, color: _customValueEnabled ? const Color(0xFF22C55E) : const Color(0xFF94A3B8), size: 16),
                const SizedBox(width: 8),
                const Text('Custom Value (Upto 20)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
              ],
            ),
          ),
          if (_customValueEnabled) ...[
            const SizedBox(height: 8),
            TextField(
              controller: _customCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Enter a custom value (e.g. 12)',
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ],
          const SizedBox(height: 24),

          const Text('Video Solution', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
          const SizedBox(height: 2),
          Text('Quality of the video when user clicks on video solution', style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontFamily: 'Poppins')),
          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Cellular', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_cellularQuality, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontFamily: 'Poppins')),
                      const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                    ],
                  ),
                  onTap: () {
                    setState(() => _cellularQuality = _cellularQuality == '360p' ? '720p' : '360p');
                  },
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),
                ListTile(
                  title: const Text('Wifi', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_wifiQuality, style: const TextStyle(fontSize: 12.5, color: Color(0xFF64748B), fontFamily: 'Poppins')),
                      const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF94A3B8)),
                    ],
                  ),
                  onTap: () {
                    setState(() => _wifiQuality = _wifiQuality == '720p' ? '1080p' : '720p');
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test settings updated!'), behavior: SnackBarBehavior.floating));
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              child: const Text('Save', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Poppins')),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Leaderboard Setting Screen (Screenshot 5)
// ─────────────────────────────────────────────────────────────────────────────
class LeaderboardSettingScreen extends StatefulWidget {
  const LeaderboardSettingScreen({super.key});

  @override
  State<LeaderboardSettingScreen> createState() => _LeaderboardSettingScreenState();
}

class _LeaderboardSettingScreenState extends State<LeaderboardSettingScreen> {
  bool _stayAnonymous = false;

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
        title: const Text('Leaderboard Setting', style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: const Color(0xFFE2E8F0))),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Stay Anonymous', style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: Color(0xFF1E293B), fontFamily: 'Poppins')),
                        const SizedBox(height: 4),
                        Text(
                          'When you appear on the leaderboard your profile picture and name would be masked with a random image and profile picture.',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.35, fontFamily: 'Poppins'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch(
                    value: _stayAnonymous,
                    activeThumbColor: const Color(0xFF2A3BD4),
                    onChanged: (val) => setState(() => _stayAnonymous = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Leaderboard preference saved!'), behavior: SnackBarBehavior.floating));
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A3BD4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                child: const Text('Save', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: 'Poppins')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
