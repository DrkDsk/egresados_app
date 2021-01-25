import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Header.dart';

class Welcome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Header(),
            Padding(padding: EdgeInsets.symmetric(vertical: 10)),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.blue.shade400, boxShadow: [
                          BoxShadow( color: Colors.black.withAlpha(100), blurRadius: 10.0)
                        ]),
                    padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('Bienvenido a la Aplicación de Registro de Titulación de Egresados',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),),
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.lightBlue.shade400, boxShadow: [
                            BoxShadow( color: Colors.black.withAlpha(100), blurRadius: 10.0)
                          ]),
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('1) Registrate en la Sección Formulario para Actualizar tu Información.',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),),
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.lightGreen.shade600, boxShadow: [
                            BoxShadow( color: Colors.black.withAlpha(100), blurRadius: 10.0)
                          ]),
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('2) Dirígite a la Sección Trámites para conocer tus Trámites Disponibles.',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),),
                      )
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Colors.red.shade500, boxShadow: [
                            BoxShadow( color: Colors.black.withAlpha(100), blurRadius: 10.0)
                          ]),
                      padding: EdgeInsets.all(20),
                      child: Center(
                        child: Text('3) Dirígite a la Sección Citas para conocer las Citas Asignadas de Cada Trámite Solicitado.',style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                        ),),
                      )
                  ),
                  SizedBox(height:50)
                ],
              ),
            )
            ,
          ],
        ),
      ),
    );
  }
}