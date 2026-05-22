import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class AppFilterDropdownButton extends StatelessWidget {
  final String text;
  final double width;
  final double height;
  final void Function() onPressed;

  AppFilterDropdownButton({
    this.text,
    this.width = 80,
    this.height = 40,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    ThemeNotifier _theme = Provider.of<ThemeNotifier>(context, listen: true);
    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                text,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: _theme.mainTextColor,
                ),
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: _theme.mainTextColor,
            ),
          ],
        ),
      ),
    );
  }
}
