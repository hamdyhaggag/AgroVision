import 'package:flutter/material.dart';

class CustomArrowBackBottom extends StatelessWidget {
  const CustomArrowBackBottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 0.5, color: Color(0xB2B2CCFF)),
            borderRadius: BorderRadius.circular(40),
          ),
        ),
        child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
            )));
  }
}
