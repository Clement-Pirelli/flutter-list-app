import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AnimatedBox extends AnimatedWidget
{
  AnimatedBox({Key key, Animation<Color> animation}) : super(key : key,listenable : animation);


  @override
  Widget build(BuildContext context) {
    final Animation<Color> animation = listenable;
    return Container(
      color: animation.value
    );
  }

}