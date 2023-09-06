import 'package:app/constants.dart';
import 'package:flutter/material.dart';

class GradientDecoratedContainer extends StatelessWidget {
  final Widget? child;
  const GradientDecoratedContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.maxFinite,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [accentColor, tartiaryColor],
        ),
      ),
      child: child,
    );
  }
}
