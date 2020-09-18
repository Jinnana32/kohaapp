import 'package:flutter/material.dart';
import 'package:kohaapp/model/profile.dart';
import 'package:kohaapp/style/dimens.dart';

import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {

  Profile mProfile;

  TextStyle mStyle = TextStyle(fontFamily: 'Montserrat', fontSize: Dimens.TEXT_LARGE_TITLE);

  ProfileScreen({Key key, @required this.mProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 50, right: 50, top: 20),
              child: CircleAvatar(
                radius: 50.0,
                child: Center(child: Text(mProfile.getShorName(), style:
                TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: Dimens.TEXT_LARGE_HEADLINE))
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(child: Text(mProfile.firstname + " " + mProfile.surname, style: mStyle.copyWith(fontWeight: FontWeight.w700, fontSize: Dimens.TEXT_HEADLINE),)),
            SizedBox(height: 30),
            Center(child: Text("Card Number: " + mProfile.cardNumber, style: mStyle)),
            SizedBox(height: 10),
            Center(child: Text("Email: ${mProfile.email != null ? mProfile.email : "N/A"}", style: mStyle)),
            SizedBox(height: 10),
            Center(child: Text("Mobile num: ${mProfile.contactNumber != null ? mProfile.contactNumber : "N/A" } ", style: mStyle)),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => LoginScreen())
                  );
                },
                child: Text("Logout", style: TextStyle(color: Color(0xffc0392b), fontSize: Dimens.TEXT_LARGE_HEADER)),
              ),
            )
          ],
        ),
      )
    );
  }

}