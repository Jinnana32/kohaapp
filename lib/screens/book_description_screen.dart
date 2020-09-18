import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:kohaapp/model/book.dart';
import 'package:kohaapp/style/dimens.dart';
import 'package:kohaapp/utils/BaseUrlGenerator.dart';
import 'package:http/http.dart' as http;
import 'package:kohaapp/utils/dateFormatter.dart';
import 'package:progress_dialog/progress_dialog.dart';

class BookDescriptionScreen extends StatefulWidget {

  Book mBook;
  String borrowerNumber;

  BookDescriptionScreen({Key key, @required this.mBook, @required this.borrowerNumber}) : super(key: key);

  @override
  _BookDescriptionScreenState createState() => _BookDescriptionScreenState();
}

class _BookDescriptionScreenState extends State<BookDescriptionScreen> {

  ProgressDialog pr;

  List<Map<String, dynamic>> items;

  _reserveBook(DateTime datetime, DateTime time, String bookNumber) async {
    var respMessage = "";
    pr.show();

    var formattedDate = DateFormatter.formatDate("yyyy-MM-dd", datetime);
    var formattedTime = DateFormatter.formatDate("H:m:S", time);
    var response = await http.post(
        Uri.encodeFull(
            "${BaseUrlGenerator.RESERVE_BOOK_API}?borrowernumber=${widget.borrowerNumber}&bookNumber=${bookNumber}&duedate=$formattedDate $formattedTime"),
        headers: {"Accept": "application/jsopn"});

    if (response.statusCode == 200) {
      respMessage = "You have successfully reserve a book";
    } else if (response.statusCode == 400) {
      respMessage =
      "Something went wrong while we reserve your book, try again later";
    } else {
      respMessage = "Sorry, please try again later";
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Book reservation'),
          content: Text(respMessage),
          elevation: 20.0,
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                if (response.statusCode == 200) {
                  this._getBookItems();
                }
                Navigator.of(dialogContext, rootNavigator: true)
                    .pop(); // Dismiss alert dialog
              },
            )
          ],
        );
      },
    );

    pr.hide();
  }

  _getBookItems() async {
    var response = await http.get(Uri.encodeFull(BaseUrlGenerator.GET_BOOK_ITEM + "?bookNumber=${widget.mBook.bookNumber}"),
        headers: {"Accept": "application/jsopn"});

    List<Map<String, dynamic>> tempItems = [];
    List<dynamic> itemResp = jsonDecode(response.body).take(20).toList();

    for (var bookRespItem in itemResp) {
      Map<String, dynamic> item = bookRespItem;
      tempItems.add(item);
    }

    setState(() {
      items = tempItems;
    });
  }

  @override
  void initState() {
    super.initState();
    this._getBookItems();
  }

  TextStyle mStyle = TextStyle(fontFamily: 'Montserrat', fontSize: Dimens.TEXT_BODY);

  @override
  Widget build(BuildContext context) {

    var onBookItemTapped = (String bookItemNumber, bool isAvailable) {
      showDialog<void>(
          context: context,
          barrierDismissible: true,
          // false = user must tap button, true = tap outside dialog
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(isAvailable ? 'Book Action' : 'Awww, We\'re sorry'),
              content: Text( isAvailable ? 'Hmmm, do you want to reserve this book?' : 'Sorry this book is not available at the moment'),
              actions: <Widget>[
                !isAvailable ? null : FlatButton(
                  child: Text('Reserve this book'),
                  onPressed: () {
                    Navigator.of(dialogContext, rootNavigator: true)
                        .pop(); // Dismiss alert dialog
                    // Show date picker
                    DatePicker.showDatePicker(context,
                        showTitleActions: true, onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          // Show time picker
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true, onConfirm: (time) {
                                pr = new ProgressDialog(context);

                                this._reserveBook(date, time, bookItemNumber);
                              },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.en);
                  },
                ),
              ],
              elevation: 20.0,
            );
          });
    };

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop())),
      body: Padding(
        padding: const EdgeInsets.all(Dimens.LARGE_SPACE),
        child: ListView(
          children: <Widget>[
                widget.mBook.thumbnail == null
                    ? Container(
                  width: 120,
                  height: 100,
                  decoration: BoxDecoration(
                      color: widget.mBook.tint,
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
                        widget.mBook.getBookShortName(),
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
                      "${BaseUrlGenerator.GET_BOOK_THUMBNAIL}/${widget.mBook.thumbnail}",
                      width: 120,
                      height: 150,
                      fit: BoxFit.cover,
                    )),
            SizedBox(height: 20,),
            Center(
                child: Text(
                  widget.mBook.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: widget.mBook.title.length > 50
                        ? Dimens.TEXT_TITLE
                        : Dimens.TEXT_LARGE_HEADLINE,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            SizedBox(height: 20),
            Center(child: Text("Written by: ${widget.mBook.author}", style: TextStyle(color: Colors.grey),)),
            SizedBox(height: 30,),
            Text("Year: ${widget.mBook.year}", style: mStyle,),
            SizedBox(height: 10,),
            Text("Book number: ${widget.mBook.bookNumber}", style: mStyle,),
            SizedBox(height: 20,),
            Text("Abstract", style: mStyle.copyWith( fontSize: Dimens.TEXT_TITLE, fontWeight: FontWeight.w700),),
            SizedBox(height: 5,),
            Text(widget.mBook.abstract != null ? widget.mBook.abstract : "There is currently no available abstract", style: mStyle,),
            SizedBox(height: 30,),
            Text("Available copies", style: mStyle.copyWith( fontSize: Dimens.TEXT_TITLE, fontWeight: FontWeight.w700),),
            SizedBox(height: 10,),
            ListView.separated(
              separatorBuilder: (context, index) {
                return SizedBox(height: 10,);
              },
              itemCount: items != null ? items.length : 0,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    onBookItemTapped(items[index]["itemNumber"].toString(), items[index]["isAvailable"]);
                  },
                  child: Card(
                    color: Colors.blueAccent,
                    child: Padding(
                      padding: const EdgeInsets.all(Dimens.LARGE_SPACE),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("CODE: ${items[index]["barcode"]}", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          Container(
                              decoration: BoxDecoration(
                                  color: items[index]["isAvailable"]
                                      ? Color(0xff16A085)
                                      : Color(0xffF39C12),
                                  borderRadius: BorderRadius.circular(
                                      Dimens.EXTRA_SMALL_SPACE)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: Dimens.MEDIUM_SPACE,
                                    vertical: Dimens.EXTRA_SMALL_SPACE),
                                child: Text(
                                    items[index]["isAvailable"] ? "Available" : "Unavailable",
                                    style: TextStyle(color: Colors.white)),
                              ))
                        ],
                      ),
                    ),
                  ),
                );
              },
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true
            )
          ],
        ),
      ),
    );
  }
}
