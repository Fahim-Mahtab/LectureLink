import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_link/app/app_theme.dart';
import 'package:lecture_link/data/models/student_model.dart';
import 'package:lecture_link/providers/student_provider.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  static const String routeName = 'add-student';

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _sidController = TextEditingController();
  Student? _editingStudent;
  String _courseId = '';
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final arg = ModalRoute.of(context)?.settings.arguments;
      if (arg is Student) {
        _editingStudent = arg;
        _nameController.text = arg.name;
        _sidController.text = arg.studentId;
        _courseId = arg.courseId;
      } else if (arg is Map && arg.containsKey('courseId')) {
        _courseId = arg['courseId'] as String;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _sidController.dispose();
    super.dispose();
  }

  void _saveStudent() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final sid = _sidController.text.trim();
      final studentProvider = Provider.of<StudentProvider>(context, listen: false);

      if (_editingStudent != null) {
        studentProvider.updateStudent(
          id: _editingStudent!.id,
          name: name,
          studentId: sid,
        );
      } else {
        studentProvider.addStudent(
          name: name,
          studentId: sid,
          courseId: _courseId,
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingStudent != null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(isEditing ? "Edit Student" : "Add Student"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                const Text(
                  "Full Name",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Please enter student name"
                      : null,
                  decoration: const InputDecoration(
                    hintText: "e.g. Arham Shaikh",
                    prefixIcon: Icon(Icons.person, color: Color(0xFF94A3B8), size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                // Student ID
                const Text(
                  "Student ID",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _sidController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Please enter student ID"
                      : null,
                  decoration: const InputDecoration(
                    hintText: "e.g. 2021-CSE-001",
                    prefixIcon: Icon(Icons.badge, color: Color(0xFF94A3B8), size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                // Format Hint
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "ID format",
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "YYYY-DEPT-NNN (e.g. 2021-CSE-001)",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF0F172A),
                          fontFamily: 'monospace',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveStudent,
                    icon: const Icon(Icons.check),
                    label: Text(isEditing ? "Update Student" : "Save Student"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
