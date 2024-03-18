import 'package:flutter/material.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';

class LiveStreamScreen extends StatelessWidget {
  static route(Call call) => MaterialPageRoute(
        builder: (context) {
          return LiveStreamScreen(currentStream: call);
        },
      );

  const LiveStreamScreen({
    super.key,
    required this.currentStream,
  });

  // The current call object
  final Call currentStream;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder(
        // StreamBuilder to listen to the call state
        stream: currentStream.state.valueStream,
        initialData: currentStream.state.value,
        builder: (context, snapshot) {
          final callState = snapshot.data!;
          if (callState.callParticipants.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final participant = callState.callParticipants
              .firstWhere((element) => element.isVideoEnabled);
          return Stack(
            children: [
              if (snapshot.hasData)
                StreamVideoRenderer(
                  call: currentStream,
                  videoTrackType: SfuTrackType.video,
                  participant: participant,
                ),
              if (!snapshot.hasData)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (snapshot.hasData && callState.status.isDisconnected)
                const Center(
                  child: Text('Stream not live'),
                ),
              Positioned(
                top: 12.0,
                left: 12.0,
                child: Material(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: Colors.red,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Viewers: ${callState.callParticipants.length}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // if the user is not the creator of the call and just viewer, show the leave call button
              if (callState.localParticipant?.userId !=
                  callState.createdByUserId)
                Positioned(
                  top: 12.0,
                  right: 12.0,
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: Colors.black,
                    child: GestureDetector(
                      onTap: () {
                        currentStream.leave();
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Leave Call',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              // if the user is the creator of the call, show the call controls
              if (callState.localParticipant?.userId == callState.createdByUserId)
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  child: StreamCallContainer(
                    call: currentStream,
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}
