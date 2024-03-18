import 'package:flutter/material.dart';
import 'package:livestream_example/livestream_page.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class EducatorHomePage extends StatefulWidget {
  final String userId;
  final String userToken;
  const EducatorHomePage({
    super.key,
    required this.userId,
    required this.userToken,
  });

  @override
  State<EducatorHomePage> createState() => _EducatorHomePageState();
}

class _EducatorHomePageState extends State<EducatorHomePage> {
  late StreamVideo _streamClient;

  @override
  void initState() {
    super.initState();
    _streamClient = StreamVideo(
      'API_KEY',
      userToken: widget.userToken,
      user: User(
        info: UserInfo(
          id: widget.userId,
          role: 'admin',
        ),
      ),
    )..connect();
  }

  Future<void> _createLivestream() async {
    final call = _streamClient.makeCall(
      type: 'livestream',
      id: 'first_room',
      preferences: DefaultCallPreferences(
        connectTimeout: const Duration(seconds: 60),
        dropIfAloneInRingingFlow: true,
      ),
    );

    // Set some default behaviour for how our devices should be configured once we join a call
    call.connectOptions = CallConnectOptions(
      camera: TrackOption.enabled(),
      microphone: TrackOption.enabled(),
    );

    final result = await call.getOrCreate(memberIds: ['student']);
    await call.addMembers([
      const UserInfo(id: 'student', role: 'call_member')
    ]); // Call object is created
    if (result.isSuccess) {
      await call
          .join(); // Our local app user is able to join and recieve events from the call
      await call.goLive(); // Allow others to see and joing the call

      print('Joining the call : ${call.id}');

      // Navigate to the Livestream page and pass the call object
      Navigator.of(context).push(LiveStreamScreen.route(call));
    } else {
      debugPrint('Not able to create a call.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _createLivestream(),
              child: const Text('Create a Livestream'),
            ),
          ],
        ),
      ),
    );
  }
}
