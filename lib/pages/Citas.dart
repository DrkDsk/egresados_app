import 'package:app_egresados/modelos/RequestResponseCitas_model.dart';
import 'package:app_egresados/widgets/Header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;

class Citas extends StatefulWidget{
  @override
  _CitasView createState() => _CitasView();
}

class _CitasView extends State<Citas>{

  Future<ReqResRespuesta> getCitas() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    String token = sharedPreferences.getString("token");

    final citas = await http.get("http://ittgegresados.online/api/getCitas/"+id,
        headers: {'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'}
    );
    return reqResRespuestaFromJson(citas.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('Calendario de Citas')),
      drawer: MyDrawer(),
      body:
          FutureBuilder(
              future: getCitas(),
              builder: (BuildContext context, AsyncSnapshot<ReqResRespuesta> snapshot){
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
                                      Text("No Tienes Citas Asignadas, No Hay Trámites Solicitados",style: TextStyle(fontSize: 22, color: Colors.red.shade300, fontWeight: FontWeight.bold)),
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
                else{
                  return _ListaCitas(snapshot.data.data);
                }
              }
          ),
    );
  }
}

class _ListaCitas extends StatelessWidget{
  final List<Cita> citas;
  _ListaCitas(this.citas);

  @override
  Widget build(BuildContext context) {
    if(this.citas.isNotEmpty){
      return Column(
        children: [
          Expanded(child: ListView.builder(
              padding: EdgeInsets.all(20.0),
              itemCount: citas.length,
              itemBuilder: (BuildContext context, int index){
                final cita = citas[index];
                return Container(
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
                            Text("Cita:",style: TextStyle(fontSize: 24, color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                            Text(cita.descripcion, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            SizedBox(height: 10.0,),
                            Text("Fecha:",style: TextStyle(fontSize: 24, color: Colors.blue.shade800, fontWeight: FontWeight.bold),),
                            Text(cita.fecha.year.toString() + '-' + cita.fecha.month.toString() + '-' + cita.fecha.day.toString(),
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 10.0,),
                            Text("Hora:",style: TextStyle(fontSize: 24, color: Colors.blue.shade800, fontWeight: FontWeight.bold)),
                            Text(cita.hora, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
          ),
          )
        ],
      );
    }
    else{
      return Column(
            children: [
              Header(),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 40.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.white, boxShadow: [
                        BoxShadow(color: Colors.black.withAlpha(100),blurRadius: 10.0)
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      direction: Axis.horizontal,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("No Tienes Citas Asignadas",style: TextStyle(fontSize: 24, color: Colors.green.shade500, fontWeight: FontWeight.bold)),
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