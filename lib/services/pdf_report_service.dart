// lib/services/pdf_report_service.dart
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class PdfReportService {
  Future<void> generateReport(String path, Map<String, dynamic> data) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.ListView(
            children: data.entries.map((e) => pw.Text('${e.key}: ${e.value}')).toList(),
          );
        },
      ),
    );
    final file = File(path);
    await file.writeAsBytes(await pdf.save());
  }
}
