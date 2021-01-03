import 'dart:convert';
import 'package:app_egresados/errorPages/ErrorPage.dart';
import 'package:app_egresados/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Formulario.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;

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

  getTramites() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();

    setState(() {isLoading = true;});

    try{
      var tramites = await http.get("http://192.168.1.68:8000/api/getTramites/"+id);
      if(tramites.statusCode == 200){
        setState(() {
          listTramites = json.decode(tramites.body);
          isLoading = false;
        });
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
        )) : ListView.separated(
          padding: const EdgeInsets.all(8),
          itemCount: listTramites.length,
          itemBuilder: (BuildContext context,int index){
            return Container(
              height: 100,
              child: Center(child: Column(
                children: [
                  Text("${listTramites[index]["name"]}",style: TextStyle(
                    fontSize: 18,
                  )),
                  RaisedButton(
                    color: Colors.blue,
                    onPressed: (){
                      setState(() {isLoading = true;});
                      setTramite(listTramites[index]["name"]);
                    },
                    child: Text("Solicitar")
                  ),
                  Text(mensaje)
                ],
              )),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(),
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