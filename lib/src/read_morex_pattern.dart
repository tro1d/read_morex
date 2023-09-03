part of read_morex;

class ReadMoreXPattern {
  /// The regular expression pattern to be used for text filtering.
  ///
  /// Example:
  ///```Dart
  /// pattern: r'https://',
  ///```
  final String pattern;

  /// A function to transform the filtered value.
  final String? Function(String?)? valueChanged;

  /// The color to apply to the filtered text.
  final Color? colorChanged;

  /// A callback function that is triggered when the filtered text is tapped.
  final ValueChanged<String?>? onTap;

  /// A linear decoration to draw near the filter content.
  final TextDecoration? textDecoration;

  ReadMoreXPattern({
    required this.pattern,

    /// A function to modify the filtered value based on the pattern.
    this.valueChanged,

    /// The color to apply to the filtered text.
    this.colorChanged,

    /// A callback function to handle taps on the filtered text.
    this.onTap,

    /// Additional text decoration to be applied to the filtered text.
    this.textDecoration,
  });
}
