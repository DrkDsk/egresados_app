import 'package:app_egresados/errorPages/ErrorPage.dart';
import 'package:app_egresados/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'EditFormulario.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;
import 'Registro.dart';

class Formulario extends StatefulWidget{
  @override
  _FormularioView createState() => _FormularioView();
}

class _FormularioView extends State<Formulario>{

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
  String email = "";
  String telefono_casa = "";

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
    setState(() {isLoading = true;});

    try{
      var response = await http.get('http://192.168.1.68:8000/api/estadoFormulario/'+id);
      if(response.statusCode == 200){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute (builder: (BuildContext context) => EditFormulario()), (Route<dynamic>route) => false);
      }
      else if (response.statusCode == 401) setState(() {isLoading = false;});
    }
    catch (e){
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => PageError()), (Route <dynamic> route) => false);
    }
  }

  formulario() async{

    print("carrera:" + _carreras_valor);
    print("dateInicio" + _dateTimeInicio.toString());
    print("dateEgre" + _dateTimeEgreso.toString());


    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();

    email = controllerEmailAlternativo.text;
    telefono_casa = controllerTelefonoCasa.text;

    if (visibleMailAlternativo == false) email = "";
    if (visibleTelefonoCasa == false) telefono_casa = "";

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
      final response = await http.post("http://192.168.1.68:8000/api/formulario",body: data);
      if(response.statusCode == 200){
        setState(() { isLoading = false; });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute (builder: (BuildContext context) => MyHomePage()), (Route<dynamic>route) => false);
      }
      else if(response.statusCode == 401){
        setState(() {
          isLoading = false;
          mensaje = "El formulario ya ha sido registrado";
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
        child: isLoading ? Center(child: CircularProgressIndicator()) : ListView(
          children: [
            header(),
            formuRegistro(),
            formSection(),
            selectCarrera(),
            selectFechaIngreso(),
            selectFechaEgreso(),
            buttonsection(),
            mensajeSection()
          ],
        ),
      ),
    );
  }

  Container formuRegistro(){
    return Container(
        margin: EdgeInsets.only(top: 30),
        height: 40,
        child: Center(
          child: Text('Registro de formulario',style: TextStyle(
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
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  validator: (value){
                                    if(value.isEmpty) return "Número de Control requerido";
                                    return null;
                                  },
                                  keyboardType: TextInputType.number,
                                  maxLength: 8,
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
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  maxLength: 10,
                                  keyboardType: TextInputType.number,
                                  validator: (value){
                                    if(value.isEmpty) return "Teléfono móvil requerido";
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
                        Row(
                         children: [
                           Container(
                             width: 150,
                             child: Visibility(
                               visible: visibleTelefonoCasa,
                               child: Container(
                                 child: TextFormField(
                                   maxLength: 10,
                                   keyboardType: TextInputType.number,
                                   validator: (value){
                                     if(value.isEmpty) return "Teléfono de Casa Requerido";
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
                           InkWell(
                             child: Text("(Teléfono de Casa)",
                               style: TextStyle(
                                   color: Colors.lightBlueAccent,
                                   fontWeight: FontWeight.bold
                               ),),
                           )
                         ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: 150,
                              child: Visibility(
                                visible: visibleMailAlternativo,
                                child: Container(
                                  child: TextFormField(
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
                            InkWell(
                              child: Text("(Email Alternativo)",
                                style: TextStyle(
                                    color: Colors.lightBlueAccent,
                                    fontWeight: FontWeight.bold
                                ),),
                            )
                          ],
                        ),
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

  Container selectFechaEgreso(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 120),
      child: RaisedButton(
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
        child: _dateTimeEgreso == null ? Text("Fecha de Egreso") : Text("Año de Egreso: " + _dateTimeEgreso.year.toString()),
      ),
    );
  }

  Container selectFechaIngreso(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 120),
      child: RaisedButton(
        color: Colors.blue,
        onPressed: (){
          showDatePicker(
              cancelText: "Cancelar",
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
        child: _dateTimeInicio == null ? Text("Fecha de Inicio") : Text("Año de Ingreso: " + _dateTimeInicio.year.toString()),
      ),
    );
  }

  Container buttonsection(){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          RaisedButton(
            child: Text('Registrar',style: TextStyle(
              color: Colors.blue,
              fontSize: 20
            )),
          onPressed: (){
              if(formKey.currentState.validate()){
                setState(() {
                  isLoading = true;
                });
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
      child: Center(
        child: Text(mensaje,style: TextStyle(
            color: Colors.red,
            fontSize: 15
        ),),
      ),
    );
  }
}