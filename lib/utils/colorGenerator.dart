
import 'package:flutter/material.dart';
import 'dart:math';

class ColorGenerator {
  static List<Color> quoteColors = [Color(0xffE29E9E), Color(0xff2C3E50), Color(0xff2980B9), Color(0xff7F8C8D), Color(0xff9B59B6)];

  static Color generateColor(){
    Random random = new Random();
    int randomQuoteIndex = random.nextInt(quoteColors.length);
    return quoteColors[randomQuoteIndex];
  }

}