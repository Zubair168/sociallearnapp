import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SupportChip extends StatelessWidget {
  final VoidCallback? onTap;

  const SupportChip({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: const Color(0xFFE2E8F0),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/whatsapp_logo.svg',
              width: 19,
              height: 19,
            ),
            const SizedBox(width: 7),
            const Text(
              'Support',
              style: TextStyle(
                color: Color(0xFF68717A),
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

