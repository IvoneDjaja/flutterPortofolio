import 'package:flutter/material.dart';

class VerticalFractionBar extends StatelessWidget {
  const VerticalFractionBar({
    super.key,
    this.color,
    required this.fraction,
  });

  final Color? color;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return SizedBox(
        height: constraints.maxHeight,
        width: 4,
        child: Column(
          children: [
            SizedBox(
              height: (1 - fraction) * constraints.maxHeight,
              child: Container(
                color: Colors.black,
              ),
            ),
            SizedBox(
              height: fraction * constraints.maxHeight,
              child: Container(color: color),
            ),
          ],
        ),
      );
    });
  }
}
