import 'package:flutter/material.dart';

class FlyingText extends StatefulWidget {
  final double x, y;
  final String value;
  final Color color;
  final VoidCallback onComplete;

  const FlyingText({
    super.key, 
    required this.x, 
    required this.y, 
    required this.value, 
    required this.color, 
    required this.onComplete
  });

  @override
  State<FlyingText> createState() => _FlyingTextState();
}

class _FlyingTextState extends State<FlyingText> with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _m;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _m = Tween<double>(begin: 0.0, end: -150.0).animate(CurvedAnimation(parent: _c, curve: Curves.easeOut));
    _c.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => Positioned(
        left: widget.x - 60,
        top: widget.y + _m.value,
        child: Opacity(
          opacity: 1.0 - _c.value,
          child: Text(widget.value, style: TextStyle(color: widget.color, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}