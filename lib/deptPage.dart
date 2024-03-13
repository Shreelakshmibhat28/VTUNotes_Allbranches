import 'package:flutter/material.dart';

import 'CSE.dart';
import 'Civil.dart';
import 'ECE.dart';
import 'Mech.dart';
import 'downloads.dart';
import 'notesupload.dart';

void main() {
  runApp(const MaterialApp(
    home: DeptPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class DeptPage extends StatefulWidget {
  const DeptPage({super.key});

  @override
  State<DeptPage> createState() => _DeptPageState();
}

class _DeptPageState extends State<DeptPage> {
  void _CSE() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CompSci(branch: 'CSE')),
    );
  }

  void _ECE() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EleCom(branch: 'ECE')),
    );
  }

  void _ME() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Mech(branch: 'ME')),
    );
  }

  void _CV() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Civil(branch: 'CV')),
    );
  }
  void _navigateToDownloadedPDFsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DownloadedPDFsPage(downloadedPDFs: []), // Pass your downloaded PDFs list
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Department'),
        centerTitle: true,
        actions: [IconButton(onPressed: _navigateToDownloadedPDFsPage, icon: const Icon(Icons.download))],
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NoteUploadScreen()));
            },
            icon: const Icon(Icons.book_rounded)),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient:
                LinearGradient(colors: [Colors.deepPurple, Colors.blueAccent]),
            ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 0, bottom: 100),
                child: Text(
                  'Select you department',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _CSE,
                style: ElevatedButton.styleFrom(
                  fixedSize: const Size(300, 50),
                ),
                child: const Text('Computer Science Engineering'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _ECE,
                style: ElevatedButton.styleFrom(fixedSize: const Size(300, 50)),
                child: const Text(
                  'Electronic Communication and Engineering',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _ME,
                style: ElevatedButton.styleFrom(fixedSize: const Size(300, 50)),
                child: const Text('Mechanical Engineering'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _CV,
                style: ElevatedButton.styleFrom(fixedSize: const Size(300, 50)),
                child: const Text('Civil Engineering'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
