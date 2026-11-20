import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

Widget buildVimeoPlayer({
  required String vimeoId,
  required double width,
  required double height,
}) {
  return VimeoMobilePlayer(vimeoId: vimeoId, width: width, height: height);
}

class VimeoMobilePlayer extends StatefulWidget {
  final String vimeoId;
  final double width;
  final double height;

  const VimeoMobilePlayer({
    super.key,
    required this.vimeoId,
    required this.width,
    required this.height,
  });

  @override
  State<VimeoMobilePlayer> createState() => _VimeoMobilePlayerState();
}

class _VimeoMobilePlayerState extends State<VimeoMobilePlayer> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            debugPrint('Vimeo web resource error: ${error.description}');
            if (mounted) setState(() => _isLoading = false);
          },
        ),
      );

    if (_controller.platform is AndroidWebViewController) {
      final androidController = _controller.platform as AndroidWebViewController;
      androidController.setMediaPlaybackRequiresUserGesture(false);
    }

    // Safety timeout: ensure the spinner never blocks or spins indefinitely
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted && _isLoading) {
        setState(() => _isLoading = false);
      }
    });

    final html = '''
<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
  <style>
    html, body {
      margin: 0;
      padding: 0;
      width: 100%;
      height: 100%;
      background-color: #000000;
      overflow: hidden;
      display: flex;
      align-items: center;
      justify-content: center;
    }
    iframe {
      width: 100%;
      height: 100%;
      border: none;
    }
  </style>
</head>
<body>
  <iframe
    src="https://player.vimeo.com/video/${widget.vimeoId}?autoplay=1&muted=0&playsinline=1&badge=0&autopause=0&player_id=0&app_id=58479&dnt=1&byline=0&portrait=0&title=0"
    allow="autoplay; fullscreen; picture-in-picture"
    allowfullscreen>
  </iframe>
</body>
</html>
''';

    _controller.loadHtmlString(html, baseUrl: 'https://christembassyfarmersbranch.org');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const IgnorePointer(
              ignoring: true,
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFCC0000),
                  strokeWidth: 3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

