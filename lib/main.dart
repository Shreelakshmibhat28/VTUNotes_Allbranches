import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'databasehelperclass.dart';
import 'deptPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized.

  // Initialize the database
  await  NotesDatabaseHelper.instance.init();
  runApp(const MaterialApp(
    home: EngiNotesHub(),
    debugShowCheckedModeBanner: false,
  ));
}

class EngiNotesHub extends StatefulWidget {
  const EngiNotesHub({Key? key}) : super(key: key);

  @override
  State<EngiNotesHub> createState() => _EngiNotesHubState();
}

class _EngiNotesHubState extends State<EngiNotesHub> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void validateField() {
    print('Inside validate');
    if (_formKey.currentState == null) {
      print('Form state is null');
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (context == null) {
        if (kDebugMode) {
          print('Context is null');
        }
        return;
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const DeptPage()));
    } else {
      print('Login failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Login')),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Colors.deepPurple, Colors.blueAccent])),
          child: Column(
            children: [
              Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: Image.asset(
                    'assets/Engi.png',
                    height: MediaQuery.of(context).size.height * 0.3,

                  )),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40))),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 50, bottom: 5, left: 20, right: 20),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Student Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your student email';
                              }
                              RegExp emailRegExp = RegExp(
                                r'^[a-zA-Z]+\.(19|20|21)(ec|cs|me|cv)\d{3}@sode-edu\.in$',
                              );
                              if (!emailRegExp.hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 5, left: 20, right: 20),
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                              labelText: 'Student Usn',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your student Usn';
                              }
                              RegExp usnRegExp = RegExp(
                                r'^4MW(19|20|21)(EC|CS|ME|CV)\d{3}$',
                              );
                              if (!usnRegExp.hasMatch(value)) {
                                return 'Please enter a valid Usn';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 10),
                          child: Container(
                            decoration: BoxDecoration(gradient: const LinearGradient(colors: [Colors.deepPurple,Colors.blueAccent]),borderRadius: BorderRadius.circular(15)),
                            child: ElevatedButton(
                              onPressed: validateField,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent),
                              child:  const Text(
                                'Login',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}