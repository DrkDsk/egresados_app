import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'login.dart';


class Register extends StatefulWidget{
  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<Register>{

  final formKey = GlobalKey<FormState>();

  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword1 = new TextEditingController();
  TextEditingController controllerPassword2 = new TextEditingController();

  String mensaje = "";
  bool _obscureText = true;
  bool isLoading = false;

  void hideShow(){setState(() {_obscureText = !_obscureText;});}

  register(String email, String password, String password2) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    Map data = {
      'email' : email,
      'password': password
    };
    if(password == password2){
      try{
        var response = await http.post("http:192.168.1.68:8000/api/register",body: data);
        if(response.statusCode == 200){
          var jsonResponse = json.decode(response.body);
          if(jsonResponse != null){
            setState(() { isLoading = false; });
            sharedPreferences.setString('token', jsonResponse['token']);
            sharedPreferences.setString('email', jsonResponse['email']);
            sharedPreferences.setInt('id', jsonResponse['id']);
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (Route <dynamic> route) => false);
          }
        }
        else if(response.statusCode == 401){
          setState(() {
            isLoading = false;
            mensaje = "Usuario Registrado";
          });
        }
      }
      catch (e){

      }
    }
    else{setState(() {
        isLoading = false;
        mensaje = "Contraseñas no coinciden";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(title: Text('Registro')),
      body: Container(
        child: isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: [
            header(),
            textRegistro(),
            formSection(),
            mensajeSection(),
            buttonsection(),
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

  Container textRegistro(){
    return Container(
      margin: EdgeInsets.only(top: 30),
      height: 40,
      child: Center(
        child: Text('Registro de Usuarios',style: TextStyle(
          fontFamily: 'Courier',
          fontSize: 30
        )),
      )
    );
  }

  Form formSection(){
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0,vertical:15.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
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
                          offset: Offset(0,10.0)
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
                              if(value.isEmpty) return "Email Requerido";
                              return null;
                            },
                            controller: controllerEmail,
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
                                    if(value.isEmpty) return "Contraseña requerida";
                                    return null;
                                  },
                                  controller: controllerPassword1,
                                  decoration: InputDecoration(
                                    suffixIcon: IconButton(
                                      onPressed: hideShow,
                                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'Contraseña',
                                    hintStyle: TextStyle(color: Colors.blue[700])
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  obscureText: _obscureText,
                                  validator: (value){
                                    if(value.isEmpty) return "Contraseña requerida";
                                    return null;
                                  },
                                  controller: controllerPassword2,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Repetir Contraseña',
                                      hintStyle: TextStyle(color: Colors.blue[700])
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
              ,
            )
          ],
        ),
      ),
    );
  }

  Container buttonsection(){
    return Container(
      child: Column(
        children: [
          RaisedButton(
            child: Text('Registrar',style: TextStyle(
              color: Colors.blue,
              fontSize: 20
            ),),
          onPressed: (){
              if(formKey.currentState.validate()){
                setState(() {
                  isLoading = true;
                });
                register(controllerEmail.text, controllerPassword1.text, controllerPassword2.text);
              }
          },
          ),
          RaisedButton(
            child: Text('Iniciar Sesión',style: TextStyle(
              color: Colors.blue,
              fontSize: 20
            )),
            onPressed: (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false);
            },
          )
        ],
      ),
    );
  }

  Container mensajeSection(){
    return Container(
      child: Center(
        child: Text(mensaje,style: TextStyle(
          color: Colors.red,
          fontSize: 15
        ),),
      ),
    );
  }
}