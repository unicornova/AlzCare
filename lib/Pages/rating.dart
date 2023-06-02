import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double rating =0;

  

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Rating: $rating',style: TextStyle(fontSize: 25,),),
    
    const SizedBox(height: 32,),
    RatingBar.builder(
      minRating: 1,
      itemBuilder: (context, _)=>Icon(Icons.star,color: Colors.amber,) ,
      onRatingUpdate: (rating){ setState(() {
        this.rating=rating;
      });

      },
      )
      ]),
  ));
}