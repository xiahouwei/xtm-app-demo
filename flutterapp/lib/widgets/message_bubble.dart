import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {

  final int messageCount;
  MessageBubble({@required this.messageCount});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: messageCount != null && messageCount > 0,
      child: Container(
        alignment: Alignment.center,
        height: 18,
        decoration: BoxDecoration(
            color: Color(0xFFFA3434),
            borderRadius: BorderRadius.all(Radius.circular(9))
        ),
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(
          '${setMessageCount(messageCount)}',
          style: TextStyle(fontSize: 10, color: Colors.white),
          textScaleFactor: 1.0,
        ),
      ),
    );
  }

  String setMessageCount(int count) {
    if (count == null) return '';
    if (count > 99) {
      return '99+';
    }
    return count.toString();
  }
}
