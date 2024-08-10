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
  bool isAdmin = false;
  ApiService apiService = ApiService();

  Future<void> _checkIfAdmin() async {
    try {
      final result = await apiService.checkTarget();
      setState(() {
        isAdmin = result == 'admin';
      });
    } catch (e) {
      print('Failed to check admin status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lessons = List<Map<String, dynamic>>.from(widget.workout['trainingLessons']);

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
          : ListView.builder(
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
                  builder: (context) => VideoPlayerDialog(url: lesson['url']),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: isAdmin
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New Lesson')
        );
      },
    );
  }
}