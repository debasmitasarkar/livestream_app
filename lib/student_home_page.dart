import 'package:flutter/material.dart';
import 'package:livestream_example/livestream_page.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class StudentPage extends StatefulWidget {
  final String userId;
  final String userToken;
  const StudentPage({super.key, required this.userId, required this.userToken});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  late final TextEditingController _controller;
  late StreamVideo _streamClient;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _streamClient = StreamVideo(
      'API_KEY',
      userToken: widget.userToken,
      user: User(
        info: UserInfo(
          id: widget.userId,
          role: 'user',
        ),
      ),
    )..connect();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _joinCall() async {
    final call =
        _streamClient.makeCall(type: 'livestream', id: _controller.text);
    await call.join();
    // Navigate to the livestream page
    Navigator.of(context).push(LiveStreamScreen.route(call));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home Page'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Enter your livestream ID',
                ),
                controller: _controller,
              ),
            ),
            ElevatedButton(
              onPressed: _joinCall,
              child: const Text('Join Livestream'),
            ),
          ],
        ),
      ),
    );
  }
}
