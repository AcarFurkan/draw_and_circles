import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/draw_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DrawCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: BlocBuilder<DrawCubit, DrawState>(
        builder: (context, state) {
          return CustomPaint(
            painter: MyPainter(context),
          );
        },
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  BuildContext context;
  MyPainter(this.context);
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    const double circleRadius = 2;
    const double lineTreshold = 65;
    const double lineStroke = 4;
    final circlePainter = Paint()
      ..color = Colors.white
      ..strokeWidth = 6.0
      ..style = PaintingStyle.fill;
    final linePainter = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.0
      ..style = PaintingStyle.fill;
    var centerOffset = Offset(size.width / 2, size.height / 2);

    var dots = context.read<DrawCubit>().drawCircle(size, 5);
    for (var element in dots) {
      canvas.drawCircle(element.position, circleRadius, circlePainter);
    }

    for (var i = 0; i < dots.length; i++) {
      for (var j = i + 1; j < dots.length; j++) {
        var x = dots[i].position.dx - dots[j].position.dx;
        var y = dots[i].position.dy - dots[j].position.dy;

        var distance = sqrt(x * x + y * y);
        var strokeWidth =
            ((lineTreshold - distance) / lineTreshold) * lineStroke;
        if (distance < lineTreshold) {
          canvas.drawLine(
              dots[i].position,
              dots[j].position,
              Paint()
                ..strokeWidth = strokeWidth
                ..color = Colors.white);
        }
      }
    }
  }
}
