import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/student_database.dart';

class StudentForm extends StatefulWidget {
  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  final _courseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text("Add Student")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter age';
                  if (int.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) return 'Please enter email';
                  if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) return "Enter a valid email";
                  return null;
                },
              ),
              TextFormField(
                controller: _courseController,
                decoration: InputDecoration(labelText: 'Course'),
                validator: (value) => value!.isEmpty ? 'Please enter course' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final name = _nameController.text;
                    final age = int.parse(_ageController.text);
                    final email = _emailController.text;
                    final course = _courseController.text;

                    // Show loading indicator
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => Center(child: CircularProgressIndicator()),
                    );

                    await studentProvider.addStudent(name, age, email, course, context);
                    Navigator.of(context).pop(); // Close loading dialog
                    Navigator.of(context).pop(); // Go back to HomeScreen

                    _nameController.clear();
                    _ageController.clear();
                    _emailController.clear();
                    _courseController.clear();
                  }
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}