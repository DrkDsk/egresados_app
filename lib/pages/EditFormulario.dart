import 'package:app_egresados/errorPages/ErrorPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'MyDrawer.dart';
import 'package:http/http.dart' as http;

class EditFormulario extends StatefulWidget{
  @override
  _EditFormularioPage createState() => _EditFormularioPage();
}

class _EditFormularioPage extends State<EditFormulario>{

  bool visibleMailAlternativo = true;
  bool visibleTelefonoCasa = true;
  bool isLoading= false;
  bool buttonEdit = false;

  final formKey = GlobalKey<FormState>();

  TextEditingController controllerName = new TextEditingController();
  TextEditingController controllerApellidoPaterno = new TextEditingController();
  TextEditingController controllerApellidoMaterno = new TextEditingController();
  TextEditingController controllerNumeroDeControl = new TextEditingController();
  TextEditingController controllerMovil = new TextEditingController();
  TextEditingController controllerTelefonoCasa = new TextEditingController();
  TextEditingController controllerEmailAlternativo = new TextEditingController();
  TextEditingController controllerCarrera = new TextEditingController();

  String _carreras_valor = "Seleccionar carrera";
  String mensaje = "";
  String email = "";
  String telefono_casa = "";

  List _carreras = [
    "Ing. En Sistemas Computacionales",
    "Ing. Mecánica",
    "Ing. Química",
    "Ing. Bioquímica",
    "Ing. Eléctrica",
    "Ing. Electrónica",
    "Ing. en Gestión Empresarial",
    "Ing. Industrial",
    "Ing. Logística",
  ];

  void hideMailAlternativo(){
    setState(() { visibleMailAlternativo = !visibleMailAlternativo; });
  }
  void hideTelefonoCasa(){
    setState(() {visibleTelefonoCasa = !visibleTelefonoCasa;});
  }

  formulario() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String id = sharedPreferences.getInt('id').toString();

    email = controllerEmailAlternativo.text;
    telefono_casa = controllerTelefonoCasa.text;

    if (!visibleMailAlternativo) email = "";
    if (!visibleTelefonoCasa) telefono_casa = "";

    Map data = {
      'name' : controllerName.text,
      'apellido1' : controllerApellidoPaterno.text,
      'apellido2' : controllerApellidoMaterno.text,
      'noControl' : controllerNumeroDeControl.text,
      'movil' : controllerMovil.text,
      'telefono_casa' : telefono_casa,
      'email_alternativo' : email,
      'carrera' : _carreras_valor
    };

    try{
      final response = await http.patch("http://192.168.1.68:8000/api/updateFormulario/"+id,body: data);
      if(response.statusCode == 200){
        setState(() { isLoading = false; });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute (builder: (BuildContext context) => MyHomePage()), (Route<dynamic>route) => false);
      }
      else if(response.statusCode == 401){
        setState(() {
          isLoading = false;
          mensaje = "No se puede actualizar el formulario, \nCargar de nuevo la Sección 'Formulario'";
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
      appBar: new AppBar(title: Text('Editar Formulario'),),
      drawer: MyDrawer(),
      resizeToAvoidBottomPadding: false,
      body: Container(
        child: buttonEdit ? Center(child: isLoading ? Center(child: CircularProgressIndicator()):
        ListView(
          children: [
            header(),
            formuRegistro(),
            formSection(),
            selectCarrera(),
            buttonsection(),
            messajeSection()
          ],
        )
        ) : ListView(
          children: [
            header(),
            editarMessage(),
            editarButton()
          ],
        )
      ),
    );
  }

  Container editarMessage(){
    return Container(
        height: 100,
        padding: EdgeInsets.only(left: 60, right: 40),
        child: Center(
          child: Text('Tu formulario ya ha sido registrado, si deseas actualizar '
              'tu información, presiona el siguiente botón',style: TextStyle(
            color: Colors.blue[500],
            fontWeight: FontWeight.bold,
            fontSize: 15
          ),),
        )
    );
  }

  Container editarButton(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
      child: Column(
        children: [
          RaisedButton(
            onPressed: (){setState(() {buttonEdit = !buttonEdit;});},
            child: Text("Editar Formulario",style: TextStyle(
                color: Colors.green,
                fontSize: 20
            ),),
          )
        ],
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
        hint: Center(child: Text("Seleccione Carrera")),
        dropdownColor: Colors.white,
        value: 'Ing. En Sistemas Computacionales',
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

  Container buttonsection(){
    return Container(
      child: Column(
        children: [
          RaisedButton(
            child: Text('Actualizar',style: TextStyle(
                color: Colors.blue,
                fontSize: 20
            )),
            onPressed: (){
              if(formKey.currentState.validate()){
                setState(() {isLoading = true;});
                formulario();
              }
            },
          ),
          RaisedButton(
            onPressed: (){setState(() {buttonEdit = !buttonEdit;});},
            child: Text("Cancelar",style: TextStyle(
                fontSize: 20,
                color: Colors.red)),
          )
        ],
      ),
    );
  }

  Container messajeSection(){
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