import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({Key? key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  double rating = 0;
  double meanRating = 0;
  
  final CollectionReference _ratingsCollection =
      FirebaseFirestore.instance.collection('ratings');
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserRating();
    _calculateMeanRating();
  }

  void _loadUserRating() async {
    final userRatingDoc = await _ratingsCollection.doc(currentUser!.uid).get();
    if (userRatingDoc.exists) {
      setState(() {
        rating = (userRatingDoc.data() as Map<String, dynamic>)['rating'] ?? 0;
      });
    }
  }

  void _calculateMeanRating() {
    _ratingsCollection.snapshots().listen((QuerySnapshot snapshot) {
      if (snapshot.docs.isNotEmpty) {
        double sum = 0;
        int totalRatings = 0;

        for (var doc in snapshot.docs) {
          final userRating = (doc.data() as Map<String, dynamic>)['rating'] ?? 0;
          if (userRating >= 1) {
            sum += userRating;
            totalRatings++;
          }
        }

        setState(() {
          meanRating = sum / totalRatings;
        });
      } else {
        setState(() {
          meanRating = 0;
        });
      }
    });
  }

  void _saveUserRating(double rating) {
    if (currentUser != null) {
      _ratingsCollection.doc(currentUser!.uid).set({
        'rating': rating,
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Color.fromARGB(255, 241, 216, 230),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Rating: $rating',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              RatingBar.builder(
                minRating: 1,
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  setState(() {
                    this.rating = rating;
                    _saveUserRating(rating);
                  });
                },
              ),
              const SizedBox(height: 32),
              Text(
                'Average Rating: $meanRating',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}