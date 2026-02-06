import 'package:flutter/material.dart';
import 'package:flutter_proj/theme/xtm_color.dart';

class DialogActions extends StatelessWidget {
  final Function() onConfirmed;

  DialogActions({
    Key key,
    @required this.onConfirmed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1, color: Colors.grey),
        Container(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextButton(
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.black87),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, double.infinity),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              Container(
                height: double.infinity,
                child: const VerticalDivider(
                  width: 2,
                  color: Colors.grey,
                ),
              ),
              Expanded(
                child: TextButton(
                  child: Text(
                    '确认修改',
                    style: TextStyle(color: XtmColor.themeColor),
                  ),
                  style: TextButton.styleFrom(
                    minimumSize: Size(double.infinity, double.infinity),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                  ),
                  onPressed: onConfirmed,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
