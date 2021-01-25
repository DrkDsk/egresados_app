import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      height: 100,
      decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/ittg_logo.png'),
          )
      ),
    );
  }
}