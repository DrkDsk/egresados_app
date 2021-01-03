import 'dart:convert';
import 'package:app_egresados/errorPages/ErrorPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Formulario.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;

class Citas extends StatefulWidget{
  @override
  _CitasView createState() => _CitasView();
}

class _CitasView extends State<Citas>{

  void initState(){
    super.initState();
    getCitas();
  }

  bool isLoading = false;
  bool estadoCitas = false;
  List listaCitas = [];

  getCitas() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();

    setState(() {isLoading = true;});

    try{
      var citas = await http.get("http://ittgegresados.online/api/getCitas/"+id);
      if (citas.statusCode == 200){
        setState(() {
          isLoading = false;
          listaCitas = json.decode(citas.body);
        });
      }
      else if(citas.statusCode == 401){
        setState(() {
          isLoading = false;
          estadoCitas = true;
        });
      }
    }
    catch (e){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PageError()), (Route <dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('Calendario de Citas')),
      drawer: MyDrawer(),
      body: Container(
          child: listaCitas.length == 0 ? Center(child: isLoading ? Center(child: CircularProgressIndicator()):
          ListView(
            children: [
              header(),
              if (estadoCitas)
                noCitas("Debes llenar el registro \nde la Sección Formulario")
              else
                noCitas("No Tienes Citas Pendientes")
            ],
          )) : ListView.separated(
            padding: const EdgeInsets.all(8),
            itemCount: listaCitas.length,
            itemBuilder: (BuildContext context,int index){
              return Container(
                height: 80,
                child: Center(child: Column(
                  children: [
                    Text("Cita: ${listaCitas[index]["descripcion"]}",style: TextStyle(fontSize: 18)),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                    Text("Fecha: ${listaCitas[index]["fecha"]}",style: TextStyle(fontSize: 14)),
                    Padding(padding: EdgeInsets.symmetric(vertical: 4)),
                    Text("Trámite: ${listaCitas[index]["tipo"]}",style: TextStyle(fontSize: 14)),
                  ],
                )),
              );
            },
            separatorBuilder: (BuildContext context, int index) => const Divider(
              color: Colors.blueAccent,
              indent: 20.0,
              endIndent: 20.0,
              thickness: 1,
            ),
          )
      ),
    );
  }
}



Container noCitas(String estadoCitas){
  return Container(
    margin: EdgeInsets.only(top: 40),
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
    child: Center(child: Text(estadoCitas,style: TextStyle(
        color: Colors.green[500],
        fontWeight: FontWeight.bold,
        fontSize: 20
    ),)),
  );
}