import 'package:flutter_test/flutter_test.dart';
import 'package:observador/services/agent_service.dart';

void main() {
  test('Inicia e para o AgentService', () async {
    final agent = AgentService.instance;
    expect(agent.isRunning, false);

    await agent.start(interval: Duration(milliseconds: 50));
    expect(agent.isRunning, true);

    await Future.delayed(Duration(milliseconds: 100));
    await agent.stop();
    expect(agent.isRunning, false);
  });
}
