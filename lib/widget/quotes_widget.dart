
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kohaapp/model/quote.dart';
import 'package:kohaapp/style/dimens.dart';
import 'package:http/http.dart' as http;
import 'package:kohaapp/utils/BaseUrlGenerator.dart';
import 'package:kohaapp/utils/colorGenerator.dart';



class QuotesWidget extends StatefulWidget {
  @override
  QuotesWidgetState createState() => new QuotesWidgetState();
}

class QuotesWidgetState extends State<QuotesWidget> {
  final String quotesUrl = BaseUrlGenerator.GET_QUOTES_API;

  List<Quote> quotes;

  getQuotes() async {
    var response = await http.get(
      Uri.encodeFull(quotesUrl),
      headers: { "Accept": "application/json" }
    );

    List<Quote> tempQuotes = [];
    List<dynamic> quoteResp  = jsonDecode(response.body);

    for(var quoteRespItem in quoteResp){
        Map<String, dynamic> quote = quoteRespItem;
        tempQuotes.add(Quote(message: quote['message'], author: quote['author'], tint: ColorGenerator.generateColor()));
    }

    setState((){
      quotes = tempQuotes;
    });

  }

  @override
  void initState(){
    super.initState();
    this.getQuotes();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
              height: 150,
              child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: quotes == null ? 0 : quotes.length,
                      itemBuilder: (BuildContext context, int index){
                          String message = quotes[index].message;
                          String author = quotes[index].author;

                          return Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0.0, 2.0),
                                  blurRadius: 6.0
                                )
                              ],
                              color: quotes[index].tint,
                              borderRadius: BorderRadius.circular(Dimens.SMALL_SPACE),
                            ),
                            margin: EdgeInsets.all(Dimens.SMALL_SPACE),
                            width: 180,
                            child:Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimens.MEDIUM_SPACE),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('"$message"',
                                      style: TextStyle(
                                      fontSize: message.length > 100 ? message.length > 150 ? Dimens.TEXT_EXTRA_EXTRA_SMALL : Dimens.TEXT_EXTRA_SMALL : Dimens.TEXT_SMALL,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white
                                    )),
                                  SizedBox(height: Dimens.LARGE_SPACE),
                                  Text('- $author', style: TextStyle(color: Colors.white),),
                                ],
                              ),
                            )
                          );
                      },
              )
            );
  }
}