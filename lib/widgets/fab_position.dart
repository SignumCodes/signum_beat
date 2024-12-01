import 'package:flutter/material.dart';

class PositionedFloatingActionButton extends StatelessWidget {
  final double top;
  final double left;
  final Widget floatingActionButton;

  PositionedFloatingActionButton({
    required this.top,
    required this.left,
    required this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(left, top),
      child: floatingActionButton,
    );
  }
}