import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/auth_service.dart';

class MockAuthService extends AuthService {
  final bool result;
  MockAuthService(this.result);

  @override
  Future<bool> authenticate() async {
    return result;
  }
}

void main() {
  test('Autenticação biométrica bem-sucedida', () async {
    final auth = MockAuthService(true);
    final success = await auth.authenticate();
    expect(success, true);
  });

  test('Autenticação biométrica falha', () async {
    final auth = MockAuthService(false);
    final success = await auth.authenticate();
    expect(success, false);
  });
}
