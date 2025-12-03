import 'package:flutter/material.dart';

class SizeboxSquare extends StatelessWidget {
  final double size;
  const SizeboxSquare({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: size, height: size,);
  }
}