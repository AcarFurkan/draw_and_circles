import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'draw_state.dart';

class DrawCubit extends Cubit<DrawState> {
  DrawCubit() : super(DrawInitial()) {
    timer = Timer.periodic(animDuration, (timer) {
      emit(DrawInitial());
    });
  }
  Duration animDuration = const Duration(milliseconds: 5);
  List<Dot> drawCircle(Size size, double density) {
    // if (circles != null) {
    //   circles
    // }
    print("11");
    if (circles != null) {
      // for (var element in circles!) {
      //   print(2);
      //   var speed =
      //       Offset(Random().nextDouble() * 10, Random().nextDouble() * 10);
      //   element = element + speed;
      //   //  element = Offset(element.dx + 100, element.dy + 100);
      // }
      for (var i = 0; i < circles!.length; i++) {
        // circles![i].position = circles![i].position +
        //     Offset(Random().nextDouble() * 10, Random().nextDouble() * 10);
        circles![i] = Dot.nextDot(
            circles![i], animDuration.inMilliseconds.toDouble() / 50, size);

        //   circles![i] = Offset(circles![i].dx + 5, circles![i].dy);
      }
      return circles!;
    }
    print("33");

    return circles ??= _createDots(size, density);
  }

  late Timer timer;
  late BuildContext context;
  List<Dot>? circles;
  List<Dot> _createDots(Size size, double density) {
    var area = size.width * size.height;
    var dotCount = ((area / (100 * 100)) * density).toInt();
    List<Dot> list = [];
    for (var i = 0; i < dotCount; i++) {
      Offset position = Offset(Random().nextDouble() * size.width,
          Random().nextDouble() * size.height);
      Offset speed =
          Offset(Random().nextDouble() * 10, Random().nextDouble() * 10);
      if (Random().nextBool()) {
        speed = Offset(-speed.dx, speed.dy);
      }
      if (Random().nextBool()) {
        speed = Offset(speed.dx, -speed.dy);
      }
      list.add(Dot(position, speed));
    }
    return list;
  }
}

class Dot {
  Offset position;
  Offset speed;
  Dot(this.position, this.speed);

  factory Dot.nextDot(Dot dot, double time, Size size) {
    const double radius = 10;

   // print(time);
   // print(dot.speed);
    if (dot.position.dx < radius) {
      dot.speed = Offset(-dot.speed.dx, dot.speed.dy);
    }
    if (dot.position.dx > size.width - radius) {
      dot.speed = Offset(-dot.speed.dx, dot.speed.dy);
    }
    if (dot.position.dy < radius) {
      dot.speed = Offset(dot.speed.dx, -dot.speed.dy);
    }
    if (dot.position.dy > size.height - radius) {
      dot.speed = Offset(dot.speed.dx, -dot.speed.dy);
    }
    return Dot(dot.position + (dot.speed * time), dot.speed);
  }
}
