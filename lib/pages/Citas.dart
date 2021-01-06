import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;

import 'Registro.dart';

class Citas extends StatefulWidget{
  @override
  _CitasView createState() => _CitasView();
}

class _CitasView extends State<Citas>{

  bool isLoading = true;
  bool sinCitas = false;
  double topContainer = 0;
  List<Widget>listaCitas = [];

  void initState(){
    super.initState();
    getCitas();
  }

  getCitas() async{
    setState(() {isLoading = true;});
    List<dynamic> responseList = [];
    List<Widget> listItems = [];

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();

    var citas = await http.get("http://192.168.1.68:8000/api/getCitas/"+id);
    if (citas.statusCode == 200){
      setState(() {
        responseList = json.decode(citas.body);
        isLoading = false;
      });

      responseList.forEach((cita) {
        listItems.add(Container(
          height: 130,
          margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)),color: Colors.white, boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(100),blurRadius: 10.0),
          ]),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        cita["descripcion"],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "Fecha: ",
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)
                        ),
                        Text(
                          cita["fecha"],
                          style: const TextStyle(fontSize: 17, color: Colors.black87),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                            "Trámite: ",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87)
                        ),
                        Text(
                            cita["tipo"],
                            style: const TextStyle(fontSize: 17, color: Colors.black87)
                        )
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                )
              ],
            ),
          ),
        ));
      });
      setState(() {listaCitas = listItems;});
    }
    else if(citas.statusCode == 401){
      setState(() {
        sinCitas = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('Calendario de Citas')),
      drawer: MyDrawer(),
      body: Container(
          child: isLoading ? Center(child: CircularProgressIndicator()) : sinCitas ? Center(child: ListView(
            children: [
              header(),
              noCitas()
            ],
          )) :
          ListView.builder(
            padding: const EdgeInsets.all(6),
            itemCount: listaCitas.length,
            itemBuilder: (BuildContext context,int index){
              double scale = 1.0;
              if (topContainer > 0.5) {
                scale = index + 0.5 - topContainer;
                if (scale < 0) {
                  scale = 0;
                } else if (scale > 1) {
                  scale = 1;
                }
              }
              return Opacity(
                opacity: scale,
                child: Transform(
                  transform: Matrix4.identity()..scale(scale,scale),
                  alignment: Alignment.bottomCenter,
                  child: Align(
                    heightFactor: 0.9,
                    alignment: Alignment.topCenter,
                    child: listaCitas[index],
                  ),
                ),
              );
            },
          )
      ),
    );
  }
}

Container noCitas(){
  return Container(
    margin: EdgeInsets.only(top:50,left: 20,right: 20),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20.0)),color: Colors.white, boxShadow: [
      BoxShadow(color: Colors.black.withAlpha(100),blurRadius: 10.0),
    ]),
    child: Center(child: Text("No Tienes Citas Pendientes",style: TextStyle(
        color: Colors.green[500],
        fontWeight: FontWeight.bold,
        fontSize: 20
    ),)),
  );
}