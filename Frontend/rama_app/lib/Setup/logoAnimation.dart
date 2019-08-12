import 'package:flutter/material.dart';


class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({ Key key, this.controller}) :

  // Each animation defined here transforms its value during the subset
  // of the controller's duration defined by the animation's interval.
  // For example the opacity animation transforms its value during
  // the first 10% of the controller's duration.

        opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Interval(
              0.0, 0.500,
              curve: Curves.easeIn,
            ),
          ),
        ),

  // ... Other tween definitions ...

        super(key: key);

  final Animation<double> controller;

  final Animation<double> opacity;


  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget child) {
    return Opacity(
      opacity: opacity.value,
      child: Image.asset(
        'assets/images/logo.png',
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: _buildAnimation,
      animation: controller,
    );
  }
}