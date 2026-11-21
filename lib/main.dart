import 'package:campeonatosfifa/vistas/campeonato.vista.dart';
import 'package:campeonatosfifa/vistas/inicio.vista.dart';
import 'package:campeonatosfifa/vistas/login.vista.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campeonatos FIFA App',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      routes:{
        "/login":(context)=>const LoginVista(),
        "/inicio":(context)=>const InicioVista(),
        "/campeonatos":(context)=>const CampeonatoVista(),
        //"/selecciones":(context)=>const SeleccionVista(),
      },
      initialRoute: "/login",
    );
  }
}
