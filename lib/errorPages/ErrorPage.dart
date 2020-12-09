import 'package:app_egresados/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PageError extends StatefulWidget{
  @override
  _PageErrorView createState() => _PageErrorView();
}

class _PageErrorView extends State<PageError>{
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Conexión fallida'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text('Verifique su conexión a Internet')
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute (builder: (BuildContext context) => MyHomePage()), (Route<dynamic>route) => false);
        }, child: Text("Aceptar"))
      ],
    );
  }


}