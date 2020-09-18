import 'package:flutter/material.dart';

class Book {
  String bookNumber;
  String title;
  String author;
  String year;
  bool isAvailable;
  Color tint;
  String thumbnail;
  String abstract;
  String copies;
  String barCode;
  String issueDate;
  bool isReturned;
  String returnedDate;

  Book({
    this.bookNumber,
    this.title,
    this.author,
    this.year,
    this.isAvailable,
    this.tint,
    this.thumbnail,
    this.abstract,
    this.copies,
    this.barCode,
    this.issueDate,
    this.returnedDate,
    this.isReturned
  });

  String getBookShortName(){
    return this.title.substring(0, 2);
  }

  String getTitleWithLimit(){
    if(this.title.length > 25){
      return title.substring(0, 22) + "...";
    }

    return title;
  }

}