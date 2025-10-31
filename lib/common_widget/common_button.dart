//Common Button.............
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tripolystudionew/utility/colors.dart';
import 'package:tripolystudionew/utility/text_style.dart';

class CommonButton extends StatefulWidget {
  final String title;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? spinColor;
  final TextStyle? style;
  final Decoration? decoration;
  final Color? iconColor;
  final double? width;
  final double? height;
  final bool isLoading;
  final bool? isEnable;
  final bool? isArrow;
  final Color? broderColor;
  final LinearGradient? gradient;

  const CommonButton({
    super.key,
    required this.isLoading,
    required this.title,
    this.broderColor,
    this.iconColor,
    this.icon,
    this.spinColor,
    this.isEnable,
    this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.decoration,
    this.style,
    this.color,
    this.gradient,
    this.isArrow,
  });

  @override
  State<CommonButton> createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.isEnable == false
            ? () {}
            : widget.isLoading
            ? () {}
            : widget.onPressed,
        child: Container(
          height: widget.height ?? 50,
          decoration:
              widget.decoration ??
              BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: widget.color ?? colorFF9800,
                border: Border.all(color: widget.broderColor ?? Colors.transparent),
              ),
          child: Container(
            width: widget.width ?? double.infinity,
            height: widget.height ?? 30,
            decoration: BoxDecoration(color: widget.isEnable == false ? Colors.white.withOpacity(0.5) : null),
            margin: widget.margin ?? EdgeInsets.zero,
            padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: widget.isLoading
                ? SizedBox(height: 20, child: SpinKitThreeBounce(color: widget.spinColor ?? color000000, size: 30.0))
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 30),
                      Text(widget.title, style: widget.style ?? color000000w50015),
                      widget.isArrow == true
                          ? const SizedBox()
                          : Image.asset("assets/icon/arrow_right.png", scale: 1, color: widget.iconColor ?? color000000),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
