import 'package:flutter/material.dart';

void main() {
  runApp(const CotizaFacilApp());
}

class CotizaFacilApp extends StatelessWidget {
  const CotizaFacilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CotizaFácil',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const CotizadorScreen(),
    );
  }
}

class CotizadorScreen extends StatefulWidget {
  const CotizadorScreen({super.key});

  @override
  State<CotizadorScreen> createState() => _CotizadorScreenState();
}

class _CotizadorScreenState extends State<CotizadorScreen> {
  final _nombreController = TextEditingController();
  final _precioController = TextEditingController();
  final _cantidadController = TextEditingController();

  String _resultado = '';

  void _calcularCotizacion() {
    final nombre = _nombreController.text;
    final double? precioUnitario = double.tryParse(_precioController.text);
    final int? cantidad = int.tryParse(_cantidadController.text);

    if (precioUnitario == null || cantidad == null || precioUnitario <= 0 || cantidad <= 0) {
      setState(() {
        _resultado = 'Por favor, introduce un precio y cantidad válidos.';
      });
      return;
    }

    double valorBruto = precioUnitario * cantidad;

    double porcentajeDescuento = 0.0;
    if (cantidad >= 100 && cantidad <= 500) {
      porcentajeDescuento = 0.10; 
    } else if (cantidad > 500) {
      porcentajeDescuento = 0.15; 
    }

    double valorDescuento = valorBruto * porcentajeDescuento;
    double valorConDescuento = valorBruto - valorDescuento;

    double iva = valorBruto * 0.19;

    double totalPagar = valorConDescuento + iva;

    setState(() {
      _resultado = '''
Producto: ${nombre.isEmpty ? 'General' : nombre}
Valor Bruto: \$${valorBruto.toStringAsFixed(2)}
Descuento (${(porcentajeDescuento * 100).toInt()}%): -\$${valorDescuento.toStringAsFixed(2)}
IVA (19% sobre bruto): +\$${iva.toStringAsFixed(2)}
--------------------------------------
Total a Pagar: \$${totalPagar.toStringAsFixed(2)}
''';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CotizaFácil'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Calcula el precio de tu venta',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nombreController,
              decoration: const InputDecoration(
                labelText: 'Nombre del producto',
                hintText: 'Ej. Camiseta',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _precioController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Precio unitario (\$)',
                hintText: 'Ej. 35000',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _cantidadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                hintText: 'Ej. 3',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _calcularCotizacion,
              child: const Text('Calcular cotización', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 25),
            if (_resultado.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _resultado,
                  style: const TextStyle(fontSize: 15, fontFamily: 'monospace'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}