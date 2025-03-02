import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_example/screens/student_form.dart';
import '../providers/student_database.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Students")),
      body: SafeArea(
        child: FutureBuilder<void>(
          future: context.read<StudentProvider>().fetchStudents(),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

                              // Right-aligned Delete Icon
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => studentProvider.showDeleteDialog(student.id, context),
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
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StudentForm()),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
