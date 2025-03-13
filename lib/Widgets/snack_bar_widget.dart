import 'package:flutter/material.dart';

class SnackBarWidget extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const SnackBarWidget({
    Key? key,
    required this.message,
    this.backgroundColor = Colors.black87,
    this.textColor = Colors.white,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: textColor,),
            const SizedBox(width: 12,),
          ],
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor),
            )
          )
        ],
      ),
    );
  }

  // Cambia este método a estático
  static void _showSnackBar({
    required BuildContext context, 
    required String message,
    Color color = Colors.black87,
    IconData? icon,
    Duration duration = const Duration(milliseconds: 1500)
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SnackBarWidget(
          message: message,
          backgroundColor: color,
          icon: icon,
        ),
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Cambia estos métodos a estáticos
  static void showSuccess(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      color: Colors.green,
      icon: Icons.check_circle,
    );
  }

  static void showError(BuildContext context, String message) {
    _showSnackBar(
      context: context,
      message: message,
      color: Colors.red,
      icon: Icons.error_outline,
    );    
  }
}