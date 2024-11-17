import 'package:flatter_conn/theme/pallete.dart';
import 'package:flutter/material.dart';

class RoundedSmallButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final double circularNess;

  const RoundedSmallButton({
    super.key,
    required this.onTap,
    required this.label,
    this.backgroundColor = Pallete.whiteColor,
    this.textColor = Pallete.backgroundColor,
     required this.circularNess,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(circularNess ),
        ),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 18,
          ),
        ),
        backgroundColor: backgroundColor,
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
      ),
    );
  }
}
