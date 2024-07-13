part of '../read_morex.dart';

class ReadMoreX extends StatefulWidget {
  /// The text content to be displayed.
  final String content;

  /// The label to display when showing more content.
  final String? readMoreLabel;

  /// The label to display when showing less content.
  final String? showLessLabel;

  /// The font weight for the labels.
  final FontWeight? fontWeightLabel;

  /// The maximum number of lines to display before showing the "Read more" link.
  /// Default value is 3 if not specified.
  final int? maxLine;

  /// The maximum length of the text before truncation.
  /// Default value is 160 if not specified.
  final int? maxLength;

  /// The style to apply to the text.
  final TextStyle? textStyle;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// Whether to filter the content using custom patterns.
  final bool filterContent;

  /// Custom filters to apply to the content using patterns.
  ///
  /// Example:
  /// ```dart
  /// customFilter: [
  ///   ReadMoreXPattern(
  ///     pattern: r'github.com',
  ///     valueChanged: (value) => value?.replaceFirst('https://github.com/', 'Github '),
  ///     onTap: (value) {
  ///       ScaffoldMessenger.of(context).showSnackBar(
  ///         SnackBar(content: Text('This Link $value')),
  ///       );
  ///     },
  ///   ),
  ///   ReadMoreXPattern(
  ///     pattern: r'https://', // https Pattern
  ///     onTap: (value) {
  ///       ScaffoldMessenger.of(context).showSnackBar(
  ///         SnackBar(content: Text('This Link $value')),
  ///       );
  ///     },
  ///   ),
  ///   ReadMoreXPattern(
  ///     pattern: r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b', // Email Pattern
  ///     colorChanged: Colors.deepPurple,
  ///     onTap: (value) {
  ///       ScaffoldMessenger.of(context).showSnackBar(
  ///         SnackBar(content: Text('This Email $value')),
  ///       );
  ///     },
  ///   ),
  /// ],
  /// ```
  ///
  final List<ReadMoreXPattern>? customFilter;

  /// The color to use for filtered content.
  final Color? readMoreColor;

  /// The [ReadMoreX] widget is designed to display text content with the option to expand and collapse it.
  /// It allows you to set a maximum number of lines and a maximum length for the text.
  /// When the content exceeds these limits, it provides a 'Read more' link, allowing users to see
  /// the full content, and a 'Show less' link to collapse it again. You can also apply custom text filters
  /// using regular expressions to highlight or modify specific patterns within the text.
  /// This widget offers flexibility and control over how text content is displayed and filtered within your Flutter app.
  const ReadMoreX(
    this.content, {
    super.key,
    this.readMoreLabel,
    this.showLessLabel,
    this.fontWeightLabel,
    this.maxLine,
    this.maxLength,
    this.textStyle,
    this.textAlign,

    /// Set this to true if you want to filter the content using custom patterns.
    this.filterContent = false,

    /// Specify custom filters to apply to the content using patterns.
    this.customFilter,

    /// The color to use for filtered content.
    this.readMoreColor,
  });

  @override
  State<ReadMoreX> createState() => _ReadMoreXState();
}

class _ReadMoreXState extends State<ReadMoreX> {
  bool isReadMore = false;
  String pNewline = r' @@newLine@@=> ';
  String pNewTab = r' @@newTab@@=> ';
  String pSpace = r' ';

  late String content;
  late String readMoreLabel;
  late String showLessLabel;
  late FontWeight fontWeightLabel;
  late int maxLine;
  late int maxLength;
  late TextStyle textStyle;
  TextAlign? textAlign;
  late bool filterContent;
  late List<ReadMoreXPattern> customFilter;
  late Color readMoreColor;

  @override
  void initState() {
    super.initState();
    _updateParameters();
  }

