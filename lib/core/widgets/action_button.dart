import 'package:flutter/material.dart';

Widget buildGlassyActionButton({
  required VoidCallback? onPressed,
  required Widget child,
  bool isPrimary = false,
}) {
  return TextButton(
    onPressed: onPressed,
    style: TextButton.styleFrom(
      foregroundColor: Colors.black87,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0, // Flat glassy look
    ),
    child: child,
  );
}