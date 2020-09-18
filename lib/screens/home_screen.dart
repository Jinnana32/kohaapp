import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kohaapp/model/book.dart';
import 'package:kohaapp/model/profile.dart';
import 'package:kohaapp/style/dimens.dart';
import 'package:kohaapp/utils/BaseUrlGenerator.dart';
import 'package:kohaapp/utils/colorGenerator.dart';
import 'package:kohaapp/widget/books_widget.dart';
import 'package:kohaapp/widget/quotes_widget.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatelessWidget {

  TextEditingController searchBarController = TextEditingController();

  final GlobalKey<BookWidgetState> _bookWidgetState = GlobalKey<BookWidgetState>();

  BookWidget bookWidget;

  Profile mProfile;
  HomeScreen({Key key, @required this.mProfile}) : super(key: key);

  void searchBooks(String searchString) async {
    var searchUrl = '${BaseUrlGenerator.SEARCH_BOOKS}?searchQuery=${searchString}';
    var response = await http.get(Uri.encodeFull(searchUrl),
        headers: {"Accept": "application/json"});

    List<Book> tempBooks = [];
    List<dynamic> bookResp = jsonDecode(response.body).take(20).toList();

    for (var bookRespItem in bookResp) {
      Map<String, dynamic> book = bookRespItem;
      tempBooks.add(Book(
          bookNumber: book['bookNumber'].toString(),
          title: book['title'],
          author: book['author'] == null ? "Unknown" : book['author'],
          year: book['year'].toString(),
          tint: ColorGenerator.generateColor(),
          isAvailable: book['isAvailable'],
          abstract: book['abstract'],
          thumbnail: book['thumbnail'],
          copies: book['bookCount'].toString())
      );

    }

    _bookWidgetState.currentState.updateBooks(tempBooks);
  }

  @override
  Widget build(BuildContext context) {

    bookWidget = BookWidget(key: _bookWidgetState, mProfile: mProfile);

    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (event) {
      //print(event.data.logicalKey.keyId);
      if (event.runtimeType == RawKeyDownEvent &&
                          (event.logicalKey.keyId == 54)) {
        searchBooks(this.searchBarController.text);
      }
     },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  left: 20.0,
                  top: 50.0
                ),
                child: Text(
                  "Koha library",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: Dimens.LARGE_SPACE),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.LARGE_SPACE),
                child: TextField(
                  controller: searchBarController,
                  onSubmitted: (text) {
                    searchBooks(text);
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderRadius: BorderRadius.circular(Dimens.MEDIUM_SPACE),
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    contentPadding: EdgeInsets.all(0),
                    filled: true,
                    fillColor: Color(0xffF3F3F3),
                    hintText: "What would you like to read?"
                  )
                ),
              ),
              SizedBox(height: 20),
              QuotesWidget(),
              SizedBox(height: 20),
              bookWidget
            ],
          )
        ),
      ),
    );
  }

}