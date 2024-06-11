// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:restaurant/apis/restaurant_api.dart';
import 'package:restaurant/pages/review_list.dart';
import 'package:restaurant/util/util.dart';

import '../models/review.dart';

class ReviewForm extends StatefulWidget {
  final Function() notify;
  const ReviewForm({Key? key, required this.notify}) : super(key: key);

  @override
  _ReviewFormState createState() => _ReviewFormState();
}

class _ReviewFormState extends State<ReviewForm> {
  Review? review;

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int ratingValue =
      3; // For looks its best to see 3/5 stars when you start the application

  @override
  void initState() {
    super.initState();
    review = Review(id: 0, name: "", description: "", rating: 5);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Rating: ',
                  style: TextStyle(fontSize: 16),
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemSize: 30.0,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    ratingValue = rating.toInt();
                  },
                ),
              ],
            ),
            const SizedBox(height: 30), // Increased the space
            ElevatedButton(
              onPressed: () {
                _saveReview();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(
                    vertical: 12, horizontal: 24), // Increased the padding
                child: Text(
                  'Submit',
                  style: TextStyle(fontSize: 18), // Increased the font size
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveReview() {
    review?.name = nameController.text;
    review?.description = descriptionController.text;
    review?.rating = ratingValue;

    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      Util.showSimpleDialog(context, "Something went wrong!",
          "Please make sure that your name, and the description has been filled in!");
      return;
    }

    RestaurantApi.createReview(review!).then((result) {
      Navigator.pop(context, true);
      Util.showSimpleDialog(
          context, "Review Submitted", "Thank you for your review!");
      widget.notify();
    });
  }
}
