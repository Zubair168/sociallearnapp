import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sociallearnapp/core/constants/app_colors.dart';
import 'package:sociallearnapp/features/auth/screens/forgot_password_screen.dart';
import 'package:sociallearnapp/features/auth/screens/register_screen.dart';
import 'package:sociallearnapp/features/auth/services/auth_service.dart';
import 'package:sociallearnapp/features/onboarding/screens/onboarding_screen.dart';
import 'package:sociallearnapp/shared/widgets/support_chip.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthService>();
    final ok = await auth.signInWithEmail(
      email: _phoneCtrl.text.trim(),
      password: _passCtrl.text,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error ?? 'Login failed'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> _googleLogin() async {
    final auth = context.read<AuthService>();
    final ok = await auth.signInWithGoogle();
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        (route) => false,
      );
    } else if (auth.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.error!),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isLoading = auth.isLoading;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF1E293B);
    final inputBg = isDark ? const Color(0xFF0F172A) : Colors.grey.shade50;
    final inputBorder = isDark ? const Color(0xFF334155) : Colors.grey.shade200;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // ── Top Blue Header — exact match Figma Frame 257 ─────────────────
                      Expanded(
                        flex: 4,
                        child: _buildHeader(),
                      ),

                      // ── Bottom Form Container ──────────────────────────────────
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                        ),
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Title + Support chip
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Login',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF2A3BD4),
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        'Login to continue using the app',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade500,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SupportChip(),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Email label
                              Text(
                                'Email Address',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: textPrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _phoneCtrl,
                                keyboardType: TextInputType.emailAddress,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter your email',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13.5,
                                    fontFamily: 'Poppins',
                                  ),
                                  filled: true,
                                  fillColor: inputBg,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 14),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: inputBorder),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: inputBorder),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    borderSide:
                                        BorderSide(color: AppColors.primary, width: 1.5),
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty) ? 'Required' : null,
                              ),
                              const SizedBox(height: 14),

                              // Password label + Forgot Password
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Password',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: _showForgotPassword,
                                    child: const Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _passCtrl,
                                obscureText: _obscurePass,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  color: textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Enter password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                  ),
                                  filled: true,
                                  fillColor: inputBg,
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
                                    borderSide: BorderSide(color: inputBorder),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: inputBorder),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    borderSide:
                                        BorderSide(color: AppColors.primary, width: 1.5),
                                  ),
                                ),
                                validator: (v) =>
                                    (v == null || v.isEmpty) ? 'Required' : null,
                              ),
                              const SizedBox(height: 20),

                              // Login button
                              GestureDetector(
                                onTap: isLoading ? null : _login,
                                child: Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  alignment: Alignment.center,
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                              color: Colors.white, strokeWidth: 2.5),
                                        )
                                      : const Text(
                                          'Login  ›',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Or login with
                              Row(
                                children: [
                                  Expanded(child: Divider(color: isDark ? const Color(0xFF334155) : Colors.grey.shade300)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      'Or login with',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade500,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Divider(color: isDark ? const Color(0xFF334155) : Colors.grey.shade300)),
                                ],
                              ),
                              const SizedBox(height: 14),

                              // Social login buttons
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildSocialBtn(
                                    icon: Icons.facebook_rounded,
                                    color: const Color(0xFF1877F2),
                                    onTap: () {},
                                  ),
                                  const SizedBox(width: 16),
                                  _buildSocialBtn(
                                    icon: null,
                                    letter: 'G',
                                    color: const Color(0xFFEA4335),
                                    onTap: _googleLogin,
                                  ),
                                  const SizedBox(width: 16),
                                  _buildSocialBtn(
                                    icon: Icons.apple_rounded,
                                    color: isDark ? Colors.white : Colors.black,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Register link
                              Center(
                                child: GestureDetector(
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const RegisterScreen()),
                                  ),
                                  child: RichText(
                                    text: TextSpan(
                                      text: "Don't have an account? ",
                                      style: TextStyle(
                                        color: isDark ? const Color(0xFF94A3B8) : Colors.grey.shade600,
                                        fontSize: 13,
                                        fontFamily: 'Poppins',
                                      ),
                                      children: const [
                                        TextSpan(
                                          text: 'Register',
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
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ─── Exact Figma Frame 257 Header ─────────────────────────────────────────

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final headerHeight = constraints.maxHeight;
        final charHeight = (headerHeight * 0.85).clamp(160.0, 240.0);

        return Container(
          width: double.infinity,
          color: AppColors.primary,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: [
              // 1. Math formulas text — top center
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: const Center(
                  child: _MathFormulas(),
                ),
              ),

              // 2. Plant — left side
              Positioned(
                left: -2,
                bottom: 25,
                child: SvgPicture.asset(
                  'assets/images/Plant.svg',
                  height: 85,
                  fit: BoxFit.contain,
                ),
              ),

              // 3. Pencil — bottom left pointing towards character
              Positioned(
                left: 12,
                bottom: 8,
                child: SvgPicture.asset(
                  'assets/images/Group (3).svg',
                  height: 55,
                  fit: BoxFit.contain,
                ),
              ),

              // 4. Rulers — top right
              Positioned(
                top: 6,
                right: 6,
                child: SvgPicture.asset(
                  'assets/images/Rulers.svg',
                  height: 95,
                  fit: BoxFit.contain,
                ),
              ),

              // 5. Globe — bottom right
              Positioned(
                right: 4,
                bottom: 12,
                child: SvgPicture.asset(
                  'assets/images/Globe.svg',
                  height: 70,
                  fit: BoxFit.contain,
                ),
              ),

              // 6. Girl character (cropped at desk level, large & centered) — exact Figma Frame 257
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/images/Character_top.svg',
                    height: charHeight,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ).animate().fadeIn(duration: 400.ms).slideY(
                    begin: 0.05,
                    end: 0,
                    duration: 400.ms,
                    curve: Curves.easeOut,
                  ),

              // Back button (only if canPop)
              if (Navigator.canPop(context))
                Positioned(
                  top: 8,
                  left: 12,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSocialBtn({
    IconData? icon,
    String? letter,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: letter != null
            ? Text(
                letter,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontFamily: 'Poppins',
                ),
              )
            : Icon(icon, color: color, size: 22),
      ),
    );
  }
}

// ─── Math Formula Text Widget ─────────────────────────────────────────────────

class _MathFormulas extends StatelessWidget {
  const _MathFormulas();

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: 11.5,
      color: Colors.white.withValues(alpha: 0.5),
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      height: 1.1,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('ⁿ√|4ⁿ + cos 2n|', style: style),
            const SizedBox(height: 2),
            Text('n ≥ n₀ : (xₙ)', style: style),
          ],
        ),
        const SizedBox(width: 6),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('(',
                style: style.copyWith(fontSize: 26, fontWeight: FontWeight.w200)),
            const SizedBox(width: 1),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('n² + n - 1', style: style.copyWith(fontSize: 8.5)),
                Container(
                  width: 44,
                  height: 0.9,
                  color: Colors.white.withValues(alpha: 0.5),
                  margin: const EdgeInsets.symmetric(vertical: 1.5),
                ),
                Text('n² - 2n + 3', style: style.copyWith(fontSize: 8.5)),
              ],
            ),
            const SizedBox(width: 1),
            Text(')',
                style: style.copyWith(fontSize: 26, fontWeight: FontWeight.w200)),
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text('⁵',
                  style: style.copyWith(
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ],
    );
  }
}

