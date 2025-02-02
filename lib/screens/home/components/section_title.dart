import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key? key,
    required this.title,
    required this.press,
    this.padding = const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    this.titleStyle = const TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.black87,
    ),
  }) : super(key: key);

  final String title;
  final GestureTapCallback press;
  final EdgeInsetsGeometry padding;
  final TextStyle titleStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle.copyWith(),
          ),
        ],
      ),
    );
  }
}
