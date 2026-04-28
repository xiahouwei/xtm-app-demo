import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/theme_notifier.dart';
import 'package:flutter_proj/xtmdesign_component/xtm_design.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final VoidCallback onPressed;
  const SearchBar({@required this.controller, @required this.placeholder, @required this.onPressed,});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context, listen: true);
    return Container(
      height: 40,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: XtmInput(
              label: placeholder,
              controller: controller,
              useHint: true,
              clear: true,
              borderColor: theme.dividerColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: XtmTextButton(
              text: '查询',
              fontSize: 13,
              onPressed: onPressed,
            ),
          )
        ],
      ),
    );
  }
}
