import 'package:flutter/material.dart';

// ignore: must_be_immutable
class disLikeButton extends StatelessWidget {
  final bool isdisLiked;
  void Function()? onTap;

   disLikeButton({
    required this.isdisLiked,
    required this.onTap,
    super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: onTap,
       child: Icon(
        isdisLiked? Icons.sentiment_very_dissatisfied:Icons.sentiment_very_dissatisfied,
        color: isdisLiked?Colors.blue:Colors.grey,
       ),
    );
  }
}