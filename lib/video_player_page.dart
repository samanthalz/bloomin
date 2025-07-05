import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'quiz_page.dart';
import 'quiz_data.dart'; // New: to get hardcoded quizzes

class VideoPlayerPage extends StatefulWidget {
  final String videoId;
  final String videoTitle;

  const VideoPlayerPage({
    required this.videoId,
    required this.videoTitle,
    super.key,
  });

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late YoutubePlayerController _controller;
  bool _showQuizButton = false;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.pause();
    _controller.dispose();
    super.dispose();
  }

  void _launchQuiz() {
    final quiz = quizList.first; // For now, always show the first quiz

    Navigator.push(
      context,
        MaterialPageRoute(builder: (_) => QuizPage(quiz: quiz)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4D7),
      appBar: AppBar(
        title: Text(
          widget.videoTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: const Color(0xFFF89BA3),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          YoutubePlayerBuilder(
            player: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              onEnded: (_) {
                setState(() => _showQuizButton = true);
              },
            ),
            builder: (context, player) => Center(child: player),
          ),
          if (_showQuizButton)
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton.extended(
                backgroundColor: const Color(0xFF9F7BFF),
                icon: const Icon(Icons.quiz),
                label: const Text("Quiz Me!"),
                onPressed: _launchQuiz,
              ),
            ),
        ],
      ),
    );
  }
}
