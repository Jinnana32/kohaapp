import 'package:flutter/material.dart';
import 'package:kohaapp/model/book.dart';
import 'package:kohaapp/model/profile.dart';
import 'package:kohaapp/style/dimens.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kohaapp/utils/BaseUrlGenerator.dart';
import 'package:kohaapp/utils/colorGenerator.dart';
class ReserveBookWidget extends StatefulWidget {
  Profile mProfile;

  ReserveBookWidget({Key key, @required this.mProfile}) : super(key: key);

  @override
  ReserveBookWidgetState createState() => new ReserveBookWidgetState();
}

class ReserveBookWidgetState extends State<ReserveBookWidget> {

  String booksReserveUrl;

  List<Book> books = [];

  _getBooks() async {
    var response = await http.get(Uri.encodeFull(booksReserveUrl),
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
          thumbnail: book['thumbnail'],
          isAvailable: false,
          barCode: book['barCode'],
          issueDate: book['issueDate'],
          returnedDate: book['returnDate'],
          isReturned: book['isReturned']
      ));
    }

    setState(() {
      books = tempBooks;
    });
  }

  @override
  void initState() {
    super.initState();
    booksReserveUrl = "${BaseUrlGenerator.GET_RESERVED_BOOKS_API}?borrowerNumber=${widget.mProfile.borrowerNumber}";
    this._getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: books.length < 1
            ? Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: Dimens.LARGE_SPACE),
                child: Text("You currently don't have any reserved books",
                    style: TextStyle(
                        color: Colors.grey, fontSize: Dimens.TEXT_BODY)),
              )
            : ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: books != null ? books.length : 0,
                itemBuilder: (BuildContext context, int index) {
                  Book _book = books[index];
                  String _author = books[index].author;
                  bool _isReturned = books[index].isReturned;
                  Color _tint = books[index].tint;
                  String _year = books[index].year;

                  return Container(
                      margin: EdgeInsets.only(
                          left: Dimens.LARGE_SPACE, right: Dimens.LARGE_SPACE),
                      child: Row(
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              _book.thumbnail == null
                                  ? Container(
                                      width: 120,
                                      height: 140,
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
                                            fontSize: Dimens
                                                .TEXT_EXTRA_LARGE_HEADLINE,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      )),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          Dimens.MEDIUM_SPACE),
                                      child: Image.network(
                                        "${BaseUrlGenerator.GET_BOOK_THUMBNAIL}/${_book.thumbnail}",
                                        width: 120,
                                        height: 140,
                                        fit: BoxFit.cover,
                                      )),
                              Positioned(
                                bottom: 1,
                                right: 5,
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: _isReturned
                                            ? Color(0xff16A085)
                                            : Color(0xffF39C12),
                                        borderRadius: BorderRadius.circular(
                                            Dimens.MEDIUM_SPACE)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: Dimens.MEDIUM_SPACE,
                                          vertical: Dimens.EXTRA_SMALL_SPACE),
                                      child: Text(
                                          _isReturned ? "Returned" : "Not returned",
                                          style: TextStyle(color: Colors.white, fontSize: Dimens.TEXT_EXTRA_SMALL)),
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
                                    style: TextStyle(color: Color(0xff707070))),
                                SizedBox(height: Dimens.EXTRA_SMALL_SPACE),
                                Text("Issue date: ${_book.issueDate}",
                                    style: TextStyle(color: Color(0xff707070), fontSize: Dimens.TEXT_SMALL)),
                                SizedBox(height: Dimens.EXTRA_SMALL_SPACE),
                                Text("Date to return: ${_book.returnedDate != null ? _book.returnedDate : "N/A"}",
                                    style: TextStyle(color: Color(0xff707070), fontSize: Dimens.TEXT_SMALL)),
                                SizedBox(height: Dimens.EXTRA_SMALL_SPACE),
                                Text("Barcode: ${_book.barCode}",
                                    style: TextStyle(color: Color(0xff707070), fontSize: Dimens.TEXT_SMALL))

                              ],
                            ),
                          )
                        ],
                      ));
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: 10);
                },
              ));
  }
}
