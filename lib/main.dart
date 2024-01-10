import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:postgres/postgres.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _barcodeResult = ''; // Variable para almacenar el resultado del escaneo
  String _connectionStatus = ''; // Variable para almacenar el estado de la conexión

  Future<void> _scanBarcode() async {
    try {
      String barcodeScanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        false,
        ScanMode.BARCODE,
      );

      if (barcodeScanResult != '-1') {
        // Actualizar el estado con el resultado del escaneo
        setState(() {
          _barcodeResult = 'Código de barras escaneado: $barcodeScanResult';
        });
      }
    } catch (e) {
      // Manejar errores
      print('Error al escanear código de barras: $e');
    }
  }

  Future<void> _checkDatabaseConnection() async {
    PostgreSQLConnection connection = PostgreSQLConnection(
      '127.0.0.1',
  5432,
  'scaner',
  username: 'postgres',
  password: 'password',
    );

    try {
      // Intentar abrir la conexión a la base de datos
      await connection.open();

      // Si la conexión se abre con éxito, actualizar el estado
      setState(() {
        _connectionStatus = 'Conexión a PostgreSQL exitosa';
      });
    } catch (e) {
      // Manejar errores
      setState(() {
        _connectionStatus = 'Error al conectar a PostgreSQL: $e';
      });
    } finally {
      // Asegurarse de cerrar la conexión
      await connection.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _scanBarcode,
              child: const Text('Escanear Código de Barras'),
            ),
            const SizedBox(height: 20), // Espacio entre el botón y el resultado
            Text(_barcodeResult), // Mostrar el resultado del escaneo
            const SizedBox(height: 20), // Espacio adicional
            ElevatedButton(
              onPressed: _checkDatabaseConnection,
              child: const Text('Verificar Conexión a PostgreSQL'),
            ),
            const SizedBox(height: 20), // Espacio adicional
            Text(_connectionStatus), // Mostrar el estado de la conexión
          ],
        ),
      ),
    );
  }
}