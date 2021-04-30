import 'dart:convert';
import 'package:app_egresados/errorPages/ErrorPage.dart';
import 'package:app_egresados/main.dart';
import 'package:app_egresados/widgets/Header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditFormulario.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;

class ViewFormulario extends StatefulWidget{
  @override
  _FormularioView createState() => _FormularioView();
}

class _FormularioView extends State<ViewFormulario>{

  final formKey = GlobalKey<FormState>();

  DateTime _dateTimeInicio;
  DateTime _dateTimeEgreso;

  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerApellidoPaterno = new TextEditingController();
  TextEditingController controllerApellidoMaterno = new TextEditingController();
  TextEditingController controllerNumeroDeControl = new TextEditingController();
  TextEditingController controllerMovil = new TextEditingController();
  TextEditingController controllerTelefonoCasa = new TextEditingController();
  TextEditingController controllerEmailAlternativo = new TextEditingController();
  TextEditingController controllerCarrera = new TextEditingController();

  bool visibleMailAlternativo = true;
  bool visibleTelefonoCasa = true;
  bool isLoading= false;

  String _carreras_valor = "";
  String mensaje = "";

  List _carreras = [
    "Ing. En Sistemas Computacionales",
    "Ing. Mecánica",
    "Ing. Química",
    "Ing. Bioquímica",
    "Ing. Electrica",
    "Ing. Electrónica",
    "Ing. En Gestión Empresarial",
    "Ing. Industrial",
    "Ing. Logística",
  ];

  void hideMailAlternativo(){
    setState(() { visibleMailAlternativo = !visibleMailAlternativo; });
  }
  void hideTelefonoCasa(){
    setState(() {visibleTelefonoCasa = !visibleTelefonoCasa;});
  }

  void initState(){
    super.initState();
    checkEstadoRegistro();
  }

  checkEstadoRegistro() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    String token = sharedPreferences.get("token");

