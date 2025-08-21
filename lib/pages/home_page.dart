// dentro de HomePage → children: [
_buildCard(
  icon: Icons.speed,
  title: 'Dashboard de Banda',
  subtitle: 'Veja quem está usando a rede agora',
  onTap: () => Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const DashboardPage()),
  ),
),
