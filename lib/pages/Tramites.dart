import 'dart:convert';
import 'package:app_egresados/errorPages/ErrorPage.dart';
import 'package:app_egresados/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;

import 'Registro.dart';

class Tramite extends StatefulWidget {
  @override
  _TramiteView createState() => _TramiteView();
}

class _TramiteView extends State<Tramite>{

  void initState(){
    super.initState();
    getTramites();
  }

  List listTramites = [];
  bool isLoading = true;
  bool sinTramites = false;
  String mensaje = "";
  double topContainer = 0;

  getTramites() async {

    setState(() {isLoading = true;});
    List<dynamic> responseList = [];
    List<Widget> listItems = [];

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();

    try{
      var tramites = await http.get("http://192.168.1.68:8000/api/getTramites/"+id);
      if(tramites.statusCode == 200){
        setState(() {
          responseList = json.decode(tramites.body);
          isLoading = false;
        });

        responseList.forEach((tramite) {
          listItems.add(Container(
            height: 120,
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
                        tramite["name"],
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      RaisedButton(
                        child: Text("Solicitar"),
                        onPressed: (){
                            setState(() {isLoading = true;});
                            setTramite(tramite["name"]);
                        }
                      ),
                      SizedBox(height: 10)
                    ],
                  )
                ],
              ),
            ),
          ));
        });
        setState(() {listTramites = listItems;});
      }
      else if(tramites.statusCode == 401){
        setState(() {
          isLoading = false;
          sinTramites = true;
        });
      }
    }
    catch (e){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PageError()), (Route <dynamic> route) => false);
    }
  }

  void setTramite(String nameTramite) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    Map data = {'tipo':nameTramite, 'id':id};

    var tramite = await http.post("http://192.168.1.68:8000/api/postTramite",body: data);
    if(tramite.statusCode == 200){
      setState(() {
        isLoading = false;
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute (builder: (BuildContext context) => MyHomePage()), (Route<dynamic>route) => false);
      });
    }
    else if (tramite.statusCode == 401){
      setState(() {
        isLoading = false;
        mensaje = "Trámite en Proceso";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('Trámites'),),
      drawer: MyDrawer(),
      body: Container(
        child: listTramites.length == 0 ? Center(child: isLoading ? Center(child: CircularProgressIndicator()):
        ListView(
          children: [
            header(),
            if(sinTramites)
              noTramites("Debes llenar el registro \nde la Sección Formulario")
            else
              noTramites("No tienes trámites pendientes")
          ],
        )) : ListView.builder(
          padding: const EdgeInsets.all(6),
          itemCount: listTramites.length,
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
                  child: listTramites[index],
                ),
              ),
            );
          }
        )
      ),
    );
  }
}

Container noTramites(String registrado){
  return Container(
    margin: EdgeInsets.only(top: 40),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    child: Center(child: Text(registrado,style: TextStyle(
      color: Colors.green[500],
      fontWeight: FontWeight.bold,
      fontSize: 20
    ),)),
  );
}