import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:kohaapp/model/profile.dart';
import 'package:kohaapp/style/dimens.dart';
import 'package:kohaapp/utils/BaseUrlGenerator.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'main_navigation_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final String loginUrl = BaseUrlGenerator.SUBMIT_LOGIN_API;
  ProgressDialog pr;
  var respMessage = "";

  _submitLogin(String cardNumber, String password) async {
    // Show loading while logging in
    pr.show();

    var response =
        await http.get(loginUrl + "?password=$password&cardNumber=$cardNumber");

    if (response.statusCode == 200) {
      respMessage = "You have successfully login";
    } else if (response.statusCode == 400) {
      respMessage = "Something went wrong while logging in, try again later";
    } else {
      respMessage = "Sorry, please try again later";
    }

    Map<String, dynamic> profile = jsonDecode(response.body);
    Profile userProfile = Profile(
        firstname: profile["firstname"],
        surname: profile["surname"],
        cardNumber: profile["cardnumber"],
        email: profile["email"],
        contactNumber: profile["mobile"],
        borrowerNumber: profile['borrowernumber'].toString());

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Login'),
          content: Text(respMessage),
          elevation: 20.0,
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                if (response.statusCode == 200) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainNavigationScreen(
                                mProfile: userProfile,
                              )));
                } else {
                  Navigator.of(dialogContext, rootNavigator: true)
                      .pop(); // Dismiss alert dialog
                }
                // Dismiss alert dialog
                // Hide loading after getting the login response
                pr.hide();
              },
            )
          ],
        );
      },
    );

    // Hide loading after getting the login response
    pr.hide();
    // Hide loading after getting the login response
    pr.dismiss();
  }

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  @override
  Widget build(BuildContext context) {
    final cardNumberField = TextField(
      controller: cardNumberController,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Card Number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField = TextField(
      controller: passwordController,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "User ID",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colors.blueAccent,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          pr = new ProgressDialog(context);
          _submitLogin(cardNumberController.text, passwordController.text);
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Center(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 155.0,
                        child: Icon(
                          Icons.book,
                          size: 150,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Center(
                        child: Text("Koha library",
                            style: TextStyle(fontSize: Dimens.TEXT_TITLE)),
                      ),
                      SizedBox(height: 45.0),
                      passwordField,
                      SizedBox(height: 25.0),
                      cardNumberField,
                      SizedBox(
                        height: 35.0,
                      ),
                      loginButon,
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
