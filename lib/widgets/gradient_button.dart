import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/constants/constants.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final LinearGradient? gradient;
  final double? width;
  final IconData? icon;
  final bool isOutlined;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.gradient,
    this.width,
    this.icon,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width > AppDimens.maxContentWidth
        ? AppDimens.maxContentWidth
        : MediaQuery.of(context).size.width;

    if (isOutlined) {
      return _buildOutlined(maxW);
    }
    return _buildFilled(maxW);
  }

  Widget _buildFilled(double maxW) {
    return SizedBox(
      width: width ?? maxW * 0.85,
      height: AppDimens.buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null
              ? AppColors.white
              : AppColors.gray800,
          foregroundColor: onPressed != null
              ? AppColors.black
              : AppColors.gray600,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppDimens.iconSM),
              const SizedBox(width: AppDimens.paddingSM),
            ],
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: AppDimens.fontMD,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlined(double maxW) {
    return SizedBox(
      width: width ?? maxW * 0.85,
      height: AppDimens.buttonHeight,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.white,
          side: const BorderSide(
            color: AppColors.gray700,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppDimens.iconSM),
              const SizedBox(width: AppDimens.paddingSM),
            ],
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: AppDimens.fontMD,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}