  @override
  void didUpdateWidget(covariant ReadMoreX oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.content != oldWidget.content ||
        widget.readMoreLabel != oldWidget.readMoreLabel ||
        widget.showLessLabel != oldWidget.showLessLabel ||
        widget.fontWeightLabel != oldWidget.fontWeightLabel ||
        widget.maxLine != oldWidget.maxLine ||
        widget.maxLength != oldWidget.maxLength ||
        widget.textStyle != oldWidget.textStyle ||
        widget.textAlign != oldWidget.textAlign ||
        widget.filterContent != oldWidget.filterContent ||
        widget.customFilter != oldWidget.customFilter ||
        widget.readMoreColor != oldWidget.readMoreColor) {
      _updateParameters();
    }
  }

  void _updateParameters() {
    content = widget.content;
    readMoreLabel = widget.readMoreLabel ?? '...Read more';
    showLessLabel = widget.showLessLabel ?? 'Show less';
    fontWeightLabel = widget.fontWeightLabel ?? FontWeight.w600;
    maxLine = widget.maxLine ?? 3;
    maxLength = widget.maxLength ?? 160;
    textStyle = widget.textStyle ?? const TextStyle();
    textAlign = widget.textAlign;
    filterContent = widget.filterContent;
    customFilter = widget.customFilter ?? [];
    readMoreColor = widget.readMoreColor ?? const Color(0xFF2196F3);
  }

  List<InlineSpan> get textSpanChildren {
    if (filterContent) {
      return maximumWords(
        filter(
          filterPattern(
            filterLineAndLength(content),
          ).trim(),
        ),
      );
    } else {
      return maximumWords(
        [TextSpan(text: filterLineAndLength(content))],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: textStyle,
      textAlign: textAlign,
      TextSpan(
        children: textSpanChildren,
      ),
    );
  }

  List<InlineSpan> maximumWords(List<InlineSpan> listSpan) {
    List<InlineSpan> result = listSpan;
    final List<String> splitLine = content.split('\n');
    if (content.length > (maxLength < 1 ? 1 : maxLength) ||
        splitLine.length >= (maxLine < 1 ? 1 : maxLine)) {
      result.add(
        WidgetSpan(
          child: GestureDetector(
            onTap: () => setState(() => isReadMore = !isReadMore),
            child: Text(
              isReadMore ? showLessLabel : readMoreLabel,
              style: textStyle.copyWith(
                color: readMoreColor,
                fontWeight: fontWeightLabel,
              ),
            ),
          ),
        ),
      );
    }
    return result;
  }

  String filterLineAndLength(String data) {
    String result = '';
    if (!isReadMore) {
      final List<String> splitLine = data.split('\n');
      final bool isMaxLength = data.length > (maxLength < 1 ? 1 : maxLength);
      final bool isMaxLine = splitLine.length >= (maxLine < 1 ? 1 : maxLine);
      if (isMaxLength) {
        result = data.substring(0, maxLength);
      } else if (isMaxLine) {
        final words = '${splitLine[0]}${splitLine[1]}${splitLine[2]}';
        result = data.substring(0, words.length);
      } else {
        result = data;
      }
    } else {
      result = data;
    }
    return result;
  }

  List<InlineSpan> filter(String data) {
    List<InlineSpan> listSpan = [];
    List<String> splitSpace = data.split(pSpace);
    for (int i = 0; i < splitSpace.length; i++) {
      final word = splitSpace[i];
      final match = RegExp(r'@@(.*?)@@=>').firstMatch(word);
      if (match == null) {
        listSpan.add(TextSpan(text: '$word '));
      } else {
        if (pNewline.contains(match.group(0)!)) listSpan.add(const TextSpan(text: '\n'));
        if (pNewTab.contains(match.group(0)!)) listSpan.add(const TextSpan(text: '\t'));
        for (ReadMoreXPattern pattern in customFilter) {
          if ('@@${pattern.pattern}@@=>'.contains(match.group(0)!)) {
            final contentWord = word.replaceFirst(match.pattern, '');
            final hasValueChanged =
                pattern.valueChanged != null && pattern.valueChanged!.call(contentWord)!.isNotEmpty;
            listSpan.add(
              WidgetSpan(
                child: GestureDetector(
                  onTap: () {
                    if (isReadMore) {
                      pattern.onTap?.call(contentWord);
                    } else {
                      setState(() => isReadMore = !isReadMore);
                    }
                  },
                  child: Text(
                    hasValueChanged
                        ? '${pattern.valueChanged?.call(contentWord)} '
                        : '$contentWord ',
                    style: textStyle.copyWith(
                      color: pattern.colorChanged ?? readMoreColor,
                      decoration: pattern.textDecoration,
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }
    }
    return listSpan;
  }

  String filterPattern(String data) {
    String result = '';
    if (customFilter.isNotEmpty) {
      String rep = data.replaceAll(RegExp(r'\n'), pNewline);
      rep = rep.replaceAll(RegExp(r'\t'), pNewTab);
      for (var i = 0; i < customFilter.length; i++) {
        if (i < 1) {
          result = _filterPattern(rep, customFilter[i]);
        } else {
          result = _filterPattern(result, customFilter[i]);
        }
      }
    }
    return result;
  }

  String _filterPattern(String data, ReadMoreXPattern patterns) {
    final splitSpace = data.split(pSpace);
    final res = List.generate(
      splitSpace.length,
      (index) {
        final word = splitSpace[index];
        if (!word.contains(RegExp(patterns.pattern))) {
          return '$word$pSpace';
        } else if (word.contains(RegExp(pNewline)) || word.contains(RegExp(pNewTab))) {
          return '$word$pSpace';
        } else {
          if (word.contains(RegExp(r'@@(.*?)@@=>'))) {
            return '$word$pSpace';
          } else {
            return '@@${patterns.pattern}@@=>$word$pSpace';
          }
        }
      },
    );
    return res.join();
  }
}
