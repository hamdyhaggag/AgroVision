import 'package:flutter/material.dart';
import 'dart:ui'; // Import this to use ImageFilter

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
          12), // Clip the border radius of the entire widget
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5), // Blur effect
        child: SizedBox(
          width: 170,
          height: 210,
          child: Card(
            color: Colors.green.shade400.withOpacity(
                0.1), // Set a transparent background with slight opacity
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.green, size: 42),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  value,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
