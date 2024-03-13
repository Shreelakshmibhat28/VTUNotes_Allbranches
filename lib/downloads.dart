import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path/path.dart' as path;

class DownloadedPDFsPage extends StatelessWidget {
  final List<String> downloadedPDFs;

  const DownloadedPDFsPage({Key? key, required this.downloadedPDFs})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded PDFs'),
      ),
      body: ListView.builder(
        itemCount: downloadedPDFs.length,
        itemBuilder: (context, index) {
          String pdfFileName = path.basename(downloadedPDFs[index]);
          return Padding(
            padding:  EdgeInsets.all(5.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                leading: Icon(Icons.picture_as_pdf_rounded,color: Colors.red.shade500,),
                title: Text(pdfFileName),
                onTap: () {
                  // Open the downloaded PDF using flutter_pdfview
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFView(
                        filePath: downloadedPDFs[index],
                        enableSwipe: true,
                        swipeHorizontal: false,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}