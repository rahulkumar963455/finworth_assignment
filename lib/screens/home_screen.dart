import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_example/screens/student_form.dart';
import '../providers/student_database.dart';
import '../models/student_model.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Students")),
      body: SafeArea(
        child: FutureBuilder<void>(
          future: context.read<StudentProvider>().fetchStudents(), // ✅ Fetch students once
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              return Consumer<StudentProvider>(
                builder: (context, studentProvider, child) {
                  return studentProvider.students.isEmpty
                      ? Center(child: Text("No Students Found"))
                      : ListView.builder(
                    padding: const EdgeInsets.all(10.0),
                    itemCount: studentProvider.students.length,
                    itemBuilder: (context, index) {
                      final student = studentProvider.students[index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            children: [
                              // Student Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name: ${student.name}",
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Email: ${student.email}",
                                      style: TextStyle(fontSize: 16, color: Colors.blue),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Age: ${student.age} years old",
                                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      "Course: ${student.course}",
                                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),

                              // Edit & Delete Icons
                              Column(
                                children: [
                                  // Edit Icon (Also Used for Update)
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StudentForm(student: student),
                                        ),
                                      ).then((_) {
                                        context.read<StudentProvider>().fetchStudents(); // ✅ Refresh data
                                      });
                                    },
                                  ),
                                  // Delete Icon
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      _showDeleteDialog(context, studentProvider, student.id);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentForm()),
          ).then((_) {
            context.read<StudentProvider>().fetchStudents(); // ✅ Refresh after returning from form
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // ✅ Show delete confirmation dialog
  void _showDeleteDialog(BuildContext context, StudentProvider studentProvider, String studentId) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Text("Delete Student"),
        content: Text("Are you sure you want to delete this student?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              studentProvider.deleteStudent(studentId, context);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
