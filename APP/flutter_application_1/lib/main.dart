import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: NavegacionPrincipal()));

class NavegacionPrincipal extends StatefulWidget {
  const NavegacionPrincipal({super.key});

  @override
  State<NavegacionPrincipal> createState() => _NavegacionPrincipalState();
}

class _NavegacionPrincipalState extends State<NavegacionPrincipal> {
  int _indice = 1;

  final List<Map<String, String>> _datosProduccion = [];
  final List<Map<String, String>> _datosDespacho = [];

  void _agregarProduccion(String nombre, String descripcion) {
    setState(() {
      _datosProduccion.add({'nombre': nombre, 'descripcion': descripcion});
      _indice = 2;
    });
  }

  void _moverDespacho(int index) {
    setState(() {
      _datosDespacho.add(_datosProduccion[index]);
      _datosProduccion.removeAt(index);
      _indice = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pantallas = [
      Despacho(lista: _datosDespacho),
      Formulario(onGuardar: _agregarProduccion),
      Produccion(lista: _datosProduccion, onEnviarADespacho: _moverDespacho),
    ];

    return Scaffold(
      body: _pantallas[_indice],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indice,
        onTap: (nuevoIndice) => setState(() => _indice = nuevoIndice),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Despacho',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note),
            label: 'Formulario',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_suggest),
            label: 'Produccion',
          ),
        ],
      ),
    );
  }
}

class Despacho extends StatelessWidget {
  final List<Map<String, String>> lista;
  const Despacho({super.key, required this.lista});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Despacho')),
      body: lista.isEmpty
          ? const Center(child: Text('Nada '))
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(lista[index]['nombre'] ?? ''),
                  subtitle: Text(
                    'Listo para enviar: ${lista[index]['descripcion']}',
                  ),
                );
              },
            ),
    );
  }
}

class Formulario extends StatelessWidget {
  final Function(String, String) onGuardar;
  final TextEditingController nombre = TextEditingController();
  final TextEditingController desc = TextEditingController();

  Formulario({super.key, required this.onGuardar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Formulario')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: nombre,
              decoration: const InputDecoration(hintText: 'Nombre'),
            ),
            TextField(
              controller: desc,
              decoration: const InputDecoration(hintText: 'Descripcion'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nombre.text.isNotEmpty) {
                  onGuardar(nombre.text, desc.text);
                  nombre.clear();
                  desc.clear();
                }
              },
              child: const Text('Mandar a Produccion'),
            ),
          ],
        ),
      ),
    );
  }
}

class Produccion extends StatelessWidget {
  final List<Map<String, String>> lista;
  final Function(int) onEnviarADespacho;

  const Produccion({
    super.key,
    required this.lista,
    required this.onEnviarADespacho,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Producción')),
      body: lista.isEmpty
          ? const Center(child: Text('No hay nada '))
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.build),
                  title: Text(lista[index]['nombre'] ?? ''),
                  subtitle: Text(lista[index]['descripcion'] ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () => onEnviarADespacho(index),
                  ),
                );
              },
            ),
    );
  }
}
