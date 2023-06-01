import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  final String user;
  final String text;
  final String time;

  const Comment({
    required this.user,
    required this.text,
    required this.time,
    super.key
    });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(4)
        ),
        child: Column(
          children: [

            Text(text),

            Row(
              children: [
                Text(user),
                Text('.'),
                Text(time),
              ],
            )

        ]),
      
    );
  }
}