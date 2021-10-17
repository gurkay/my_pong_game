import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double diam = 50;
    return Container(
      width: diam,
      height: diam,
      decoration: const BoxDecoration(
        color: Colors.amber,
        shape: BoxShape.circle,
      ),
    );
  }
}
