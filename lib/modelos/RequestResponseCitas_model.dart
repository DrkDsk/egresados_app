// To parse this JSON data, do
//
//     final reqResRespuesta = reqResRespuestaFromJson(jsonString);

import 'dart:convert';

ReqResRespuesta reqResRespuestaFromJson(String str) => ReqResRespuesta.fromJson(json.decode(str));

String reqResRespuestaToJson(ReqResRespuesta data) => json.encode(data.toJson());

class ReqResRespuesta {
  ReqResRespuesta({
    this.data,
  });

  List<Cita> data;

  factory ReqResRespuesta.fromJson(Map<String, dynamic> json) => ReqResRespuesta(
    data: List<Cita>.from(json["data"].map((x) => Cita.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Cita {
  Cita({
    this.id,
    this.tramiteId,
    this.fecha,
    this.hora,
    this.descripcion,
    this.createdAt,
    this.updatedAt,
    this.egresadoId,
    this.tipo,
    this.finalizado,
  });

  int id;
  int tramiteId;
  DateTime fecha;
  String hora;
  String descripcion;
  DateTime createdAt;
  DateTime updatedAt;
  int egresadoId;
  String tipo;
  int finalizado;

  factory Cita.fromJson(Map<String, dynamic> json) => Cita(
    id: json["id"],
    tramiteId: json["tramite_id"],
    fecha: DateTime.parse(json["fecha"]),
    hora: json["hora"],
    descripcion: json["descripcion"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    egresadoId: json["egresado_id"],
    tipo: json["tipo"],
    finalizado: json["finalizado"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tramite_id": tramiteId,
    "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
    "hora": hora,
    "descripcion": descripcion,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "egresado_id": egresadoId,
    "tipo": tipo,
    "finalizado": finalizado,
  };
}