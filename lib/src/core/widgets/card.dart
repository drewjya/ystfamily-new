// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ystfamily/src/core/core.dart';

class VCard extends StatelessWidget {
  final bool vertical;
  final VoidCallback? onTap;
  final Widget? child;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;
  final double elevation;
  final BoxBorder? border;
  final Color? backgroundColor;

  final EdgeInsets? padding;
  const VCard({
    Key? key,
    this.onTap,
    this.padding,
    this.border,
    required this.vertical,
    this.child,
    this.height,
    this.width,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.elevation = 1,
    this.backgroundColor,
  }) : super(key: key);

  factory VCard.vertical({
    VoidCallback? onTap,
    Widget? child,
    BoxBorder? border,
    double? height,
    EdgeInsets? padding,
    double? width,
    double elevation = 1,
    Color? backgroundColor,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(12)),
  }) =>
      VCard(
        vertical: true,
        onTap: onTap,
        elevation: elevation,
        height: height,
        border: border,
        width: width,
        padding: padding,
        borderRadius: borderRadius,
        backgroundColor: backgroundColor,
        child: child,
      );
  factory VCard.horizontal({
    VoidCallback? onTap,
    Widget? child,
    double? height,
    EdgeInsets? padding,
    double? width,
    BoxBorder? border,
    double elevation = 1,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(12)),
    Color? backgroundColor,
  }) =>
      VCard(
        border: border,
        padding: padding,
        backgroundColor: backgroundColor,
        vertical: false,
        onTap: onTap,
        height: height,
        width: width,
        elevation: elevation,
        borderRadius: borderRadius,
        child: child,
      );

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: borderRadius,
      child: InkWell(
        borderRadius: borderRadius,
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
              color:
                  backgroundColor ?? VColor.primaryBackground.withOpacity(0.5),
              borderRadius: borderRadius,
              border: border),
          padding: padding ?? const EdgeInsets.all(12),
          height: () {
            if (height == null) {
              return vertical ? double.infinity : null;
            }
            if (height! > 0) {
              return height;
            }
            return null;
          }(),
          width: () {
            if (width == null) {
              return vertical ? null : double.infinity;
            }
            if (width! > 0) {
              return width;
            }

            return null;
          }(),
          child: child,
        ),
      ),
    );
  }
}
