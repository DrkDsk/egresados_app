// To parse this JSON data, do
//
//     final reqResRespuestaEstadoTramite = reqResRespuestaEstadoTramiteFromJson(jsonString);

import 'dart:convert';

ReqResRespuestaEstadoTramite reqResRespuestaEstadoTramiteFromJson(String str) => ReqResRespuestaEstadoTramite.fromJson(json.decode(str));

String reqResRespuestaEstadoTramiteToJson(ReqResRespuestaEstadoTramite data) => json.encode(data.toJson());

class ReqResRespuestaEstadoTramite {
  ReqResRespuestaEstadoTramite({
    this.data,
  });

  Formulario data;

  factory ReqResRespuestaEstadoTramite.fromJson(Map<String, dynamic> json) => ReqResRespuestaEstadoTramite(
    data: Formulario.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
  };
}

class Formulario {
  Formulario({
    this.id,
    this.userId,
    this.name,
    this.apellido1,
    this.apellido2,
    this.noControl,
    this.movil,
    this.telefonoCasa,
    this.emailAlternativo,
    this.carrera,
    this.fechaIngreso,
    this.fechaEgreso,
  });

  int id;
  int userId;
  String name;
  String apellido1;
  String apellido2;
  String noControl;
  String movil;
  String telefonoCasa;
  String emailAlternativo;
  String carrera;
  DateTime fechaIngreso;
  DateTime fechaEgreso;

  factory Formulario.fromJson(Map<String, dynamic> json) => Formulario(
    id: json["id"],
    userId: json["user_id"],
    name: json["name"],
    apellido1: json["apellido1"],
    apellido2: json["apellido2"],
    noControl: json["noControl"],
    movil: json["movil"],
    telefonoCasa: json["telefono_casa"],
    emailAlternativo: json["email_alternativo"],
    carrera: json["carrera"],
    fechaIngreso: DateTime.parse(json["fechaIngreso"]),
    fechaEgreso: DateTime.parse(json["fechaEgreso"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "name": name,
    "apellido1": apellido1,
    "apellido2": apellido2,
    "noControl": noControl,
    "movil": movil,
    "telefono_casa": telefonoCasa,
    "email_alternativo": emailAlternativo,
    "carrera": carrera,
    "fechaIngreso": "${fechaIngreso.year.toString().padLeft(4, '0')}-${fechaIngreso.month.toString().padLeft(2, '0')}-${fechaIngreso.day.toString().padLeft(2, '0')}",
    "fechaEgreso": "${fechaEgreso.year.toString().padLeft(4, '0')}-${fechaEgreso.month.toString().padLeft(2, '0')}-${fechaEgreso.day.toString().padLeft(2, '0')}",
  };
}