import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Admin')),
      body: Stack(
        children: [
          // Fundo especial para tema Matrix
          if (appState.theme == AppTheme.Matrix) const _MatrixBackground(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tema do Aplicativo',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                DropdownButton<AppTheme>(
                  value: appState.theme,
                  items: AppTheme.values.map((theme) {
                    return DropdownMenuItem(
                      value: theme,
                      child: Text(theme.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (newTheme) {
                    if (newTheme != null) appState.setTheme(newTheme);
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Ações administrativas extras
                  },
                  child: const Text('Executar ação administrativa'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------
// Efeito Matrix
// ---------------------------
class _MatrixBackground extends StatefulWidget {
  const _MatrixBackground({super.key});

  @override
  State<_MatrixBackground> createState() => _MatrixBackgroundState();
}

class _MatrixBackgroundState extends State<_MatrixBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_MatrixColumn> _columns = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
    for (int i = 0; i < 50; i++) {
      _columns.add(_MatrixColumn());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _MatrixPainter(_columns),
        );
      },
    );
  }
}

class _MatrixColumn {
  double positionY = 0;
  final int length = 10 + (10 * (0.5 + 0.5 * (0.5)));
}

class _MatrixPainter extends CustomPainter {
  final List<_MatrixColumn> columns;
  final Paint _paint = Paint();
  final TextStyle _style = const TextStyle(color: Colors.greenAccent);

  _MatrixPainter(this.columns);

  @override
  void paint(Canvas canvas, Size size) {
    final double columnWidth = size.width / columns.length;
    final random = DateTime.now().millisecondsSinceEpoch;

    for (int i = 0; i < columns.length; i++) {
      final col = columns[i];
      final text = String.fromCharCode(33 + (random % 94));
      final textPainter = TextPainter(
        text: TextSpan(text: text, style: _style),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.drawParagraph(
          (textPainter.build() as Paragraph), Offset(i * columnWidth, col.positionY));
      col.positionY += 10;
      if (col.positionY > size.height) col.positionY = 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
