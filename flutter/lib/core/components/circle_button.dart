import 'package:flutter/material.dart';

class CircleButtonWidget extends StatelessWidget {
  final Function() onTap;
  final IconData? icon;
  final double? iconSize;
  final Color? iconColor;
  final double? elevation;
  final Color? backgroundColor;
  const CircleButtonWidget({
    Key? key,
    required this.onTap,
    required this.icon,
    this.iconColor,
    this.iconSize,
    this.elevation,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 35,
      height: 35,
      child: ElevatedButton(
        child: Icon(
          icon,
          size: iconSize ?? 16,
          color: iconColor ?? Colors.white,
        ),
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          primary: backgroundColor ?? const Color(0xff808080),
          fixedSize: const Size(35, 35),
          shape: const CircleBorder(),
          minimumSize: Size.zero, // Set this
          padding: EdgeInsets.zero, // and this
        ),
      ),
    );
  }
}
