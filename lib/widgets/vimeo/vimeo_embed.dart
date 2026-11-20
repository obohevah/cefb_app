import 'package:flutter/material.dart';
import 'vimeo_embed_stub.dart'
    if (dart.library.js_interop) 'vimeo_embed_web.dart' as impl;

class VimeoEmbedPlayer extends StatelessWidget {
  final String vimeoId;
  final double width;
  final double height;

  const VimeoEmbedPlayer({
    super.key,
    required this.vimeoId,
    this.width = double.infinity,
    this.height = 220,
  });

  @override
  Widget build(BuildContext context) {
    return impl.buildVimeoPlayer(
      vimeoId: vimeoId,
      width: width,
      height: height,
    );
  }
}
