import 'dart:convert';
import 'package:app_egresados/pages/Registro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'SendEmail.dart';

class LoginPage extends StatefulWidget{
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final formKey = GlobalKey<FormState>();

  TextEditingController controllerUser = new TextEditingController();
  TextEditingController controllerPassword = new TextEditingController();
  String mensaje = "";
  bool _obscureText = true;
  bool isLoading = false;

  void hideShow(){ setState(() {_obscureText = !_obscureText; }); }

  Login(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email' : email,
      'password' : password
    };

    var response = await http.post("http://192.168.1.67:8000/api/login",body: data);
    if(response.statusCode == 200){
      var jsonResponse = json.decode(response.body);
      if(jsonResponse != null){
        setState(() { isLoading = false; });
        sharedPreferences.setString('token', jsonResponse['token']);
        sharedPreferences.setString('email', jsonResponse['email']);
        sharedPreferences.setInt('id', jsonResponse['id']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (Route<dynamic> route) => false);
      }
    }
    else if(response.statusCode == 401){
      setState(() {
        isLoading = false;
        mensaje = "Correo Electrónico o Contraseña incorrecta";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: <Widget>[
            header(),
            textInicioSesion(),
            form(),
            message(),
            forgotPassword()
          ],
        ),
      ),
    );
  }

  Container header(){
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

  Container textInicioSesion(){
    return Container(
      margin: EdgeInsets.only(top: 30),
      height: 40,
      child: Center(
        child: Text('Inicio de Sesión',
          style: TextStyle(
              color: Colors.black,
              fontSize: 35,
              fontFamily: 'Courier'
          ),),
      )
    );
  }

  Form form(){
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 20.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 10.0,
                            offset: Offset(0,10)
                        )
                      ]
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
                          child: TextFormField(
                            validator: (value){
                              if(value.isEmpty) return "Nombre de Usuario requerido";
                              return null;
                            },
                            controller: controllerUser,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Correo Electrónico',
                              hintStyle: TextStyle(color: Colors.blue[700])
                            ),
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  obscureText: _obscureText,
                                  validator: (value){
                                    if(value.isEmpty) return "Ingrese su contraseña";
                                    return null;
                                  },
                                  controller: controllerPassword,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: hideShow,
                                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off)
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Contraseña',
                                    hintStyle: TextStyle(color: Colors.blue[700])
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 80,),
                  Container(
                    child: RaisedButton(
                      child: Text('Iniciar Sesión',style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),),
                      onPressed: (){
                        if(formKey.currentState.validate()){
                          setState(() {
                            isLoading = true;
                          });
                          Login(controllerUser.text, controllerPassword.text);
                        }
                      },
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text('Registrarse',style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20
                      ),),
                      onPressed: (){
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Register()), (Route<dynamic> route) => false);
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container message(){
    return Container(
      child: Center(child: Text(
        mensaje,
        style: TextStyle(
          color: Colors.red
        ),
      ),),
    );
  }

  Container forgotPassword(){
    return Container(
      child: Center(
        child: InkWell(
          onTap: (){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => SendEmail()), (Route<dynamic> route) => false);
          },
          child: Text("Olvidaste Tu Contraseña?",
              style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontWeight: FontWeight.bold
              )),
        ),
      ),
    );
  }

}