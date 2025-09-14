// ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
// ┃ 📦 pdf_report_service.dart - Geração de relatórios PDF com conteúdo dinâmico ┃
// ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFReportService {
  final pw.Document _doc = pw.Document();

  void addPage(String title, String content) {
    _doc.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: <pw.Widget>[
            pw.Text(
              title,
              style: const pw.TextStyle(fontSize: 24),
            ),
            pw.SizedBox(height: 12),
            pw.Text(content),
          ],
        ),
      ),
    );
  }

  Future<void> save(String path) async {
    final File file = File(path);
    final List<int> bytes = await _doc.save();
    await file.writeAsBytes(bytes);
  }
}

// Sugestões
// - 🛡️ Adicionar tratamento de erro em `save()` para evitar falhas silenciosas
// - 🔤 Permitir múltiplas seções por página ou estilos personalizados
// - 📦 Criar método `addImage()` para incluir gráficos ou capturas
// - 🧩 Adicionar suporte a cabeçalhos, rodapés e numeração de páginas
// - 🎨 Integrar com tema visual do app para consistência de identidade

// ✍️ byThyrrel  
// 💡 Código formatado com estilo técnico, seguro e elegante  
// 🧪 Ideal para agentes de IA com foco em refatoração limpa e confiável
