import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymApp/src/shared/shared.dart';
import 'video_player_screen.dart';

class LessonView extends StatelessWidget {
  final Map<String, dynamic> workout;

  const LessonView({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lessons = List<Map<String, dynamic>>.from(workout['trainingLessons']);

    return Scaffold(
      backgroundColor: appColors.lightGrey,
      appBar: AppBar(
        title: Text(
          workout['title'],
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
    );
  }
}