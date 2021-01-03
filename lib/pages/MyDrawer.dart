import 'package:app_egresados/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Citas.dart';
import 'package:http/http.dart' as http;
import 'Formulario.dart';
import 'Tramites.dart';

class MyDrawer extends StatefulWidget{
  @override
  _MyDrawer createState() => _MyDrawer();
}

class _MyDrawer extends State<MyDrawer> {

  String email = "";
  bool isLoading = false;

  @override
  void initState(){
    super.initState();
    getInfo();
  }

  void getInfo() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {email = sharedPreferences.get('email');});
  }

  void logOut() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.getString('token');

    Map data = {'token' : token};

    try{
      var response = await http.post("http://192.168.1.68:8000/api/logout",body: data);
      if (response.statusCode == 200){
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.clear();
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (route) => false);
        isLoading = false;
      }
    }
    catch (e){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.clear();
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (route) => false);
      isLoading = false;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            new UserAccountsDrawerHeader(
              accountName: null,
              accountEmail: new Text(email),
              currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.grey[400],
              ),
            ),
            ListTile(
              title: Text("Inicio", style: TextStyle(color: Colors.blue, fontSize: 18)),
              leading: new Icon(Icons.assignment_ind),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute (builder: (
                        BuildContext context) => MyHomePage()),
                        (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              title: Text("Formulario", style: TextStyle( color: Colors.blue, fontSize: 18)),
              leading: new Icon(Icons.assignment),
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (
                        BuildContext context) => Formulario()),
                        (Route<dynamic> route) => false);
              },
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (
                      BuildContext context) => Tramite()),
                        (Route<dynamic> route) => false);
              },
              leading: new Icon(Icons.attach_file),
              title: Text("Trámites",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18
                ),),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (
                        BuildContext context) => Citas()),
                        (Route<dynamic> route) => false);
              },
              leading: new Icon(Icons.calendar_today),
              title: Text("Calendario de Citas",
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 18
                ),),
            ),
            Container(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  child: Column(
                    children: [
                      Divider(
                        endIndent: 20,
                        indent: 20,
                        thickness: 2,
                        color: Colors.lightBlue,
                        height:60,
                      ),
                      ListTile(
                        leading: Icon(Icons.account_circle),
                        title: Text("Cerrar Sesión"),
                        onTap: (){
                          isLoading = true;
                          logOut();
                        },
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
    );
  }
}