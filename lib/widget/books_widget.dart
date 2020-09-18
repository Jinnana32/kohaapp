import 'package:flutter/material.dart';
import 'package:kohaapp/model/book.dart';
import 'package:kohaapp/model/profile.dart';
import 'package:kohaapp/screens/book_description_screen.dart';
import 'package:kohaapp/style/dimens.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kohaapp/utils/BaseUrlGenerator.dart';
import 'package:kohaapp/utils/colorGenerator.dart';

class BookWidget extends StatefulWidget {
  Profile mProfile;
  BookWidget({Key key, @required this.mProfile}) : super(key: key);

  @override
  BookWidgetState createState() => new BookWidgetState();
}

class BookWidgetState extends State<BookWidget> {

  String booksUrl = BaseUrlGenerator.GET_BOOK_API;
  String bookReserveUrl = BaseUrlGenerator.RESERVE_BOOK_API;

  List<Book> books;

  _getBooks() async {
    var response = await http.get(Uri.encodeFull(booksUrl),
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

    setState(() {
      books = tempBooks;
    });
  }

  void updateBooks(List<Book> _books) {
    setState(() {
      books = _books;
    });
  }

  @override
  void initState() {
    super.initState();
    this._getBooks();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        child: Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.LARGE_SPACE),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Our books",
                style: TextStyle(
                    fontSize: Dimens.TEXT_LARGE_TITLE,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff707070))),
            Text("")
          ],
        ),
      ),
      SizedBox(height: 20),
      ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: books != null ? books.length : 0,
        itemBuilder: (BuildContext context, int index) {
          Book _book = books[index];
          String _author = books[index].author;
          bool _isAvailable = books[index].isAvailable;
          Color _tint = books[index].tint;
          String _year = books[index].year;

          return GestureDetector(
            onTap: () {
              // Show options when book is tapped
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => BookDescriptionScreen(
                    mBook: _book,
                    borrowerNumber: widget.mProfile.borrowerNumber,))
              );
            },
            child: Container(
                margin: EdgeInsets.only(
                    left: Dimens.LARGE_SPACE, right: Dimens.LARGE_SPACE),
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        _book.thumbnail == null
                            ? Container(
                                width: 120,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: _tint,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(0.0, 2.0),
                                          blurRadius: 6.0)
                                    ],
                                    borderRadius: BorderRadius.circular(
                                        Dimens.MEDIUM_SPACE)),
                                child: Center(
                                    child: Text(
                                  _book.getBookShortName(),
                                  style: TextStyle(
                                      fontSize:
                                          Dimens.TEXT_EXTRA_LARGE_HEADLINE,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                )),
                              )
                            : ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.MEDIUM_SPACE),
                                child: Image.network(
                                  "${BaseUrlGenerator.GET_BOOK_THUMBNAIL}/${_book.thumbnail}",
                                  width: 120,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )),
                        Positioned(
                          bottom: 1,
                          right: 5,
                          child: Container(
                              decoration: BoxDecoration(
                                  color: _isAvailable
                                      ? Color(0xff16A085)
                                      : Color(0xffF39C12),
                                  borderRadius: BorderRadius.circular(
                                      Dimens.MEDIUM_SPACE)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.MEDIUM_SPACE,
                                    vertical: Dimens.EXTRA_SMALL_SPACE),
                                child: Text(
                                    _isAvailable ? "In stock ${_book.copies}" : "No stock",
                                    style: TextStyle(color: Colors.white)),
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(_book.getTitleWithLimit(),
                              style: TextStyle(
                                  fontSize: Dimens.TEXT_BODY,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff707070))),
                          SizedBox(height: Dimens.EXTRA_SMALL_SPACE),
                          Text(_author,
                              style: TextStyle(color: Color(0xffBFB9B9))),
                          Text(_year,
                              style: TextStyle(color: Color(0xff707070)))
                        ],
                      ),
                    )
                  ],
                )),
          );
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 10);
        },
      )
    ]));
  }
}
