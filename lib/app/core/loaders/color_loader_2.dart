import 'dart:math';

import 'package:sandra/app/core/importer.dart';

class ColorLoader2 extends StatefulWidget {
  final Color color1;
  final Color color2;
  final Color color3;

  const ColorLoader2({
    super.key,
    this.color1 = Colors.deepOrangeAccent,
    this.color2 = Colors.yellow,
    this.color3 = Colors.lightGreen,
  });

  @override
  _ColorLoader2State createState() => _ColorLoader2State();
}

class _ColorLoader2State extends State<ColorLoader2>
    with TickerProviderStateMixin {
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late AnimationController controller1;
  late AnimationController controller2;
  late AnimationController controller3;

  @override
  void initState() {
    super.initState();

    controller1 = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    controller2 = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    controller3 = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    animation1 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller1,
        curve: const Interval(0, 1),
      ),
    );

    animation2 = Tween<double>(begin: -1, end: 0).animate(
      CurvedAnimation(
        parent: controller2,
        curve: const Interval(0, 1, curve: Curves.easeIn),
      ),
    );

    animation3 = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller3,
        curve: const Interval(0, 1, curve: Curves.decelerate),
      ),
    );

    controller1.repeat();
    controller2.repeat();
    controller3.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          RotationTransition(
            turns: animation1,
            child: CustomPaint(
              painter: Arc1Painter(widget.color1),
              child: const SizedBox(
                width: 50,
                height: 50,
              ),
            ),
          ),
          RotationTransition(
            turns: animation2,
            child: CustomPaint(
              painter: Arc2Painter(widget.color2),
              child: const SizedBox(
                width: 50,
                height: 50,
              ),
            ),
          ),
          RotationTransition(
            turns: animation3,
            child: CustomPaint(
              painter: Arc3Painter(widget.color3),
              child: const SizedBox(
                width: 50,
                height: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    controller3.dispose();
    super.dispose();
  }
}

class Arc1Painter extends CustomPainter {
  final Color color;

  Arc1Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p1 = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Rect rect1 = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(rect1, 0, 0.5 * pi, false, p1);
    canvas.drawArc(rect1, 0.6 * pi, 0.8 * pi, false, p1);
    canvas.drawArc(rect1, 1.5 * pi, 0.4 * pi, false, p1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc2Painter extends CustomPainter {
  final Color color;

  Arc2Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p2 = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Rect rect2 = Rect.fromLTWH(
      0.0 + (0.2 * size.width) / 2,
      0.0 + (0.2 * size.height) / 2,
      size.width - 0.2 * size.width,
      size.height - 0.2 * size.height,
    );

    canvas.drawArc(rect2, 0, 0.5 * pi, false, p2);
    canvas.drawArc(rect2, 0.8 * pi, 0.6 * pi, false, p2);
    canvas.drawArc(rect2, 1.6 * pi, 0.2 * pi, false, p2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class Arc3Painter extends CustomPainter {
  final Color color;

  Arc3Painter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p3 = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final Rect rect3 = Rect.fromLTWH(
      0.0 + (0.4 * size.width) / 2,
      0.0 + (0.4 * size.height) / 2,
      size.width - 0.4 * size.width,
      size.height - 0.4 * size.height,
    );

    canvas.drawArc(rect3, 0, 0.9 * pi, false, p3);
    canvas.drawArc(rect3, 1.1 * pi, 0.8 * pi, false, p3);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
