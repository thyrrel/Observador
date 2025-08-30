// lib/services/pdf_report_service.dart
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFReportService {
  final pw.Document _doc = pw.Document();

  void addPage(String title, String content) {
    _doc.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(title, style: const pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 12),
            pw.Text(content),
          ],
        ),
      ),
    );
  }

  Future<void> save(String path) async {
    final file = File(path);
    await file.writeAsBytes(await _doc.save());
  }
}
