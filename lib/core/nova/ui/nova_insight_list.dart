// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📋 NovaInsightList - Lista visual de insights da IA ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'package:flutter/material.dart';
import '../../models/nova_insight.dart';
import 'nova_dashboard_card.dart';

class NovaInsightList extends StatelessWidget {
  final List<NovaInsight> insights;

  const NovaInsightList({required this.insights, super.key});

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Nenhum insight gerado pela N.O.V.A.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: insights.length,
      itemBuilder: (_, i) => NovaDashboardCard(insight: insights[i]),
    );
  }
}
