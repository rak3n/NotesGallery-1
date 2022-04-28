import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfScreen extends StatelessWidget {
  static const routeName = '/pdfViewer';

  @override
  Widget build(BuildContext context) {
    final pdfUrl = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(title: Text("PDFViewer")),
      body: Container(
        child: SfPdfViewer.network(pdfUrl),
      ),
    );
  }
}
