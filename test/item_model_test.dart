import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Cálculo de precio de ejemplo', () {
    const price = 450.0;
    expect(price.toStringAsFixed(2), '450.00');
  });
}
