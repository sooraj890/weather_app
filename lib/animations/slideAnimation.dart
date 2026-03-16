import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SlideInWidget extends StatefulWidget {
  final Widget child;

  const SlideInWidget({super.key, required this.child});

  @override
  State<SlideInWidget> createState() => _SlideInWidgetState();
}

class _SlideInWidgetState extends State<SlideInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  bool hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));

    _animation = Tween<Offset>(
      begin: Offset(-1.0, 0), // start off-screen left
      end: Offset(0, 0),      // final position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    if (!hasAnimated) {
      _controller.forward();
      hasAnimated = true; // ensures it only animates once
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('slide-${widget.child.hashCode}'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1) {
          _startAnimation();
        }
      },
      child: SlideTransition(
        position: _animation,
        child: widget.child,
      ),
    );
  }
}