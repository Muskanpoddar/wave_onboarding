// lib/widgets/pagination_dots.dart
import 'package:flutter/material.dart';

class PaginationDots extends StatelessWidget {
  final int count;
  final int currentIndex;
  final Function(int)? onDotTap;

  const PaginationDots({
    super.key,
    required this.count,
    required this.currentIndex,
    this.onDotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        return GestureDetector(
          onTap: () => onDotTap?.call(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
            width: i == currentIndex ? 22 : 10,
            height: 10,
            decoration: BoxDecoration(
              color: i == currentIndex ? Colors.white : Colors.white60,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }),
    );
  }
}
