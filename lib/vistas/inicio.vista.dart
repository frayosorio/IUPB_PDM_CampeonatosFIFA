import 'package:campeonatosfifa/servicios/autorizacion.servicio.dart';
import 'package:flutter/material.dart';

class InicioVista extends StatefulWidget {
  const InicioVista({super.key});

  @override
  State<InicioVista> createState() => _InicioVistaState();
}

class _InicioVistaState extends State<InicioVista> {
  // Paleta de colores inspirada en torneos internacionales
  final Color azulPrimario = const Color(0xFF0C1E43); // Azul FIFA profundo
  final Color azulAcento = const Color(0xFF1D4ED8);   // Azul brillante para interacción
  final Color dorado = const Color(0xFFD4AF37);       // Dorado premium para detalles

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Fondo limpio y claro
      appBar: AppBar(
        title: const Text(
          'Campeonatos FIFA',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: azulPrimario,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // ====== DESIGN DEL DRAWER (MENÚ LATERAL) ======
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [azulPrimario, azulAcento],
                ),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Image.asset(
                    'assets/imagenes/Logo_FIFA.jpeg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              accountName: const Text(
                'Gestor de Torneos',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: const Text('Administrador de Contenido'),
            ),
            ListTile(
              leading: Icon(Icons.sports_soccer, color: azulAcento),
              title: const Text('Campeonatos', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer antes de navegar
                Navigator.pushNamed(context, '/campeonatos');
              },
            ),
            ListTile(
              leading: Icon(Icons.flag, color: azulAcento),
              title: const Text('Selecciones', style: TextStyle(fontWeight: FontWeight.w600)),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/selecciones');
              },
            ),
            const Spacer(), // Empuja el botón de cerrar sesión hacia abajo
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Cerrar sesión',
                style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
              onTap: () async {
                await AutorizacionServicio.tokenExpirado(context);
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // ====== DESIGN DEL BODY (VISTA PRINCIPAL) ======
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Contenedor superior con el Logo y un fondo estilizado
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: azulPrimario,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
              ),
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        'assets/imagenes/Logo_FIFA.jpeg',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "¡Bienvenido de nuevo!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Selecciona una opción para comenzar",
                    style: TextStyle(
                      color: Colors.blue[100],
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Sección de accesos directos en Grid
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // El scroll lo maneja el SingleChildScrollView
                children: [
                  _buildMenuCard(
                    context: context,
                    titulo: "Campeonatos",
                    subtitulo: "Gestionar torneos",
                    icono: Icons.sports_soccer,
                    colorIcono: dorado,
                    ruta: "/campeonatos",
                  ),
                  _buildMenuCard(
                    context: context,
                    titulo: "Selecciones",
                    subtitulo: "Países participantes",
                    icono: Icons.flag,
                    colorIcono: Colors.blueAccent,
                    ruta: "/selecciones",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget para construir las tarjetas de acceso rápido
  Widget _buildMenuCard({
    required BuildContext context,
    required String titulo,
    required String subtitulo,
    required IconData icono,
    required Color colorIcono,
    required String ruta,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.pushNamed(context, ruta),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorIcono.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icono, color: colorIcono, size: 30),
              ),
              const Spacer(),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitulo,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}