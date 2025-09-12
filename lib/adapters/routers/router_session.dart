// /lib/adapters/routers/router_session.dart
// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 🔐 RouterSession - Sessão autenticada com roteador ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'router_type.dart';

class RouterSession {
  final String token;
  final RouterType type;
  final DateTime? expiresAt;

  RouterSession({
    required this.token,
    required this.type,
    this.expiresAt,
  });
}
