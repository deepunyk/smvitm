import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';

class PDFViewScreen extends StatefulWidget {
  static const routeName = '/pdfview';

  @override
  _PDFViewScreenState createState() => _PDFViewScreenState();
}

class _PDFViewScreenState extends State<PDFViewScreen> {
  Color _color;
  bool _isLoading = true;
  bool code = false;
  String passValue = "";
  PDFDocument doc;

  getDocument() async {
    doc = await PDFDocument.fromURL(passValue);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _color = Theme.of(context).primaryColor;
    final _mediaQuery = MediaQuery.of(context).size;
    passValue = ModalRoute.of(context).settings.arguments as String;

    if (!code) {
      code = !code;
      getDocument();
    }

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(
          "PDF View",
          style: TextStyle(color: _color),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: _color),
        actions: [
          /*IconButton(
              icon: Icon(
                Icons.file_download,
                color: _color,
              ),
              onPressed: () {
              })*/
        ],
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: doc)),
    );
  }
}
