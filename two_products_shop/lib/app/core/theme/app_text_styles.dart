import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
  );

  static const subtitle = TextStyle(fontSize: 16, color: AppColors.textDark);

  static const body = TextStyle(fontSize: 14, color: AppColors.textDark);

  static const small = TextStyle(fontSize: 12, color: Colors.grey);
}
