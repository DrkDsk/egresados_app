// To parse this JSON data, do
//
//     final reqResRespuestaTramite = reqResRespuestaTramiteFromJson(jsonString);

import 'dart:convert';

ReqResRespuestaTramite reqResRespuestaTramiteFromJson(String str) => ReqResRespuestaTramite.fromJson(json.decode(str));

String reqResRespuestaTramiteToJson(ReqResRespuestaTramite data) => json.encode(data.toJson());

class ReqResRespuestaTramite {
  ReqResRespuestaTramite({
    this.data,
  });

  List<Tramite> data;

  factory ReqResRespuestaTramite.fromJson(Map<String, dynamic> json) => ReqResRespuestaTramite(
    data: List<Tramite>.from(json["data"].map((x) => Tramite.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Tramite {
  Tramite({
    this.name,
  });

  String name;

  factory Tramite.fromJson(Map<String, dynamic> json) => Tramite(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}