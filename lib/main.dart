import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kohaapp/screens/book_description_screen.dart';
import 'package:kohaapp/screens/login_screen.dart';
import 'package:kohaapp/style/dimens.dart';
import 'package:kohaapp/utils/colorGenerator.dart';

import 'model/book.dart';

void main() => runApp(KohaApp());

class KohaApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return kohaAppState();
  }
}

class kohaAppState extends State<KohaApp> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Koha Library',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue, scaffoldBackgroundColor: Colors.white),
      home: LoadingWidget(),
    );
  }

}

class LoadingWidget extends StatelessWidget {

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitChasingDots(
              color: Colors.white,
              size: 50.0,
            ),
            SizedBox(height: 50),
           Text("Welcome to Koha Library!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: Dimens.TEXT_HEADLINE,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2)),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(50),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => LoginScreen())
                      );
                    },
                    child: Text("Continue",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.black, fontWeight: FontWeight.w500)),
                  ),
                )
              ,
            )
          ],
        ));
  }

}
