import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/auth/screens/login_screen.dart';

/// 3-step forgot password flow matching Frame 259:
///  Step 0 → enter phone/email, get reset link
///  Step 1 → enter 5-digit/6-digit code
///  Step 2 → set new password
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final PageController _ctrl = PageController();
  int _step = 0;

  final _phoneCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _ctrl.dispose();
    _phoneCtrl.dispose();
    _codeCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _next() {
    setState(() => _step++);
    _ctrl.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _sendReset() async {
    if (_phoneCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    final auth = context.read<AuthService>();
    await auth.sendPasswordReset(email: _phoneCtrl.text.trim());
    if (!mounted) return;
    setState(() => _loading = false);
    _next();
  }

  void _verifyCode() {
    if (_codeCtrl.text.length < 4) return;
    _next();
  }

  void _updatePassword() {
    if (_passCtrl.text.isEmpty || _passCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Passwords do not match'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Password updated successfully!'),
        backgroundColor: AppColors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      body: PageView(
        controller: _ctrl,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStep0(),
          _buildStep1(),
          _buildStep2(),
        ],
      ),
    );
  }

  // ─── Step 0: Enter Email / Phone ──────────────────────────────────────────

  Widget _buildStep0() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildForgotPasswordHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Please enter your email to reset the password',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 22),

                  Builder(builder: (ctx) {
                    final d = Theme.of(ctx).brightness == Brightness.dark;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email Address',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: d ? Colors.white : const Color(0xFF1E293B),
                            fontFamily: 'Poppins',
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: d ? Colors.white : const Color(0xFF1E293B),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter your email',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13.5,
                              fontFamily: 'Poppins',
                            ),
                            filled: true,
                            fillColor: d ? const Color(0xFF1E293B) : Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: d ? const Color(0xFF334155) : Colors.grey.shade200),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: d ? const Color(0xFF334155) : Colors.grey.shade200),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                              borderSide:
                                  BorderSide(color: AppColors.primary, width: 1.5),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  const SizedBox(height: 24),
                  _ActionButton(
                    label: 'Reset Password',
                    loading: _loading,
                    onTap: _sendReset,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 1: Verify Code ──────────────────────────────────────────────────

  Widget _buildStep1() {
    final email = _phoneCtrl.text.trim().isEmpty
        ? 'harshj2005@gmail.com'
        : _phoneCtrl.text.trim();

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildForgotPasswordHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Forgot Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.grey.shade500,
                        fontFamily: 'Poppins',
                        height: 1.4,
                      ),
                      children: [
                        const TextSpan(
                            text: "We've sent a one time code to "),
                        TextSpan(
                          text: email,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const TextSpan(
                            text: "\nEnter the 5 digit code to reset your password"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),

                  const Text(
                    'Code',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 5 Box Code input
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (i) {
                      return Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          _codeCtrl.text.length > i ? _codeCtrl.text[i] : '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 12),

                  // Hidden field for keyboard input
                  Opacity(
                    opacity: 0.0,
                    child: SizedBox(
                      height: 0,
                      child: TextField(
                        controller: _codeCtrl,
                        keyboardType: TextInputType.number,
                        maxLength: 5,
                        autofocus: true,
                        onChanged: (v) => setState(() {}),
                      ),
                    ),
                  ),

                  Center(
                    child: GestureDetector(
                      onTap: _sendReset,
                      child: RichText(
                        text: TextSpan(
                          text: "Didn't receive the code? ",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            TextSpan(
                              text: 'Resend in 30s',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ActionButton(
                    label: 'Verify Code',
                    onTap: _verifyCode,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 2: Set New Password ─────────────────────────────────────────────

  Widget _buildStep2() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildSetNewPasswordHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Set New Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your email has been verified. Please enter your new password',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 22),

                  const Text(
                    'Password',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  const Text(
                    'Confirm Password',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      color: Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter password',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                          color: Colors.grey.shade400,
                        ),
                        onPressed: () =>
                            setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _ActionButton(
                    label: 'Update Password',
                    onTap: _updatePassword,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Header 1: Girl Stressed at Desk with Pop Up (Exact Frame 259) ─────────

  Widget _buildForgotPasswordHeader() {
    return Container(
      height: 230,
      width: double.infinity,
      color: AppColors.primary,
      child: Stack(
        children: [
          // Back button
          Positioned(
            top: 12,
            left: 16,
            child: GestureDetector(
              onTap: () {
                if (_step > 0) {
                  setState(() => _step--);
                  _ctrl.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Navigator.pop(context);
                }
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.primary, size: 16),
              ),
            ),
          ),

          // Bookshelf on the Left
          Positioned(
            left: 30,
            bottom: 0,
            child: SvgPicture.asset(
              'assets/images/freepik--Bookshelf--inject-2.svg',
              height: 150,
              fit: BoxFit.contain,
            ),
          ),

          // Plant on the Right
          Positioned(
            right: 20,
            bottom: 0,
            child: SvgPicture.asset(
              'assets/images/freepik--Plants--inject-2.svg',
              height: 150,
              fit: BoxFit.contain,
            ),
          ),

          // Pop-up [X] window in center top
          Positioned(
            top: 25,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/freepik--pop-up-window--inject-2.svg',
                height: 70,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Character in Center
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/freepik--Character--inject-2.svg',
                height: 175,
                fit: BoxFit.contain,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),
        ],
      ),
    );
  }

  // ─── Header 2: Girl with Giant Phone & Padlock (Exact Frame 259) ───────────

  Widget _buildSetNewPasswordHeader() {
    return Container(
      height: 230,
      width: double.infinity,
      color: AppColors.primary,
      child: Stack(
        children: [
          // Back button
          Positioned(
            top: 12,
            left: 16,
            child: GestureDetector(
              onTap: () {
                setState(() => _step = 1);
                _ctrl.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_rounded,
                    color: AppColors.primary, size: 16),
              ),
            ),
          ),

          // Layer_1 (1).svg (Phone with Padlock & Character)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/Layer_1 (1).svg',
                height: 190,
                fit: BoxFit.contain,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const _ActionButton({
    required this.label,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: loading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : Text(
                '$label  ›',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                ),
              ),
      ),
    );
  }
}
