import 'package:flutter/material.dart';

class TextSpanBuilder extends StatelessWidget {
  final String title;
  final String body;

  const TextSpanBuilder({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 4),
        Text(body, style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF27272A))),
      ],
    );
  }
}

