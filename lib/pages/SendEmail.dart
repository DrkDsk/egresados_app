import 'dart:convert';
import 'package:app_egresados/pages/Registro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'login.dart';

class SendEmail extends StatefulWidget{
  @override
  _SendEmail createState() => _SendEmail();
}

class _SendEmail extends State<SendEmail>{

  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerEmail = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        leading: BackButton(color: Colors.white,
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginPage()), (Route<dynamic> route) => false)),
        title: Text('Recuperar Cuenta'),
      ),
      body: Container(
        child: isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: [
            header(),
            textSendEmail(),
            textForm(),
            form(),
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

  Container textSendEmail(){
    return Container(
        margin: EdgeInsets.only(top: 30),
        height: 40,
        child: Center(
          child: Text('Recuperar Contraseña',
            style: TextStyle(
                color: Colors.black,
                fontSize: 30,
                fontFamily: 'Courier'
            ),),
        )
    );
  }

  Container textForm(){
    return Container(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Text(
            'Ingresa el Correo Electrónico asociado a tu Cuenta'
          ),
        ),
      ),
    );
  }

  Form form(){
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0,vertical: 0.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8),
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
                              if(value.isEmpty) return "Correo Electrónico requerido";
                              return null;
                            },
                            controller: controllerEmail,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Correo Electrónico',
                                hintStyle: TextStyle(color: Colors.blue[700])
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 80,),
                  Container(
                    child: RaisedButton(
                      child: Text('Enviar Correo Electrónico',style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                      ),),
                      onPressed: (){
                        if(formKey.currentState.validate()){
                          setState(() { isLoading = true; });
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  
}