import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle? style;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool softWrap;
  final TextAlign? textAlign;

  const HighlightedText({
    super.key,
    required this.text,
    required this.query,
    this.style,
    this.overflow,
    this.maxLines,
    this.softWrap = true,
    this.textAlign
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(
        text,
        style: style,
        overflow: overflow,
        maxLines: maxLines,
        softWrap: softWrap,
        textAlign: textAlign
      );
    }

    final List<TextSpan> spans = [];
    final String lcText = text.toLowerCase(), lcQuery = query.toLowerCase();
    int startIndex = 0;

    while (true) {
      final int i = lcText.indexOf(lcQuery, startIndex);
      if (i == -1) {
        if (startIndex < text.length) spans.add(TextSpan(text: text.substring(startIndex)));
        break;
      }

      if (i > startIndex) spans.add(TextSpan(text: text.substring(startIndex, i)));

      spans.add(
        TextSpan(
          text: text.substring(i, i + query.length),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          )
        )
      );

      startIndex = i + query.length;
    }

    return RichText(
      text: TextSpan(
        style: style ?? DefaultTextStyle.of(context).style,
        children: spans
      ),
      overflow: overflow ?? TextOverflow.clip,
      maxLines: maxLines,
      softWrap: softWrap,
      textAlign: textAlign ?? TextAlign.start
    );
  }
}
