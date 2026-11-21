import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AutorizacionServicio {
  static final variablesApp = FlutterSecureStorage();

  // Maneja token vencido para toda la app
  static Future<void> tokenExpirado(BuildContext context) async {
    // Eliminar token
    await variablesApp.delete(key: "token");

    // Limpia cualquier otro dato de usuario si lo tienes
    await variablesApp.delete(key: "usuario");

    // Redireccionar al login sin permitir volver atrás
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
          (route) => false,
    );
  }

  // Obtener token desde cualquier servicio
  static Future<String?> getToken() async {
    return await variablesApp.read(key: "token");
  }
}