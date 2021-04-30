import 'package:app_egresados/errorPages/ErrorPage.dart';
import 'package:app_egresados/widgets/Header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class ResetPassword extends StatefulWidget{
  @override
  _ResetPasswordPage createState() => _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPassword>{

  final formKey = GlobalKey<FormState>();

  TextEditingController controllertoken = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerPassword1 = new TextEditingController();
  TextEditingController controllerPassword2 = new TextEditingController();

  String mensaje = "";
  bool _obscureText = true;
  bool isLoading = false;

  void hideShow(){setState(() {_obscureText = !_obscureText;});}

  resetPassword(String token,String email, String password, String password2) async {

    Map data = {
      'email' : email,
      'password' : password,
      'token' : token
    };
    if(password == password2){
      try{
        var response = await http.post(Uri.parse("http://192.168.1.74:8000/api/update/password"),body: data);
        if(response.statusCode == 200){
          var jsonResponse = json.decode(response.body);
          if(jsonResponse != null){
            SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.clear();
            setState(() { isLoading = false; });
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => MyHomePage()), (Route <dynamic> route) => false);
          }
        }
        else if(response.statusCode == 401){
          setState(() {
            isLoading = false;
            mensaje = "Token O Correo Electrónico Inválido";
          });
          return;
        }
      }
      catch(e){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PageError()), (Route <dynamic> route) => false);
      }
    }
    else{
      setState(() {
        isLoading = false;
        mensaje = "Contraseñas no coinciden";
      });
      return ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: new AppBar(title: Text('Reiniciar Contraseña')),
      body: Container(
        child: isLoading ? Center(child: CircularProgressIndicator()) :
        Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(child: ListView(
              children: [
                Header(),
                textForm(),
                formSection(),
                mensajeSection(),
                buttonsection(),
                SizedBox(height: 50,)
              ],
            ))
          ],
        ),
      ),
    );
  }

  Form formSection(){
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0,vertical:15.0),
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
                              if(value.isEmpty) return "Token Requerido";
                              return null;
                            },
                            controller: controllertoken,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Token',
                                hintStyle: TextStyle(color: Colors.blue[700])
                            ),
                          ),
                        ),
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
                          decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.grey[100]))
                          ),
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

  Container textForm(){
    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
              'Ingresa el Token que ha llegado a tu correo electrónico'
          ),
        ),
      ),
    );
  }

  Container mensajeSection(){
    return Container(
      padding: EdgeInsets.only(left: 40,right: 40),
      child: Wrap(
        direction: Axis.horizontal,
        children: [
          Text(mensaje,style: TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.red,
            fontSize: 16,
          ),
          ),
        ],
      ),
    );
  }

  Container buttonsection(){
    return Container(
      child: Column(
        children: [
          RaisedButton(
            color: Colors.lightBlue.shade600,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.lightBlue.shade600)
            ),
            child: Text('Actualizar Contraseña',style: TextStyle(
                color: Colors.white,
                fontSize: 20
            ),),
            onPressed: (){
              if(formKey.currentState.validate()){
                setState(() {isLoading = true;});
                resetPassword(controllertoken.text, controllerEmail.text, controllerPassword1.text, controllerPassword2.text);
              }
            },
          ),
        ],
      ),
    );
  }
}