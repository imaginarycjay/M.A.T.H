import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import '../theme/app_theme.dart';

/// A widget that renders text with embedded LaTeX math formulas.
///
/// Supports:
/// - Inline math: $x$, $f(x)$, etc.
/// - Display math: $$formula$$
/// - Bold text: **text**
/// - Bullet points: • text
class MathRenderer extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? textColor;
  final bool isActive;
  final TextAlign textAlign;

  const MathRenderer({
    super.key,
    required this.text,
    this.fontSize = 14,
    this.textColor,
    this.isActive = true,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? (isActive ? AppTheme.text : AppTheme.muted);

    // Check if text contains LaTeX patterns
    if (!_containsLatex(text)) {
      return _buildPlainRichText(text, color);
    }

    return _buildMixedContent(text, color);
  }

  /// Check if text contains LaTeX patterns
  bool _containsLatex(String text) {
    // Check for $...$ or $$...$$ or common LaTeX commands
    return RegExp(r'\$[^$]+\$|\\[a-zA-Z]+|\\le|\\ge|\\frac|\\sqrt|{cases}')
        .hasMatch(text);
  }

  /// Build plain rich text with bold support
  Widget _buildPlainRichText(String text, Color baseColor) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: _parseInlineFormatting(text, baseColor),
      ),
    );
  }

  /// Build mixed content with LaTeX and text
  Widget _buildMixedContent(String text, Color baseColor) {
    final widgets = <InlineSpan>[];

    // Pattern to match inline LaTeX ($...$) or display LaTeX ($$...$$)
    final latexPattern = RegExp(r'\$\$([^$]+)\$\$|\$([^$]+)\$');

    int lastEnd = 0;

    for (final match in latexPattern.allMatches(text)) {
      // Add text before this match
      if (match.start > lastEnd) {
        final beforeText = text.substring(lastEnd, match.start);
        widgets.addAll(_parseInlineFormatting(beforeText, baseColor));
      }

      // Get the LaTeX content (either from $$ or $)
      final latexContent = match.group(1) ?? match.group(2) ?? '';
      final isDisplay = match.group(1) != null;

      // Add the math widget as an inline span
      widgets.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: _buildMathWidget(latexContent, baseColor, isDisplay),
        ),
      );

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      widgets.addAll(_parseInlineFormatting(text.substring(lastEnd), baseColor));
    }

    return RichText(
      textAlign: textAlign,
      text: TextSpan(children: widgets),
    );
  }

  /// Parse inline formatting (bold)
  List<InlineSpan> _parseInlineFormatting(String text, Color baseColor) {
    final spans = <InlineSpan>[];
    final boldPattern = RegExp(r'\*\*([^*]+)\*\*');

    int lastEnd = 0;

    for (final match in boldPattern.allMatches(text)) {
      // Add text before bold
      if (match.start > lastEnd) {
        spans.add(TextSpan(
          text: text.substring(lastEnd, match.start),
          style: TextStyle(
            fontSize: fontSize,
            height: 1.6,
            color: baseColor,
          ),
        ));
      }

      // Add bold text
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
          fontSize: fontSize,
          height: 1.6,
          fontWeight: FontWeight.bold,
          color: baseColor,
        ),
      ));

      lastEnd = match.end;
    }

    // Add remaining text
    if (lastEnd < text.length) {
      spans.add(TextSpan(
        text: text.substring(lastEnd),
        style: TextStyle(
          fontSize: fontSize,
          height: 1.6,
          color: baseColor,
        ),
      ));
    }

    // If no formatting, just return plain text
    if (spans.isEmpty) {
      spans.add(TextSpan(
        text: text,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.6,
          color: baseColor,
        ),
      ));
    }

    return spans;
  }

  /// Build a math widget for LaTeX content
  Widget _buildMathWidget(String latex, Color color, bool isDisplay) {
    // Clean up the LaTeX string
    String cleanLatex = latex.trim();

    // Handle common escapes and formatting
    cleanLatex = _processLatex(cleanLatex);

    try {
      return Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDisplay ? 0 : 2,
          vertical: isDisplay ? 8 : 0,
        ),
        child: Math.tex(
          cleanLatex,
          textStyle: TextStyle(
            fontSize: fontSize * (isDisplay ? 1.2 : 1.1),
            color: color,
          ),
          mathStyle: isDisplay ? MathStyle.display : MathStyle.text,
          onErrorFallback: (error) {
            // Fallback to plain text if LaTeX parsing fails
            return Text(
              latex,
              style: TextStyle(
                fontSize: fontSize,
                fontFamily: 'monospace',
                color: color,
              ),
            );
          },
        ),
      );
    } catch (e) {
      // Fallback for any rendering errors
      return Text(
        latex,
        style: TextStyle(
          fontSize: fontSize,
          fontFamily: 'monospace',
          color: color,
        ),
      );
    }
  }

  /// Process LaTeX string to handle common patterns
  String _processLatex(String latex) {
    String result = latex;

    // Convert common text patterns to LaTeX
    result = result.replaceAll('≤', r'\le ');
    result = result.replaceAll('≥', r'\ge ');
    result = result.replaceAll('×', r'\times ');
    result = result.replaceAll('÷', r'\div ');
    result = result.replaceAll('≠', r'\ne ');
    result = result.replaceAll('→', r'\rightarrow ');
    result = result.replaceAll('₀', '_0');
    result = result.replaceAll('₁', '_1');
    result = result.replaceAll('₂', '_2');
    result = result.replaceAll('²', '^2');
    result = result.replaceAll('³', '^3');

    return result;
  }
}

