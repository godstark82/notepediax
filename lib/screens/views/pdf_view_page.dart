// ignore_for_file: avoid_print, no_leading_underscores_for_local_identifiers, library_private_types_in_public_api

import 'package:course_app/models/course_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class PdfViewPage extends StatefulWidget {
  const PdfViewPage({super.key, required this.pdf});
  final PDFModel pdf;

  @override
  State<PdfViewPage> createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  //

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
    super.initState();
    secureScreen().whenComplete(() => null);
  }

//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 2,
          title: Text(widget.pdf.name.toString()),
        ),
        body: const PDF().cachedFromUrl(
          widget.pdf.url.toString(),
          placeholder: (progress) => Center(
              child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              Text('$progress %'),
            ],
          )),
          errorWidget: (error) => Center(child: Text(error.toString())),
        ));
  }
}
