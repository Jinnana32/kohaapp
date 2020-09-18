import 'package:flutter/material.dart';
import 'package:kohaapp/model/profile.dart';
import 'package:kohaapp/widget/reservation_widget.dart';


class ReserveScreen extends StatelessWidget {

  Profile mProfile;

  ReserveScreen({Key key, @required this.mProfile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                  left: 20.0,
                  top: 50.0
              ),
              child: Text(
                "My Reservations",
                style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            SizedBox(height: 20),
            ReserveBookWidget(mProfile: mProfile)
          ],
        ),
      ),
    );
  }

}