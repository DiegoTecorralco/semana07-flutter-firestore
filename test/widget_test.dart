
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Verificar funcionamiento básico de pruebas', () {
    final int resultado = 5 + 5;

    expect(resultado, 10);
  });

  test('Verificar lista vacía', () {
    final List<String> productos = [];

    expect(productos.isEmpty, true);
  });

  test('Verificar inserción de producto', () {
    final List<String> productos = [];

    productos.add('Laptop');

    expect(productos.length, 1);
    expect(productos.first, 'Laptop');
  });
}
