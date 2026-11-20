// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

final Set<String> _registeredVimeoIds = {};

Widget buildVimeoPlayer({
  required String vimeoId,
  required double width,
  required double height,
}) {
  final viewType = 'vimeo-embed-$vimeoId';

  if (!_registeredVimeoIds.contains(vimeoId)) {
    ui_web.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) {
        final iframe = web.HTMLIFrameElement();
        iframe.src =
            'https://player.vimeo.com/video/$vimeoId?badge=0&autopause=0&player_id=0&app_id=58479&dnt=1&byline=0&portrait=0&title=0';
        iframe.style.border = 'none';
        iframe.style.width = '100%';
        iframe.style.height = '100%';
        iframe.allow = 'autoplay; fullscreen; picture-in-picture';
        return iframe;
      },
    );
    _registeredVimeoIds.add(vimeoId);
  }

  return SizedBox(
    width: width,
    height: height,
    child: HtmlElementView(viewType: viewType),
  );
}
