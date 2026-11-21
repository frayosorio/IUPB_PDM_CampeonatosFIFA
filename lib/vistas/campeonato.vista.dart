import 'package:campeonatosfifa/modelos/campeonato.dart';
import 'package:campeonatosfifa/modelos/grupo.dart';
import 'package:campeonatosfifa/servicios/campeonato.servicio.dart';
import 'package:campeonatosfifa/servicios/grupo.servicio.dart';
import 'package:flutter/material.dart';

class CampeonatoVista extends StatefulWidget {
  const CampeonatoVista({super.key});

  @override
  State<CampeonatoVista> createState() => _CampeonatoVistaState();
}

class _CampeonatoVistaState extends State<CampeonatoVista> {
  final CampeonatoServicio _servicioCampeonato = CampeonatoServicio();
  final GrupoServicio _servicioGrupo = GrupoServicio();

  bool _cargandoCampeonatos = true;
  bool _cargandoGrupos = false;

  List<Campeonato> _campeonatos = [];
  Campeonato? _campeonatoSeleccionado;

  List<Grupo> _grupos = [];
  Grupo? _grupoSeleccionado;

  Future<void> _listarCampeonatos() async {
    final datos = await _servicioCampeonato.getCampeonatos();
    setState(() {
      _campeonatos = datos;
      _cargandoCampeonatos = false;
    });
  }

  Future<void> _listarGrupos(int idCampeonato) async {
    setState(() {
      _cargandoGrupos = true;
    });
    final datos = await _servicioGrupo.getGrupos(idCampeonato);
    setState(() {
      _grupos = datos;
      _cargandoGrupos = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _listarCampeonatos();
  }

  @override
  Widget build(BuildContext contexto) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Campeonatos Mundiales",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        elevation: 4,
      ),
      body: _cargandoCampeonatos
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ====== SELECTOR 1: CAMPEONATOS ======
                  const Text(
                    "Selección de Torneo",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tarjeta contenedora del Dropdown
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: DropdownButtonFormField<Campeonato>(
                        initialValue: _campeonatoSeleccionado,
                        hint: const Text("Seleccione un campeonato"),
                        isExpanded: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        items: _campeonatos.map((campeonato) {
                          return DropdownMenuItem<Campeonato>(
                            value: campeonato,
                            child: Text(
                              "${campeonato.nombre} (${campeonato.anio})",
                              style: const TextStyle(fontSize: 15),
                            ),
                          );
                        }).toList(),
                        onChanged: (Campeonato? campeonatoSeleccionado) {
                          if (campeonatoSeleccionado != null) {
                            setState(() {
                              _campeonatoSeleccionado = campeonatoSeleccionado;
                              _grupoSeleccionado = null;
                              _grupos = [];
                            });
                            _listarGrupos(campeonatoSeleccionado.id);
                          }
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ====== SELECTOR 2: GRUPOS (DINÁMICO) ======
                  const Text(
                    "2. Seleccione el Grupo",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _cargandoGrupos
                          ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      )
                          : DropdownButtonFormField<Grupo>(
                        initialValue: _grupoSeleccionado,
                        hint: Text(
                          _campeonatoSeleccionado == null
                              ? "Primero elija un campeonato"
                              : "Seleccione un grupo",
                        ),
                        isExpanded: true,
                        disabledHint: const Text(
                          "Primero elija un campeonato",
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.layers,
                            color: _campeonatoSeleccionado == null
                                ? Colors.grey
                                : Colors.indigo,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        // Se desactiva si no hay campeonato seleccionado o si está cargando
                        items:
                        _campeonatoSeleccionado == null ||
                            _grupos.isEmpty
                            ? null
                            : _grupos.map((grupo) {
                          return DropdownMenuItem<Grupo>(
                            value: grupo,
                            child: Text("Grupo ${grupo.nombre}"),
                          );
                        }).toList(),
                        onChanged: (Grupo? grupoSeleccionado) {
                          if (grupoSeleccionado != null) {
                            setState(() {
                              _grupoSeleccionado = grupoSeleccionado;
                            });
                            //_listarPosiciones(grupoSeleccionado.id);
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
