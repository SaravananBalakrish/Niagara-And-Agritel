import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CustomButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const CustomButton({super.key,
    required this.onPressed,
    required this.text,
    required this.isLoading,
  });

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLoading ? null : (_) => setState(() => _isHovered = true),
      onTapUp: widget.isLoading ? null : (_) => setState(() => _isHovered = false),
      onTapCancel: widget.isLoading ? null : () => setState(() => _isHovered = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isHovered && !widget.isLoading
                ? [Colors.blue.shade700, Colors.blue.shade900]
                : [Colors.blue.shade600, Colors.blue.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_isHovered && !widget.isLoading ? 0.4 : 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: widget.isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
              : Text(
            widget.text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ).animate().scale(
        begin: Offset(_isHovered && !widget.isLoading ? 1.0 : 1.0, _isHovered && !widget.isLoading ? 1.0 : 1.0),
        end: Offset(_isHovered && !widget.isLoading ? 1.05 : 1.0, _isHovered && !widget.isLoading ? 1.05 : 1.0),
        duration: 200.ms,
        curve: Curves.easeInOut,
      ),
    );
  }
}