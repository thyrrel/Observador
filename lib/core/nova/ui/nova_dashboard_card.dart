// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📊 NovaDashboardCard - Exibe insights da IA          ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import '../../models/nova_insight.dart';

class NovaDashboardCard extends StatelessWidget {
  final NovaInsight insight;

  const NovaDashboardCard({required this.insight, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: ListTile(
        leading: Icon(Icons.memory, color: Colors.deepPurple),
        title: Text(insight.device.name),
        subtitle: Text(insight.mensagem),
        trailing: Text(
          insight.tipo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
