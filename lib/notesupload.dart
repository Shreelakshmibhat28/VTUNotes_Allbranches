import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:file_picker/file_picker.dart';
import 'database.dart';
import 'databasehelperclass.dart';
import 'deptPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await NotesDatabaseHelper.instance.init();
  } catch (e) {
    print('Error initializing database: $e');
  }

  runApp(const MaterialApp(
    home: NoteUploadScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class NoteUploadScreen extends StatefulWidget {
  const NoteUploadScreen({super.key});

  @override
  State<NoteUploadScreen> createState() => _NoteUploadScreenState();
}

class _NoteUploadScreenState extends State<NoteUploadScreen> {
  final TextEditingController titleController = TextEditingController();
  String? pdfPath;
  String selectedYear = 'Year';
  String selectedScheme = 'Scheme';
  String selectedSemester = 'Semester';
  String selectedBranch = 'Branch';

  List<String> branches = ['Branch', 'CSE', 'ECE', 'MECH', 'CIV'];
  List<String> years = ['Year', '1', '2', '3', '4'];
  List<String> schemes = ['Scheme', '2018', '2021', '2022'];
  List<String> semesters = ['Semester', '1', '2', '3', '4', '5', '6', '7', '8'];

  Future<void> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        pdfPath = result.files.single.path!;
      });
    }
  }

  Future<void> uploadNote() async {
    final String title = titleController.text;

    if (title.isNotEmpty && pdfPath != null) {
      final Note note = Note(
        title: title,
        pdfPath: pdfPath!,
        branches: selectedBranch,
        year: selectedYear,
        scheme: selectedScheme,
        semester: selectedSemester,
      );

      await NotesDatabaseHelper.instance.init();
      final int result = await NotesDatabaseHelper.instance.insertNote(note);

      if (result > 0) {
        print('Note uploaded successfully!');
        await Future.delayed(const Duration(seconds: 2));

        // Fetch the note from the database
        List<Note> notes = await NotesDatabaseHelper.instance.getFilteredNotes(
          selectedYear,
          selectedScheme,
          selectedSemester,
          selectedBranch,
        );

        // Print or log the retrieved note
        if (notes.isNotEmpty) {
          print('Retrieved Note: ${notes.first.toMap()}');
        } else {
          print('Note not found in the database.');
        }
      } else {
        print('Failed to upload note.');
      }
    } else {
      print('Title and PDF path cannot be empty.');
    }
    clearForm();
  }


  void clearForm() {
    print('\nclear from');
    setState(() {
      titleController.clear();
      pdfPath = null;
      selectedBranch = 'Branch';
      selectedYear = 'Year';
      selectedScheme = 'Scheme';
      selectedSemester = 'Semester';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Note Upload'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 5.0, left: 5, right: 5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 16.0),
                        _buildDropdown('Select Branch', branches, selectedBranch,
                                (value) {
                              setState(() {
                                selectedBranch = value!;
                              });
                            }),
                        const SizedBox(height: 16.0),
                        _buildDropdown('Select Year', years, selectedYear, (value) {
                          setState(() {
                            selectedYear = value!;
                          });
                        }),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Column(
                      children: [
                        const SizedBox(height: 16.0),
                        _buildDropdown('Select Scheme', schemes, selectedScheme,
                                (value) {
                              setState(() {
                                selectedScheme = value!;
                              });
                            }),
                        const SizedBox(height: 16.0),
                        _buildDropdown('Select Semester', semesters, selectedSemester,
                                (value) {
                              setState(() {
                                selectedSemester = value!;
                              });
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Container(
                height: 100,width: 300,
                child: TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title',border: OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: pickPDF,
                child: const Text('Pick PDF',style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: 8.0),
              if (pdfPath != null)
                Text(
                  'Selected PDF: ${basename(pdfPath!)}',
                  style: const TextStyle(fontSize: 16.0),
                ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: uploadNote,
                child: const Text('Upload Note',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
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
}