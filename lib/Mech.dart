import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'database.dart';
import 'databasehelperclass.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'downloads.dart';

void main() {
  //wait NotesDatabaseHelper.instance.init();
  runApp(const MaterialApp(
    home: Mech(
      branch: 'ME',
    ),
    debugShowCheckedModeBanner: false,
  ));
}

// CompSci class
class Mech extends StatefulWidget {
  const Mech({Key? key, required this.branch}) : super(key: key);
  final String branch;
  @override
  State<Mech> createState() => _MechState();
}

class _MechState extends State<Mech> {
  String selectedYear = 'Year';
  String selectedScheme = 'Scheme';
  String selectedSemester = 'Semester';

  List<String> years = ['Year', '1', '2', '3', '4'];
  List<String> schemes = ['Scheme', '2018', '2021', '2022'];
  List<String> semesters = ['Semester', '1', '2', '3', '4', '5', '6', '7', '8'];
  List<String> downloadedPDFs = [];
  List<Note> filteredNotes = [];
  @override
  void initState() {
    super.initState();
    getFilteredNotes();
  }

  Future<void> getFilteredNotes() async {
    try {
      await NotesDatabaseHelper.instance.init();
      List<Note> notes = await NotesDatabaseHelper.instance.getFilteredNotes(
        widget.branch,
        selectedYear,
        selectedScheme,
        selectedSemester,
      );

      setState(() {
        filteredNotes = notes;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error in database operation: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.branch} Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 5, right: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildDropdown('Select Year', years, selectedYear, (value) {
                  setState(() {
                    selectedYear = value!;
                    getFilteredNotes();
                  });
                }),
                const SizedBox(height: 5.0),
                _buildDropdown('Select Scheme', schemes, selectedScheme,
                    (value) {
                  setState(() {
                    selectedScheme = value!;
                    getFilteredNotes();
                  });
                }),
                const SizedBox(height: 5.0),
                _buildDropdown('Select Semester', semesters, selectedSemester,
                    (value) {
                  setState(() {
                    selectedSemester = value!;
                    getFilteredNotes();
                  });
                }),
                const SizedBox(height: 5.0),
              ],
            ),
            const SizedBox(height: 16.0),
            _buildNotesList()
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    List<String> items,
    String value,
    ValueChanged<String?> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(label),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButton<String>(
              value: value,
              onChanged: onChanged,
              items: items.map<DropdownMenuItem<String>>((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList() {
    if (filteredNotes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: filteredNotes.length,
          itemBuilder: (context, index) {
            Note currentNote = filteredNotes[index];
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                  title: Text(currentNote.title),
                  onTap: () {
                    // Open PDF using flutter_pdfview
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PDFView(
                          filePath: currentNote.pdfPath,
                          enableSwipe: true,
                          swipeHorizontal: false,
                        ),
                      ),
                    );
                  },
                  trailing: IconButton(
                      onPressed: () async {
                        await downloadPDF(currentNote.pdfPath);
                        downloadedPDFs.add(currentNote.pdfPath);

                        // Navigate to the DownloadedPDFsPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DownloadedPDFsPage(
                                downloadedPDFs: downloadedPDFs),
                          ),
                        );
                      },
                      icon: const Icon(Icons.download_for_offline_rounded))),
            );
          },
        ),
      );
    }
  }

  Future<void> downloadPDF(String pdfPath) async {
    try {
      // Read the local file
      var file = File(pdfPath);

      // Check if the file exists
      if (await file.exists()) {
        // Get the application documents directory
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String documentsPath = appDocDir.path;

        // Extract the file name from the path
        String fileName = pdfPath.split('/').last;

        // Create a new file path in the documents directory
        String filePath = '$documentsPath/$fileName';

        // Copy the file to the new path
        await file.copy(filePath);

        if (kDebugMode) {
          print('PDF downloaded to: $filePath');
        }
      } else {
        if (kDebugMode) {
          print('File not found: $pdfPath');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error downloading PDF: $e');
      }
    }
  }
}
