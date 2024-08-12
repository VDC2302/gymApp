import 'package:flutter/material.dart';
import 'package:gymApp/src/shared/api/api_service.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoPlayerDialog extends StatefulWidget {
  final String url;
  final int id;
  final String isAdmin;
  final VoidCallback onDelete;

  const VideoPlayerDialog({super.key, required this.url, required this.id, required this.isAdmin, required this.onDelete});

  @override
  _VideoPlayerDialogState createState() => _VideoPlayerDialogState();
}

class _VideoPlayerDialogState extends State<VideoPlayerDialog> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    _videoPlayerController.initialize().then((_) {
      setState(() {});
      _videoPlayerController.play();
    });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      // Allow full screen
      allowFullScreen: true,
    );
  }

  Future<void> _deleteVideo() async {
    try {
      await apiService.adminDeleteLesson(widget.id.toString());
      widget.onDelete;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lesson deleted successfully!')),
      );
    } catch (e) {
      print('Delete failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Delete failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: AspectRatio(
        aspectRatio: _videoPlayerController.value.aspectRatio,
        child: Chewie(
          controller: _chewieController!,
        ),
      ),
      actions: [
        if (widget.isAdmin == 'admin')
          ElevatedButton(
            onPressed: _deleteVideo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white
            ),
            child: const Text('Delete'),
          ),
        ElevatedButton(
          onPressed: () {
            _videoPlayerController.pause();
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white
          ),
          child: const Text('Close'),
        ),
      ],
    );
  }
}