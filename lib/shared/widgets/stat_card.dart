import 'package:flutter/material.dart';
import 'dart:ui';

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
    return GestureDetector(
      onTap: () {
        // Show detailed stats on tap.
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF1D976C), Color(0xFF93F9B9)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: const Offset(0, 10),
              blurRadius: 20,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -20,
              right: -20,
              child: Icon(
                icon,
                color: Colors.white.withOpacity(0.2),
                size: 100,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 40),
                const SizedBox(height: 12),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
