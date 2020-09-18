import 'package:flutter/material.dart';



class Quote {
  String message;
  String author;
  Color tint;

  Quote({
    this.message,
    this.author,
    this.tint
  });

  static String quoteWrap(String quote){
    if(quote.length > 100){
      return quote.substring(0, 97) + "...";
    }

    return quote;
  }
}

List<Quote> tempQuotes = [
    Quote(message: "They say life is wrong but, they are wrong", author: "Dr. John Doe", tint: Color(0xffE29E9E)),
    Quote(message: "Sample 2", author: "Dr. John Doe", tint: Color(0xff2C3E50)),
    Quote(message: "Sample 3", author: "Dr. John Doe", tint: Color(0xff9B59B6))
];