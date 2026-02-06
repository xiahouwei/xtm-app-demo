import 'package:flutter/material.dart';
import 'package:flutter_proj/xtmdesign_component/src/xtm_design_config.dart';

class BottomSheetHeader extends StatelessWidget {
  final String title;
  final Function() confirmAction;

  BottomSheetHeader({@required this.title, @required this.confirmAction});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(12.0),
          right: Radius.circular(12.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Text(
                  '取消',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.black54,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                )),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Text(
              title ?? '',
              style: TextStyle(fontSize: 16, color: Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            child: Container(
                color: Colors.transparent,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Text(
                  '确定',
                  style: TextStyle(
                    fontSize: 15,
                    color: xtmDesignConfig.mainColor,
                    fontWeight: FontWeight.normal,
                    decoration: TextDecoration.none,
                  ),
                )),
            onTap: () {
              if (confirmAction != null) {
                confirmAction();
              }
            },
          ),
        ],
      ),
    );
  }
}
