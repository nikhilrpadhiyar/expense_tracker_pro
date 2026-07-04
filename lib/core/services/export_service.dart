import 'dart:io';

import 'package:csv/csv.dart';
import 'package:expense_tracker_pro/core/error/exceptions.dart';
import 'package:expense_tracker_pro/core/utils/currency_formatter.dart';
import 'package:expense_tracker_pro/core/utils/date_utils.dart';
import 'package:expense_tracker_pro/features/expense/domain/entities/expense_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  ExportService._();
  static final ExportService instance = ExportService._();

  Future<void> exportToCsv(List<ExpenseEntity> expenses) async {
    try {
      final List<List<dynamic>> rows = <List<dynamic>>[
        <dynamic>['Date', 'Title', 'Category', 'Amount', 'Note'],
        ...expenses.map(
          (ExpenseEntity e) => <dynamic>[
            AppDateUtils.formatDate(e.date),
            e.title,
            e.categoryId,
            e.amount.toStringAsFixed(2),
            e.note ?? '',
          ],
        ),
      ];

      final String csv = const ListToCsvConverter().convert(rows);
      final Directory dir = await getTemporaryDirectory();
      final File file = File('${dir.path}/expenses_export.csv');
      await file.writeAsString(csv);

      await SharePlus.instance.share(
        ShareParams(
          text: 'Expense Export',
          files: <XFile>[XFile(file.path, mimeType: 'text/csv')],
        ),
      );
    } catch (e) {
      throw ExportException(message: 'Failed to export CSV: $e');
    }
  }

  Future<void> exportToPdf({
    required List<ExpenseEntity> expenses,
    required String month,
    required double totalIncome,
    required double totalExpense,
    required String currency,
  }) async {
    try {
      final pw.Document doc = pw.Document();

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) => <pw.Widget>[
            pw.Header(
              level: 0,
              child: pw.Text(
                'Expense Report — $month',
                style: pw.TextStyle(
                  fontSize: 22,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 16),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: <pw.Widget>[
                _summaryBlock(
                  'Total Income',
                  CurrencyFormatter.format(totalIncome, currency: currency),
                ),
                _summaryBlock(
                  'Total Expense',
                  CurrencyFormatter.format(totalExpense, currency: currency),
                ),
                _summaryBlock(
                  'Net Savings',
                  CurrencyFormatter.format(
                    totalIncome - totalExpense,
                    currency: currency,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 24),
            pw.TableHelper.fromTextArray(
              headers: <dynamic>['Date', 'Title', 'Category', 'Amount'],
              data: expenses
                  .map(
                    (ExpenseEntity e) => <String>[
                      AppDateUtils.formatDate(e.date),
                      e.title,
                      e.categoryId,
                      CurrencyFormatter.format(e.amount, currency: currency),
                    ],
                  )
                  .toList(),
              border: pw.TableBorder.all(color: PdfColors.grey300),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration: const pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              cellAlignment: pw.Alignment.centerLeft,
              cellPadding: const pw.EdgeInsets.all(6),
            ),
          ],
        ),
      );

      await Printing.sharePdf(
        bytes: await doc.save(),
        filename: 'expense_report_$month.pdf',
      );
    } catch (e) {
      throw ExportException(message: 'Failed to export PDF: $e');
    }
  }

  pw.Widget _summaryBlock(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: <pw.Widget>[
        pw.Text(
          label,
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
        ),
      ],
    );
  }
}
