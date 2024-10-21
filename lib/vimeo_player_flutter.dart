library vimeo_player_flutter;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

///vimeo player for Flutter apps
///Flutter plugin based on the [webview_flutter] plugin
///[videoId] is the only required field to use this plugin
///
///
///
///
class VimeoPlayer extends StatefulWidget {
  final int? width;
  final int? height;
  const VimeoPlayer({
    Key? key,
    required this.videoId,
    this.width,
    this.height,
  }) : super(key: key);

  final String videoId;

  @override
  State<VimeoPlayer> createState() => _VimeoPlayerState();
}

class _VimeoPlayerState extends State<VimeoPlayer> {
  final _controller = WebViewController();

  @override
  void initState() {
    _controller
      ..loadRequest(_videoPage(widget.videoId, widget.width, widget.height))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: _controller,
    );
  }

  ///web page containing iframe of the vimeo video
  ///
  ///
  ///
  ///
  Uri _videoPage(String videoId, int? width, int? height) {
    var w = width != null ? '${width}px' : "100%";
    var h = height != null ? '${height}px' : "100%";
    final html = '''
            <html>
              <head>
                <style>
                  body {
                   background-color: lightgray;
                   margin: 0px;
                   }
                </style>
                <meta name="viewport" content="initial-scale=1.0, maximum-scale=1.0">
                <meta http-equiv="Content-Security-Policy" 
                content="default-src * gap:; script-src * 'unsafe-inline' 'unsafe-eval'; connect-src *; 
                img-src * data: blob: android-webview-video-poster:; style-src * 'unsafe-inline';">
             </head>
             <body>
                <iframe 
                src="https://player.vimeo.com/video/$videoId?loop=0&autoplay=1" 
                width="$w" height="$h" frameborder="0" allow="fullscreen" 
                allowfullscreen></iframe>
             </body>
            </html>
            ''';
    final String contentBase64 =
        base64Encode(const Utf8Encoder().convert(html));
    return Uri.parse('data:text/html;base64,$contentBase64');
  }
}
