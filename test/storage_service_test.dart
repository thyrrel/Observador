import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/storage_service.dart';

void main() {
  test('StorageService salva e lê dados', () async {
    final storage = StorageService();
    await storage.save('key1', 'valor1');

    final value = await storage.read('key1');
    expect(value, 'valor1');

    await storage.delete('key1');
    final deleted = await storage.read('key1');
    expect(deleted, null);
  });
}
