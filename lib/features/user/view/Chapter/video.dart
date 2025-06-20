import 'package:core_book/core/styles/themes.dart';
import 'package:core_book/core/widgets/ScreenCaptureProtection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoScreen extends StatefulWidget {
  final String url;

  const VideoScreen({super.key, required this.url});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    ScreenCaptureProtection.enable();

    final videoId = YoutubePlayer.convertUrlToId(widget.url);
    if (videoId == null) {
      throw 'رابط الفيديو غير صالح';
    }
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        controlsVisibleAtStart: true,
      ),
    );
  }

  Future<void> resetOrientation() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    resetOrientation();
    _controller.dispose();
    ScreenCaptureProtection.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await resetOrientation();
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
              progressColors: ProgressBarColors(
                playedColor: primaryColor,
                handleColor: primaryColor,
                bufferedColor: Colors.grey,
                backgroundColor: Colors.white,
              ),
              progressIndicatorColor: primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
