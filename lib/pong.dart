import 'package:flutter/material.dart';
import 'dart:math';

import 'constants/constant.dart';
import 'ball.dart';
import 'bat.dart';

class Pong extends StatefulWidget {
  const Pong({Key? key}) : super(key: key);

  @override
  _PongState createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  late double width;
  late double height;
  late double posX;
  late double posY;
  late double batWidth;
  late double batHeight;
  late double batPosition = 0;
  Direction vDir = Direction.down;
  Direction hDir = Direction.right;
  late Animation<double> animation;
  late AnimationController animationController;
  double increment = 5;
  double randX = 1;
  double randY = 1;
  int score = 0;

  @override
  void initState() {
    super.initState();
    posX = 0;
    posY = 0;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 10000),
    );
    animation = Tween<double>(begin: 0, end: 100).animate(animationController);
    animation.addListener(() {
      setState(() {
        checkBorders();
        (hDir == Direction.right)
            ? posX += ((increment * randX).round())
            : posX -= ((increment * randX).round());
        (vDir == Direction.down)
            ? posY += ((increment * randY).round())
            : posY -= ((increment * randY).round());
      });
      checkBorders();
    });
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        batWidth = width / 5;
        batHeight = height / 20;

        return Stack(
          children: [
            Positioned(
              child: Text(
                'Score: ' + score.toString(),
              ),
              top: 0,
              right: 24,
            ),
            Positioned(
              child: Ball(),
              top: posY,
              left: posX,
            ),
            Positioned(
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) {
                  moveBat(update, context);
                },
                child: Bat(batWidth, batHeight),
              ),
              bottom: 0,
              left: batPosition,
            ),
          ],
        );
      },
    );
  }

  void checkBorders() {
    double diameter = 50;
    if (posX <= 0 && hDir == Direction.left) {
      hDir = Direction.right;
      randX = randomNumber();
    }
    if (posX >= width - diameter && hDir == Direction.right) {
      hDir = Direction.left;
      randX = randomNumber();
    }
    // check the bat position as well
    if (posY >= height - diameter - batHeight && vDir == Direction.down) {
      if (posX >= (batPosition - diameter) &&
          posX <= (batPosition + batWidth + diameter)) {
        vDir = Direction.up;
        randY = randomNumber();
        setState(() {
          score++;
        });
      } else {
        animationController.stop();
        showMessage(context);
      }
    }
    if (posY <= 0 && vDir == Direction.up) {
      vDir = Direction.down;
      randX = randomNumber();
    }
  }

  void showMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text('Would you like to play again?'),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  posX = 0;
                  posY = 0;
                  score = 0;
                });
                Navigator.of(context).pop();
                animationController.repeat();
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                dispose();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  double randomNumber() {
    var ran = Random();
    int myNum = ran.nextInt(100);
    return (50 + myNum) / 100;
  }

  void moveBat(DragUpdateDetails dragUpdateDetails, BuildContext context) {
    setState(() {
      batPosition += dragUpdateDetails.delta.dx;
    });
  }
}
