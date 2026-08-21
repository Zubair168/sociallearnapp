import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/features/auth/screens/login_screen.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/onboarding/screens/onboarding_screen.dart';

/// 2-step register flow:
///  Step 0 → enter email (Register)
///  Step 1 → set password (Set Password)
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageCtrl = PageController();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  @override
  void dispose() {
    _pageCtrl.dispose();
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _goToStep1() {
    if (_emailCtrl.text.trim().isEmpty || _nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    _pageCtrl.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _register() async {
    if (_passCtrl.text.isEmpty) return;
    if (_passCtrl.text != _confirmCtrl.text) {
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

    setState(() => _loading = true);
    final auth = context.read<AuthService>();
    final ok = await auth.registerWithEmail(
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
      name: _nameCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    if (ok) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Registration failed'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageCtrl,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildStep0(),
          _buildStep1(),
        ],
      ),
    );
  }

  // ─── Step 0: Register ────────────────────────────────────────────────────

  Widget _buildStep0() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildHeader(showBack: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create an account to use the app',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 22),
                  _Field(
                    label: 'Full Name',
                    hint: 'Enter your name',
                    controller: _nameCtrl,
                    prefixIcon: Icons.person_outline_rounded,
                  ),
                  const SizedBox(height: 14),
                  _Field(
                    label: 'Email Address',
                    hint: 'Enter your email',
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 24),
                  _PrimaryButton(
                    label: 'Register',
                    onTap: _goToStep1,
                  ),
                  const SizedBox(height: 16),
                  _SocialDivider(),
                  const SizedBox(height: 16),
                  _SocialRow(),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 1: Set Password ─────────────────────────────────────────────────

  Widget _buildStep1() {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          _buildHeader(showBack: false),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _pageCtrl.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Icon(Icons.arrow_back_ios_rounded,
                            color: AppColors.primary, size: 18),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Set Password',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Create an account to use the app',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade500,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 22),
                  _Field(
                    label: 'Password',
                    hint: 'Enter password',
                    controller: _passCtrl,
                    obscure: _obscurePass,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePass
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePass = !_obscurePass),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _Field(
                    label: 'Confirm Password',
                    hint: 'Enter password',
                    controller: _confirmCtrl,
                    obscure: _obscureConfirm,
                    prefixIcon: Icons.lock_outline_rounded,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirm
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: Colors.grey,
                        size: 18,
                      ),
                      onPressed: () =>
                          setState(() => _obscureConfirm = !_obscureConfirm),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _PrimaryButton(
                    label: 'Register',
                    loading: _loading,
                    onTap: _register,
                  ),
                  const SizedBox(height: 16),
                  _SocialDivider(),
                  const SizedBox(height: 16),
                  _SocialRow(),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const LoginScreen()),
                      ),
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            fontFamily: 'Poppins',
                          ),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Shared blue header ───────────────────────────────────────────────────

  Widget _buildHeader({required bool showBack}) {
    return Container(
      height: 240,
      width: double.infinity,
      color: AppColors.primary,
      child: Stack(
        children: [
          if (showBack)
            Positioned(
              top: 12,
              left: 16,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
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

          // Exact image from Figma Frame 258 — girl with glasses & orange jacket by bookshelf
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/Book lover-bro 1.svg',
                height: 210,
                fit: BoxFit.contain,
              ),
            ),
          ).animate().fadeIn(duration: 400.ms),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────────────────────

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool obscure;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboardType,
          style: const TextStyle(fontFamily: 'Poppins', fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.grey.shade400,
              fontFamily: 'Poppins',
              fontSize: 13,
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 18, color: Colors.grey.shade500)
                : null,
            suffixIcon: suffixIcon,
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
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool loading;

  const _PrimaryButton({
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
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
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

class _SocialDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'Or register with',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialBtn(
          icon: Icons.facebook_rounded,
          color: const Color(0xFF1877F2),
          onTap: () {},
        ),
        const SizedBox(width: 16),
        _SocialBtn(
          icon: Icons.g_mobiledata_rounded,
          color: const Color(0xFFEA4335),
          onTap: () {},
        ),
        const SizedBox(width: 16),
        _SocialBtn(
          icon: Icons.apple_rounded,
          color: Colors.black,
          onTap: () {},
        ),
      ],
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SocialBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 26),
      ),
    );
  }
}