    setState(() {isLoading = true;});
    try{
      var response = await http.get(Uri.parse("http://192.168.1.74:8000/api/estadoFormulario/"+id),
          headers: {'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'});

      if(response.statusCode == 200){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute (builder: (BuildContext context) => EditFormulario()), (Route<dynamic>route) => false);
      }
      else if (response.statusCode == 401){
        setState(() {
          isLoading = false;
        });
        return ;
      }
    }
    catch (e){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PageError()), (Route <dynamic> route) => false);
    }
  }

  formulario() async{

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();
    String token = sharedPreferences.getString("token");

    String email = controllerEmailAlternativo.text;
    String telefono_casa = controllerTelefonoCasa.text;

    if (visibleMailAlternativo == false) email = "";
    if (visibleTelefonoCasa == false) telefono_casa = "";

    if(_carreras_valor.isEmpty){
      setState(() {mensaje = "Seleccione Su Carrera";});
      return ;
    }

    if(_dateTimeEgreso == null || _dateTimeInicio == null){
      setState(() {mensaje = "Selecciona Tu Fecha de Ingreso Y Egreso";});
      return ;
    }

    setState(() {isLoading = true;});

    Map data = {
      'id' : id,
      'name'  : controllerName.text,
      'apellido1' : controllerApellidoPaterno.text,
      'apellido2' : controllerApellidoMaterno.text,
      'noControl' : controllerNumeroDeControl.text,
      'movil' : controllerMovil.text,
      'fechaInicio' : _dateTimeInicio.toString(),
      'fechaEgreso' : _dateTimeEgreso.toString(),
      'telefono_casa' : telefono_casa,
      'email_alternativo' : email,
      'carrera' : _carreras_valor
    };

    try{
      final response = await http.post(Uri.parse("http://192.168.1.74:8000/api/formulario"),body: jsonEncode(data),
          headers: {'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token'}
      );
      if(response.statusCode == 200){
        setState(() { isLoading = false; });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute (builder: (BuildContext context) => MyHomePage()), (Route<dynamic>route) => false);
      }
      else if(response.statusCode == 401){
        setState(() {
          isLoading = false;
          mensaje = "El formulario ya ha sido registrado";
          return ;
        });
      }
      else if(response.statusCode == 400){
        setState(() {
          isLoading = false;
          mensaje = json.decode(response.body)[0];
          return ;
        });
      }
    }
    catch (e){
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PageError()), (Route <dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(title: Text('Formulario')),
      drawer: MyDrawer(),
      body: Container(
        child: isLoading ? Center(child: CircularProgressIndicator()) :
        Flex(
            direction: Axis.horizontal,
          children: [
            Expanded(
                child: ListView(
                  children: [
                    Header(),
                    formuRegistro(),
                    formSection(),
                    selectCarrera(),
                    selectFechaIngreso(),
                    selectFechaEgreso(),
                    buttonsection(),
                    mensajeSection(),
                    SizedBox(height: 40,)
                  ],
                )
            )
          ],
        )
        ,
      ),
    );
  }

  Container formuRegistro(){
    return Container(
        margin: EdgeInsets.only(top: 30),
        height: 40,
        child: Column(
          children: [
            Expanded(child: Text(
                'Registro de formulario',style: TextStyle(
                fontSize: 28
            )
            ))
          ],
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
                              if(value.isEmpty) return "Nombre Requerido";
                              return null;
                            },
                            controller: controllerName,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Nombre',
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
                                  validator: (value){
                                    if(value.isEmpty) return "Apellido Paterno requerido";
                                    return null;
                                  },
                                  controller: controllerApellidoPaterno,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Apellido Paterno',
                                      hintStyle: TextStyle(color: Colors.blue[700])
                                  ),
                                ),
                              )
                            ],
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
                                  validator: (value){
                                    if(value.isEmpty) return "Apellido Materno requerido";
                                    return null;
                                  },
                                  controller: controllerApellidoMaterno,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Apellido Materno',
                                      hintStyle: TextStyle(color: Colors.blue[700])
                                  ),
                                ),
                              )
                            ],
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
                                  maxLength: 8,
                                  validator: (value){
                                    if(value.isEmpty || value.length != 8) return "Número de Control requerido a 8 Dígitos";
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  controller: controllerNumeroDeControl,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Número de Control',
                                      hintStyle: TextStyle(color: Colors.blue[700])
                                  ),
                                ),
                              )
                            ],
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
                                  maxLength: 10,
                                  keyboardType: TextInputType.phone,
                                  validator: (value){
                                    if(value.isEmpty || value.length != 10) return "Teléfono móvil requerido a 10 Dígitos";
                                    return null;
                                  },
                                  controller: controllerMovil,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Teléfono móvil',
                                      hintStyle: TextStyle(color: Colors.blue[700])
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            Container(
                              child: Visibility(
                                visible: visibleTelefonoCasa,
                                child: Container(
                                  child: TextFormField(
                                    maxLength: 10,
                                    keyboardType: TextInputType.phone,
                                    validator: (value){
                                      if(value.isEmpty || value.length != 10) return "Teléfono de Casa requerido a 10 Dígitos";
                                      return null;
                                    },
                                    controller: controllerTelefonoCasa,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Teléfono de Casa',
                                        hintStyle: TextStyle(color: Colors.blue[700])
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Checkbox(
                              value: visibleTelefonoCasa,
                              onChanged: (v){
                                hideTelefonoCasa();
                              },
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey[100]))
                              ),
                              padding: EdgeInsets.all(15),
                              child: InkWell(
                                child: Text("(Teléfono de Casa)",
                                  style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontWeight: FontWeight.bold
                                  ),),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          children: [
                            Container(
                              child: Visibility(
                                visible: visibleMailAlternativo,
                                child: Container(
                                  child: TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value){
                                      if(value.isEmpty) return "Correo Electrónico Alternativo Requerido";
                                      return null;
                                    },
                                    controller: controllerEmailAlternativo,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Email Alternativo',
                                        hintStyle: TextStyle(color: Colors.blue[700])
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Checkbox(
                              value: visibleMailAlternativo,
                              onChanged: (v){
                                hideMailAlternativo();
                              },
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              child: InkWell(
                                child: Text("(Email Alternativo)",
                                  style: TextStyle(
                                      color: Colors.lightBlueAccent,
                                      fontWeight: FontWeight.bold
                                  ),),
                              ),
                            ),
                          ],
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

  Container selectCarrera(){
    return Container(
      child: Center(child: DropdownButton(
        hint: Center(child: _carreras_valor.isEmpty ? Text("Seleccione una Carrera"): Text(_carreras_valor)),
        dropdownColor: Colors.white,
        onChanged: (value){
          setState(() {
            _carreras_valor = value;
          });
        },
        items: _carreras.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(value),);
        }).toList(),
      )),
    );
  }

  Container selectFechaIngreso(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 120),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.lightBlue.shade600)
        ),
        color: Colors.blue,
        onPressed: (){
          showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2001),
              lastDate: DateTime(2050))
              .then((date){
            setState(() {
              _dateTimeInicio = date;
            });
          });
        },
        child: _dateTimeInicio == null ? Text("Fecha de Inicio",style: TextStyle(color: Colors.white),) : Text("Año de Ingreso: " + _dateTimeInicio.year.toString(),style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Container selectFechaEgreso(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 120),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.lightBlue.shade600)
        ),
        color: Colors.blue,
        onPressed: (){
          showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2001),
              lastDate: DateTime(2050))
              .then((date){
            setState(() {
              _dateTimeEgreso = date;
            });
          });
        },
        child: _dateTimeEgreso == null ? Text("Fecha de Egreso",style: TextStyle(color: Colors.white),) : Text("Año de Egreso: " + _dateTimeEgreso.year.toString(),style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Container buttonsection(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.green.shade400)
            ),
            padding: EdgeInsets.symmetric(horizontal: 50),
            color: Colors.green.shade400,
            child: Text('Registrar',style: TextStyle(
              color: Colors.white,
              fontSize: 20
            )),
          onPressed: (){
              if(formKey.currentState.validate()){
                formulario();
              }
          },
          )
        ],
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
}