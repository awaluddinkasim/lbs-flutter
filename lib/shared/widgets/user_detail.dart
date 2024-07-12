import 'package:flutter/material.dart';

class UserDetail extends StatelessWidget {
  const UserDetail({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(value),
        const SizedBox(height: 12),
      ],
    );
  }
}
