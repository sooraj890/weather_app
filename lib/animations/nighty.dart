import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: NightView(),
  ));
}

class NightView extends StatefulWidget {
  @override
  State<NightView> createState() => _NightViewState();
}

class _NightViewState extends State<NightView>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          /// 🌙 Moon
          Positioned(
            top: 100,
            right: 100,
            child: Icon(Icons.nights_stay_rounded,size: 50,)
          ),

          /// ⭐ Twinkling Stars
          ...List.generate(1, (index) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Positioned(
                  top: Random().nextDouble() * 1200,
                  left: Random().nextDouble() * 500,
                  child: Opacity(
                    opacity: _controller.value,
                    child: Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 5,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}