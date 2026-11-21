import 'dart:convert';

import 'package:campeonatosfifa/configuracion/configuracionapi.dart';
import 'package:campeonatosfifa/modelos/grupo.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GrupoServicio {
  final String urlBase = "${ConfiguracionApi.urlBase}/grupos";

  final variablesApp = FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await variablesApp.read(key: "token");
  }

  Future<Map<String, String>> _getEncabezado() async {
    final token = await _getToken();
    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  Future<List<Grupo>> getGrupos(int idCampeonato) async {
    try {
      final url = Uri.parse("$urlBase/campeonato/$idCampeonato");
      final encabezado = await _getEncabezado();
      final respuesta = await http.get(url, headers: encabezado);

      if (respuesta.statusCode == 200) {
        final List<dynamic> cuerpoJson = jsonDecode(respuesta.body);
        return Grupo.desdeListaJson(cuerpoJson);
      }
      return [];
    } catch (e) {
      print("Error en el servicio de grupos: $e");
      return [];
    }
  }
/*
  Future<List<posicionDto>> getPosiciones(int idGrupo) async {
    try {
      final url = Uri.parse("$urlBase/posiciones/$idGrupo");
      final encabezado = await _getEncabezado();
      final respuesta = await http.get(url, headers: encabezado);

      if (respuesta.statusCode == 200) {
        final List<dynamic> cuerpoJson = jsonDecode(respuesta.body);
        return posicionDto.desdeListaJson(cuerpoJson);
      }
      return [];
    } catch (e) {
      print("Error en el servicio de grupos al consultar posiciones: $e");
      return [];
    }
  }

 */
}
