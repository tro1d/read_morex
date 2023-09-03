part of read_morex;

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
    Key? key,
  }) : super(key: key);

  @override
  State<ReadMoreX> createState() => _ReadMoreXState();
}

class _ReadMoreXState extends State<ReadMoreX> {
  bool isReadMore = false;
  String patternNewline = ' @@newLine@@=> ';
  Pattern patternSpace = r' ';

  String content = '';
  String readMoreLabel = '';
  String showLessLabel = '';
  FontWeight fontWeightLabel = FontWeight.w600;
  int maxLine = 3;
  int maxLength = 160;
  TextStyle textStyle = const TextStyle();
  TextAlign? textAlign;
  bool filterContent = false;
  List<ReadMoreXPattern> customFilter = [];
  Color readMoreColor = const Color(0xFF2196F3);

  @override
  void initState() {
    super.initState();
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
      return _maximumWords(_filter(filterLineAndLength));
    } else {
      return _maximumWords([TextSpan(text: filterLineAndLength)]);
    }
  }

  String get filterLineAndLength {
    String text = '';

    if (!isReadMore) {
      final List<String> splitLine = content.split('\n');
      final bool isMaxLength = content.length > (maxLength < 1 ? 1 : maxLength);
      final bool isMaxLine = splitLine.length >= (maxLine < 1 ? 1 : maxLine);
      if (isMaxLength) {
        text = content.substring(0, maxLength);
      } else if (isMaxLine) {
        final words = '${splitLine[0]}${splitLine[1]}${splitLine[2]}';
        text = content.substring(0, words.length);
      } else {
        text = content;
      }
    } else {
      text = content;
    }

    String result = '';

    if (filterContent) {
      if (customFilter.isNotEmpty) {
        for (int i = 0; i < customFilter.length; i++) {
          if (i < 1) {
            result = _patternfilter(text, customFilter[i]);
          } else {
            result = _patternfilter(result, customFilter[i]);
          }
        }
        return result;
      } else {
        return text;
      }
    } else {
      return text;
    }
  }

  String get filterLineAndLengthX {
    String text = '';
    if (filterContent) {
      if (customFilter.isNotEmpty) {
        for (int i = 0; i < customFilter.length; i++) {
          if (i < 1) {
            text = _patternfilter(content, customFilter[i]);
          } else {
            text = _patternfilter(text, customFilter[i]);
          }
        }
      } else {
        text = content;
      }
    } else {
      text = content;
    }

    if (!isReadMore) {
      final List<String> splitLine = text.split('\n');
      final bool isMaxLength = text.length > (maxLength < 1 ? 1 : maxLength);
      final bool isMaxLine = splitLine.length >= (maxLine < 1 ? 1 : maxLine);
      if (isMaxLength) {
        return text.substring(0, maxLength);
      } else if (isMaxLine) {
        final words = '${splitLine[0]}${splitLine[1]}${splitLine[2]}';
        return text.substring(0, words.length);
      } else {
        return text;
      }
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      style: textStyle,
      textAlign: textAlign,
      TextSpan(children: textSpanChildren),
    );
  }

  String _patternfilter(String str, ReadMoreXPattern pattern) {
    if (str.contains(RegExp(pattern.pattern))) {
      final splitSpace = str.split(patternSpace);
      final res = List.generate(
        splitSpace.length,
        (index) {
          final word = splitSpace[index].replaceAll('\n', patternNewline);
          if (!word.contains(RegExp(pattern.pattern))) {
            return '$word ';
          } else {
            if (word.contains(RegExp(r'@@(.*?)@@=>')) && !word.contains(patternNewline)) {
              return '$word ';
            } else {
              return '@@${pattern.pattern}@@=>$word ';
            }
          }
        },
      ).join('');
      return res;
    } else {
      return str;
    }
  }

  List<InlineSpan> _filter(String str) {
    List<InlineSpan> listSpan = [];
    List<String> splitSpace = str.split(patternSpace);
    for (int splitIndex = 0; splitIndex < splitSpace.length; splitIndex++) {
      final word = splitSpace[splitIndex];

      final match = RegExp(r'@@(.*?)@@=>').firstMatch(word);
      if (match != null) {
        for (ReadMoreXPattern pattern in customFilter) {
          if ('@@${pattern.pattern}@@=>'.contains(match.group(0)!)) {
            final contentWord = word.replaceFirst(match.pattern, '');
            final hasValueChanged = pattern.valueChanged != null && pattern.valueChanged!.call(contentWord)!.isNotEmpty;
            listSpan.add(
              WidgetSpan(
                child: GestureDetector(
                  onTap: () => pattern.onTap?.call(contentWord),
                  child: Text(
                    hasValueChanged ? '${pattern.valueChanged?.call(contentWord)} ' : '$contentWord ',
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
        if (patternNewline.contains(match.group(0)!)) {
          listSpan.add(const TextSpan(text: '\n'));
        }
      } else {
        listSpan.add(TextSpan(text: '$word '));
      }
    }
    return listSpan;
  }

  List<InlineSpan> _maximumWords(List<InlineSpan> listSpan) {
    List<InlineSpan> result = listSpan;
    final List<String> splitLine = content.split('\n');
    if (content.length > (maxLength < 1 ? 1 : maxLength) || splitLine.length >= (maxLine < 1 ? 1 : maxLine)) {
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
}
