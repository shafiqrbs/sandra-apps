import 'package:flutter/material.dart';

class CustomAnimationWidget extends StatefulWidget {
  bool leftPosition;
  Widget child;
  CustomAnimationWidget({super.key, required this.leftPosition, required this.child,});

  @override
  State<CustomAnimationWidget> createState() => _CustomAnimationWidgetState();
}

class _CustomAnimationWidgetState extends State<CustomAnimationWidget>  with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Slide animation
    _slideAnimation = Tween<Offset>(
        begin: Offset(widget.leftPosition == true ? -1.0 : 1.0, 0.0),  // Start off-screen to the left
        end: const Offset(0.0, 0.0)      // End at horizontal center
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    ));

    // Scale animation
    _scaleAnimation = Tween<double>(
        begin: 0.8,  // Start small
        end: 1.0     // End at full size
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 0.6, curve: Curves.linear), // controll the speed of the animation
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: _slideAnimation.value * MediaQuery.of(context).size.width,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: Center(  // Ensure the image is centered vertically and horizontally
        child: widget.child,  // Ensure the image asset path is correct
      ),
    );
  }
}