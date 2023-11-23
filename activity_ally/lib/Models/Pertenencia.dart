import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:activity_ally/Views/Mochila/widgets/InfoPertenencia.dart';

class Pertenencia {
  int id;
  String nombre;
  bool status;
  String descripcion;
  //String? foto;
  String? foto;

  Pertenencia({
    required this.id,
    required this.nombre,
    this.status = true,
    this.descripcion = '',
    this.foto,
  });

  factory Pertenencia.fromJson(Map<String, dynamic> json) {
    return Pertenencia(
      id: json['id'],
      nombre: json['nombre'],
      status: json['status'] != "0",
      descripcion: json['descripcion'],
      foto: (json['foto']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'status': status,
      'descripcion': descripcion,
      'foto': foto
    };
  }

  Map<String, dynamic> toSqlite() {
    return {
      'nombre': nombre,
      'status': status,
      'descripcion': descripcion,
      'foto': foto
    };
  }
  //@override
  // State<StatefulWidget> createState() => _Pertenencia();
}
