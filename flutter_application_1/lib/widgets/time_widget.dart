import 'package:flutter/material.dart';

class TimeWidget extends StatelessWidget {
  const TimeWidget({
    super.key,
    required this.duration,
    required this.color,
  });

  final Color color;
  final Duration duration;

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");

  @override
  Widget build(BuildContext context) {
    return Text(format(duration),
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: color,
        ));
  }
}
