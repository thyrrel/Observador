import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:observador/services/db_helper.dart';
import 'package:observador/models/device_traffic.dart';

class PdfReport {
  static Future<void> generateAndShare() async {
    final db = DBHelper();
    final raw = await db.last7Days();        // precisaremos criar este método
    final data = raw.map((e) => DeviceTraffic.fromMap(e)).toList();

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Relatório Observador v2 - Últimos 7 dias',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['IP', 'Nome', 'Download (MB)', 'Upload (MB)'],
              data: data.map((d) => [
                    d.ip,
                    d.name,
                    (d.rxBytes / 1024 / 1024).toStringAsFixed(2),
                    (d.txBytes / 1024 / 1024).toStringAsFixed(2),
                  ]).toList(),
            ),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/relatorio_observador.pdf');
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)], text: 'Relatório de consumo');
  }
}
