import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'app_bar.dart';
// import 'custom_ui.dart';

class VideoScreen extends StatefulWidget {
  final String url;

  VideoScreen({@required this.url});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  final FijkPlayer player = FijkPlayer();
  var _snapshot = null;

  _VideoScreenState();

  @override
  void initState() {
    super.initState();
    player.setOption(FijkOption.hostCategory, "enable-snapshot", 1);
    player.setOption(FijkOption.playerCategory, "mediacodec-all-videos", 1);
    startPlay();
  }

  void startPlay() async {
    await player.setOption(FijkOption.hostCategory, "request-screen-on", 1);
    await player.setOption(FijkOption.hostCategory, "request-audio-focus", 1);
    await player.setDataSource(widget.url, autoPlay: true).catchError((e) {
      print("setDataSource error: $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FijkAppBar.defaultSetting(title: "Video"),
      body: Container(
        child: Column(
          children: [
            Container(
              height: 300,
              child: FijkView(
                player: player,
                panelBuilder: fijkPanel2Builder(snapShot: true),
                fsFit: FijkFit.fill,
                // panelBuilder: simplestUI,
                // panelBuilder: (FijkPlayer player, BuildContext context,
                //     Size viewSize, Rect texturePos) {
                //   return CustomFijkPanel(
                //       player: player,
                //       buildContext: context,
                //       viewSize: viewSize,
                //       texturePos: texturePos);
                // },
              ),
            ),

            /// 截屏
            MaterialButton(
              onPressed: () async {
                Uint8List list = await player.takeSnapShot();
                _snapshot = list;
                setState(() {});
              },
              color: Colors.lightBlue,
              child: Text('截屏'),
            ),

            /// 显示截屏
           _snapshot == null ? Text('无图') : Image.memory(_snapshot),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
