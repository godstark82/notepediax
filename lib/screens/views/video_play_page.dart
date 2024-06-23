// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:course_app/models/course_model.dart';
import 'package:course_app/screens/views/pdf_view_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flexivideoplayer/flexivideoplayer.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerView extends StatefulWidget {
  const VideoPlayerView(
      {super.key, required this.chapter, required this.index});
  final Chapter chapter;
  final int index;

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  FlexiController? _FlexiController;
  late TabController tabController;
  bool isSourceError = false;

  @override
  void initState() {
    super.initState();
    initializePlayer();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _FlexiController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    setState(() {
      isSourceError = false;
    });
    try {
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(
          'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'));

      await _videoPlayerController.initialize();

      _FlexiController = FlexiController(
        aspectRatio: 16 / 9,
        deviceOrientationsOnEnterFullScreen: [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight
        ],
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
        allowFullScreen: true,
        showControlsOnInitialize: true,
        autoInitialize: true,

        fullScreenByDefault: false,
        allowedScreenSleep: false,
        videoPlayerController: _videoPlayerController,
        autoPlay: false,
        looping: false,
        errorBuilder: (context, errorMessage) {
          debugPrint("Error find : $errorMessage");
          return Center(
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
        additionalOptions: (context) {
          return <OptionItem>[
            OptionItem(
              onTap: toggleVideo,
              iconData: Icons.live_tv_sharp,
              title: 'Toggle Video Src',
            ),
          ];
        },
        hideControlsTimer: const Duration(seconds: 3),
        // Try playing around with some of these other options:
        isBrignessOptionDisplay: false,
        isVolumnOptionDisplay: true,

        cupertinoProgressColors: FlexiProgressColors(
          playedColor: Colors.red,
          handleColor: Colors.red,
          backgroundColor: Colors.grey,
          bufferedColor: Colors.white.withOpacity(0.5),
        ),
      );

      setState(() {});
    } catch (exception) {
      setState(() {
        isSourceError = true;
      });
      debugPrint("exception : $exception");
    }
  }

  Future<void> toggleVideo() async {
    await initializePlayer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          
          title: Text(
            widget.chapter.lectures![widget.index].name,
            style:Theme.of(context).textTheme.titleMedium,
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.black,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: isSourceError
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Icon(
                              CupertinoIcons.exclamationmark_circle,
                              color: Colors.white,
                              size: 30,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'This video is unavailable',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                            InkWell(
                              onTap: () {
                                initializePlayer();
                              },
                              child: Container(
                                height: 30,
                                width: 100,
                                alignment: Alignment.center,
                                child: Text(
                                  "Reload again",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 13),
                                ),
                              ),
                            )
                          ])
                    : _FlexiController != null
                        ?
                        // &&
                        //        _FlexiController!
                        //            .videoPlayerController.value.isInitialized
                        //        ?
                        Flexi(
                            controller: _FlexiController!,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                                CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.red,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Loading',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(widget.chapter.lectures![widget.index].name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Text(
                'Chapter: ${widget.chapter.name}',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TabBar(controller: tabController, tabs: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Notes'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Assignments'),
              )
            ]),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  ListView.builder(
                    itemCount: widget.chapter.notes?.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                            leading: Icon(Icons.book),
                            title: Text(
                                widget.chapter.notes![index].name.toString()),
                            subtitle: Text('Notes of this lecture'),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) => PdfViewPage(
                                          pdf: widget.chapter.notes![index])));
                            }),
                      );
                    },
                  ),
                  // Assignments
                  ListView.builder(
                    itemCount: widget.chapter.assignments?.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: Icon(Icons.book),
                          title: Text(widget.chapter.assignments![index].name
                              .toString()),
                          subtitle: Text('Assignment of this lecture'),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => PdfViewPage(
                                        pdf: widget.chapter.notes![index])));
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
