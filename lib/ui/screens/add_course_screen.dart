import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lecture_link/app/app_theme.dart';
import 'package:lecture_link/data/models/course_model.dart';
import 'package:lecture_link/providers/course_provider.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  static const String routeName = 'add-course';

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  Course? _editingCourse;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final courseArg = ModalRoute.of(context)?.settings.arguments;
      if (courseArg != null && courseArg is Course) {
        _editingCourse = courseArg;
        _nameController.text = courseArg.name;
        _codeController.text = courseArg.code;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    super.dispose();
  }

  void _saveCourse() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final code = _codeController.text.trim();
      final courseProvider = Provider.of<CourseProvider>(context, listen: false);

      if (_editingCourse != null) {
        courseProvider.updateCourse(
          id: _editingCourse!.id,
          name: name,
          code: code,
        );
      } else {
        courseProvider.addCourse(
          name: name,
          code: code,
        );
      }

      Navigator.pop(context);
    }
  }

  void _deleteCourse() {
    if (_editingCourse != null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Delete Course"),
          content: Text("Are you sure you want to delete '${_editingCourse!.name}'?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Provider.of<CourseProvider>(context, listen: false)
                    .deleteCourse(_editingCourse!.id);
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Return to previous screen
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _editingCourse != null;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(isEditing ? "Edit Course" : "Add Course"),
        actions: isEditing
            ? [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: _deleteCourse,
                ),
              ]
            : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 18),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Fill in the course details. The course code should be unique and match your university's format.",
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xFF1D4ED8),
                            height: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Course Name Field
                const Text(
                  "Course Name",
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
                      ? "Please enter course name"
                      : null,
                  decoration: const InputDecoration(
                    hintText: "e.g. Database Management Systems",
                    prefixIcon: Icon(Icons.menu_book, color: Color(0xFF94A3B8), size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                // Course Code Field
                const Text(
                  "Course Code",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF475569),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _codeController,
                  validator: (val) => val == null || val.trim().isEmpty
                      ? "Please enter course code"
                      : null,
                  decoration: const InputDecoration(
                    hintText: "e.g. CSE-301",
                    prefixIcon: Icon(Icons.tag, color: Color(0xFF94A3B8), size: 20),
                  ),
                ),
                const SizedBox(height: 16),

                // Format Examples
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
                        "Example formats",
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "CSE-301 · MTH-201 · PHY-101",
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
                    onPressed: _saveCourse,
                    icon: const Icon(Icons.check),
                    label: Text(isEditing ? "Update Course" : "Save Course"),
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

                if (isEditing) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _deleteCourse,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text("Delete Course"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        backgroundColor: const Color(0xFFFEF2F2),
                        side: const BorderSide(color: Color(0xFFFECACA)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
