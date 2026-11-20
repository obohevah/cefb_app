import 'package:flutter/material.dart';
import '../services/translation_service.dart';

/// A simple, lightweight StatelessWidget that automatically updates its text
/// whenever the user changes the app language.
class TranslatedText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const TranslatedText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: TranslationService.instance.currentLanguage,
      builder: (context, lang, _) {
        if (lang == 'en') {
          return Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
        }

        // Check if translated synchronously via dictionary or cache
        final cached = TranslationService.instance.translateSync(text);
        if (cached != text) {
          return Text(
            cached,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          );
        }

        // Asynchronously translate longer text
        return FutureBuilder<String>(
          future: TranslationService.instance.translateAsync(text),
          initialData: text,
          builder: (context, snapshot) {
            return Text(
              snapshot.data ?? text,
              style: style,
              textAlign: textAlign,
              maxLines: maxLines,
              overflow: overflow,
            );
          },
        );
      },
    );
  }
}
