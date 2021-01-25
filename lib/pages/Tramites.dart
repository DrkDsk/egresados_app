import 'dart:convert';
import 'package:app_egresados/modelos/RequestResponseTramites_model.dart';
import 'package:app_egresados/widgets/Header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;


class Tramites extends StatefulWidget {
  @override
  _TramiteView createState() => _TramiteView();
}

class _TramiteView extends State<Tramites>{

  Future<ReqResRespuestaTramite> getTramites() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    String token = sharedPreferences.getString("token");
    var tramites = await http.get("http://ittgegresados.online/api/getTramites/"+id,
        headers: {'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer $token'});
    return reqResRespuestaTramiteFromJson(tramites.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('Trámites Disponibles'),),
      drawer: MyDrawer(),
      body:   FutureBuilder(
        future: getTramites(),
        builder: (BuildContext context, AsyncSnapshot<ReqResRespuestaTramite> snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }
          if(snapshot.data == null){
            return Column(
                children: [
                  Header(),
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Color.fromRGBO(224, 233, 252,.97), boxShadow: [
                            BoxShadow(color: Colors.black.withAlpha(100),blurRadius: 10.0)
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                        child: Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          direction: Axis.horizontal,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Registra Tu Formulario Para Acceder a Los Trámites",style: TextStyle(fontSize: 22, color: Colors.red.shade300, fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50,)
                ]
            );

          }
          else{
            return _ListaTramites(snapshot.data.data);
          }
        },
      ),
    );
  }
}

class _ListaTramites extends StatelessWidget{
  final List<Tramite> tramites;
  _ListaTramites(this.tramites);

  @override
  Widget build(BuildContext context) {
    if(this.tramites.isNotEmpty){
      return Column(
        children: [
          Expanded(child: ListView.builder(
              padding: EdgeInsets.all(20.0),
              itemCount: tramites.length,
              itemBuilder: (BuildContext context, int index){
                final tramite = tramites[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 1),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white, boxShadow: [
                      BoxShadow( color: Colors.black.withAlpha(100), blurRadius: 10.0)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      direction: Axis.horizontal,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Trámite:",style: TextStyle(fontSize: 24, color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                            Text(tramite.name,style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            RaisedButton(
                              color: Colors.lightBlue.shade600,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.lightBlue.shade600)
                              ),
                              child: Text("Solicitar",style: TextStyle(color: Colors.white),),
                              onPressed: (){
                                showAlertDialog(context, tramite.name);
                            },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
              ),
          ),
        ],
      );
    }
    else{
      return Column(
          children: [
            Header(),
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Colors.white, boxShadow: [
                      BoxShadow(color: Colors.black.withAlpha(100),blurRadius: 10.0)
                    ]),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    direction: Axis.horizontal,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("No Tienes Trámites Disponibles",style: TextStyle(fontSize: 22, color: Colors.red.shade300, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]
      );
    }
  }
}

showAlertDialogError(BuildContext context, String mensaje, String tramite){

  Widget closeButton = FlatButton(
    child: Text("Cerrar",style: TextStyle(
        fontSize: 20,
        color: Colors.red),),
    onPressed:  () {
      Navigator.pop(context);
      Navigator.pop(context);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Trámite Solicitado"),
    content: Container(
      child: Wrap(
        children: [
          Text("El Trámite: ",style: TextStyle(
            fontSize: 20,
          ),
          ),
          SizedBox(height: 10,),
          Text(tramite,style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold
          ),),
          Text("Ya ha sido Solicitado",style: TextStyle(
            fontSize: 20
          ),)
        ],
      ),
    ),
    actions: [
      closeButton,
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      }
  );
}

showAlertDialog(BuildContext context,String tramite){

  void setTramite(String nameTramite) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    String token = sharedPreferences.getString("token");
    Map data = {'tipo':nameTramite, 'id':id};

    var tramite = await http.post("http://ittgegresados.online/api/postTramite",body: jsonEncode(data),
        headers: {'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'});

    if(tramite.statusCode == 200){
      var mensaje = "Se Ha Solicitado Corretamente el Trámite: ";
      showToast(context,mensaje,nameTramite);
      Navigator.pop(context);
    }
    else{
      var mensaje = "El Trámite: ya ha sido Solicitado";
      showAlertDialogError(context, mensaje, nameTramite);
    }
  }

  Widget cancelButton = FlatButton(
    child: Text("Cancelar",style: TextStyle(
        fontSize: 20,
        color: Colors.red),),
    onPressed:  () {
      Navigator.pop(context);
    },
  );

  Widget confirmButton = FlatButton(
    child: Text("Confirmar",style: TextStyle(
      color: Colors.green,
      fontSize: 20
    ),),
    onPressed:  () {
      setTramite(tramite);
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Solicitando Trámite"),
    content: Container(
      child: Wrap(
        children: [
          Text("Confirmar la Solicitud del Trámite:",style: TextStyle(
            fontSize: 20,
          )),
          SizedBox(height: 20),
          Text(tramite,style: TextStyle(
            fontSize: 20,
           fontWeight: FontWeight.bold
          ))
        ],
      ),
    ),
    actions: [
      cancelButton,
      confirmButton
    ],
  );

  showDialog(
      context: context,
      builder: (BuildContext context){
        return alert;
      }
  );
}

showToast(BuildContext context,String mensaje,String tramite){
  Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        mensaje + tramite
      ))
  );
}