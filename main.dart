import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

void main() => runApp(VideoPlayerApp());
myprint1() {
  print("heloo everyone i m print function");
  var audio = AudioCache();
  audio.play('A.mp3');
}

class VideoPlayerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Player',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  VideoPlayerScreen({Key key}) : super(key: key);

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends State<VideoPlayerScreen> {
  VideoPlayerController controller;
  Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    var file = 'assets/video.mp4';
    controller = VideoPlayerController.asset(file);

    // Initialize the controller and store the Future for later use.
    initializeVideoPlayerFuture = controller.initialize();

    // Use the controller to loop the video.
    controller.setLooping(true);
    controller.setVolume(50.0);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Coding Master',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.greenAccent,
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: Stack(
        children: <Widget>[
          Center(
              child: FutureBuilder(
            future: initializeVideoPlayerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                // If the VideoPlayerController has finished initialization, use
                // the data it provides to limit the aspect ratio of the video.
                return AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  // Use the VideoPlayer widget to display the video.
                  child: VideoPlayer(controller),
                );
              } else {
                // If the VideoPlayerController is still initializing, show a
                // loading spinner.
                return Center(child: CircularProgressIndicator());
              }
            },
          )),
          Center(
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  // If the video is playing, pause it.
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    // If the video is paused, play it.
                    controller.play();
                  }
                });
              },
              child: Icon(
                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
            ),
          ),
          IconButton(
            icon: Icon(Icons.music_note),
            onPressed: myprint1,
            iconSize: 100.0,
          ),
          Text(
            "(For playing audio song frm system click on below logo)",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          new Padding(
            padding: EdgeInsets.all(10.0),
          ),
        ],
      ),
    );
  }
}
