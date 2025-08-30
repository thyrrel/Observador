import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/auth_service.dart';

class MockAuthService extends AuthService {
  @override
  Future<bool> authenticate() async {
    return true;
  }
}

void main() {
  late MockAuthService authService;

  setUp(() {
    authService = MockAuthService();
  });

  test('Autenticação retorna true', () async {
    final result = await authService.authenticate();
    expect(result, true);
  });
}
