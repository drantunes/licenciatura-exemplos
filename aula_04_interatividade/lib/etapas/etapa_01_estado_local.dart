import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(colorSchemeSeed: Colors.teal),
    home: const EstadoPage(),
  ),
);

class EstadoPage extends StatefulWidget {
  const EstadoPage({super.key});
  @override
  State<EstadoPage> createState() => _EstadoPageState();
}

class _EstadoPageState extends State<EstadoPage> {
  bool _mostrarTotal = true;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Lista de nomes')),
    body: Column(
      children: [
        SwitchListTile(
          title: const Text('Mostrar total'),
          value: _mostrarTotal,
          onChanged: (valor) {
            setState(() {
              _mostrarTotal = valor;
            });
          },
        ),
        if (_mostrarTotal)
          const Padding(padding: EdgeInsets.all(16), child: Text('Total: 0')),
      ],
    ),
  );
}