/// A widget to render a standalone math formula (centered, display style)
class MathFormula extends StatelessWidget {
  final String latex;
  final double fontSize;
  final Color? textColor;

  const MathFormula({
    super.key,
    required this.latex,
    this.fontSize = 18,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? AppTheme.text;

    try {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.secondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border),
        ),
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Math.tex(
              latex,
              textStyle: TextStyle(
                fontSize: fontSize,
                color: color,
              ),
              mathStyle: MathStyle.display,
              onErrorFallback: (error) {
                return Text(
                  latex,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontFamily: 'monospace',
                    color: color,
                  ),
                );
              },
            ),
          ),
        ),
      );
    } catch (e) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.secondary,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border),
        ),
        child: Center(
          child: Text(
            latex,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: 'monospace',
              color: color,
            ),
          ),
        ),
      );
    }
  }
}

/// A widget to render piecewise functions properly
class PiecewiseFunction extends StatelessWidget {
  final List<PiecewiseCase> cases;
  final String functionName;
  final double fontSize;
  final Color? textColor;

  const PiecewiseFunction({
    super.key,
    required this.cases,
    this.functionName = 'f(x)',
    this.fontSize = 16,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? AppTheme.text;

    // Build LaTeX for piecewise function
    final casesLatex = cases.map((c) => '${c.formula} & \\text{if } ${c.condition}').join(r' \\ ');
    final latex = '$functionName = \\begin{cases} $casesLatex \\end{cases}';

    try {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFCD34D)),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Math.tex(
            latex,
            textStyle: TextStyle(
              fontSize: fontSize,
              color: color,
            ),
            mathStyle: MathStyle.display,
            onErrorFallback: (error) {
              return _buildFallbackPiecewise(color);
            },
          ),
        ),
      );
    } catch (e) {
      return _buildFallbackPiecewise(color);
    }
  }

  Widget _buildFallbackPiecewise(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFCD34D)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$functionName = ',
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 8),
          ...cases.map((c) => Padding(
            padding: const EdgeInsets.only(left: 24, bottom: 4),
            child: Text(
              '${c.formula}  if ${c.condition}',
              style: TextStyle(
                fontSize: fontSize - 2,
                fontFamily: 'monospace',
                color: color,
              ),
            ),
          )),
        ],
      ),
    );
  }
}

/// Represents a single case in a piecewise function
class PiecewiseCase {
  final String formula;
  final String condition;

  const PiecewiseCase({
    required this.formula,
    required this.condition,
  });
}
