import 'package:app_egresados/pages/Citas.dart';
import 'package:app_egresados/pages/MyDrawer.dart';
import 'package:app_egresados/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'pages/Formulario.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Egresados'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  checkLogin() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('token') == null)
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
              (Route<dynamic> route) => false);
  }

  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      appBar: AppBar(
        title: Text('Registro de Titulación de Egresados',
            style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 25),
        child: ListView(
          children: [
            header(),
            Padding(padding: EdgeInsets.only(bottom: 40)),
            Text('Bienvenido a la Aplicación de \nRegistro de Titulación de Egresados',style:
              TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 22)),
            Padding(padding: EdgeInsets.only(bottom: 60)),
            MaterialButton(onPressed: (){_drawerKey.currentState.openDrawer();},
              child: Text('1) Registrate en la Sección Formulario para Actualizar tu información',style: TextStyle(
                color: Colors.teal[300],fontWeight: FontWeight.bold, fontSize: 20))),
            Divider(height: 60),
            MaterialButton(onPressed: (){_drawerKey.currentState.openDrawer();},
                child: Text('2) Dirígite a la Sección Trámites para conocer tus Trámites Disponibles',style: TextStyle(
                    color: Colors.teal[300],fontWeight: FontWeight.bold, fontSize: 20))),
            Divider(height: 60,),
            MaterialButton(onPressed: (){_drawerKey.currentState.openDrawer();},
                child: Text('3) Dirígite a la Sección Citas para conocer las Citas que tienes de Cada Trámite Solicitado',style: TextStyle(
                    color: Colors.teal[300],fontWeight: FontWeight.bold, fontSize: 20))),
          ],
        ),
      )
      ,
      drawer: MyDrawer(),
    );
  }
}
