import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'video_player_screen.dart';

class LessonView extends StatefulWidget {
  final Map<String, dynamic> workout;

  const LessonView({super.key, required this.workout});

  @override
  _LessonViewState createState() => _LessonViewState();
}
class _LessonViewState extends State<LessonView>{
  String isAdmin = 'false';
  List<Map<String, dynamic>> lessons = [];
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _initializeState();
  }

  Future<void> _initializeState() async {
    await _checkIfAdmin();
    _loadLessons();
  }

  Future<void> _checkIfAdmin() async {
    try {
      final result = await apiService.checkTarget();
      setState(() {
        isAdmin = result;
      });
    } catch (e) {
      print('Failed to check admin status: $e');
    }
  }

  Future<void> _loadLessons() async {
    try {
      int pageNumber = 0;
      bool found = false;
      List<Map<String, dynamic>> allWorkouts = [];

      while (!found) {
        final response = isAdmin == 'admin' ? await apiService.adminGetAllOnlineTrainingProgram(pageNumber)
        : await apiService.getAllOnlineTrainingProgram(pageNumber);

        final workouts = List<Map<String, dynamic>>.from(response['content'] as List<dynamic>);

        allWorkouts.addAll(workouts);

        final workoutId = widget.workout['id'];
        final workout = workouts.firstWhere((w) => w['id'] == workoutId, orElse: () => {});

        if (workout.isNotEmpty) {
          final trainingLessons = workout['trainingLessons'] as List<dynamic>? ?? [];

          setState(() {
            lessons = List<Map<String, dynamic>>.from(trainingLessons);
          });
          found = true;
        } else {
          pageNumber++;
          if (workouts.isEmpty) {
            setState(() {
              lessons = [];
            });
            found = true;
          }
        }
      }
    } catch (e) {
      print('Failed to load lessons: $e');
      setState(() {
        lessons = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.lightGrey,
      appBar: AppBar(
        title: Text(
          widget.workout['title'],
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: lessons.isEmpty
          ? Center(
        child: Text(
          'No lessons available',
          style: GoogleFonts.inter(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: _loadLessons,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  lesson['title'],
                  style: GoogleFonts.inter(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(
                  lesson['description'],
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                  ),
                ),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => VideoPlayerDialog(url: lesson['url'], id: lesson['id'], isAdmin: isAdmin, onDelete: _loadLessons),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: isAdmin == 'admin'
          ? FloatingActionButton(
        onPressed: () {
          _showAddLessonDialog();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      )
          : null,
    );
  }

  void _showAddLessonDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    PlatformFile? selectedFile;
    String selectedFileName = 'No file selected';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add New Lesson'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Lesson Name'),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform.pickFiles(
                        type: FileType.any,
                      );
                      if (result != null) {
                        selectedFile = result.files.first;
                        setState(() {
                          selectedFileName = selectedFile!.name;
                        });
                      }
                    },
                    child: const Text('Select File'),
                  ),
                  SizedBox(height: 8.0), // Space between button and file name text
                  Text(selectedFileName), // Display the selected file name
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isNotEmpty &&
                        descriptionController.text.isNotEmpty &&
                        selectedFile != null) {
                      try {
                        await apiService.adminUploadLesson(
                          widget.workout['id'],
                          nameController.text,
                          descriptionController.text,
                          selectedFile!,
                        );
                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lesson uploaded successfully!')),
                        );
                        await _loadLessons();
                      } catch (e) {
                        print('Upload failed: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Upload failed: $e')),
                        );
                      }
                    } else {
                      print('Please fill all fields and select a file.');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields and select a file.')),
                      );
                    }
                  },
                  child: const Text('Upload'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}