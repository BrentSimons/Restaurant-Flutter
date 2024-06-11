import 'package:flutter/material.dart';
import 'package:restaurant/apis/restaurant_api.dart';

import '../models/review.dart';

import './review_form.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<Review> reviews = [];

  void notify() {
    _getReviews();
  }

  @override
  void initState() {
    super.initState();
    _getReviews();
  }

  void _getReviews() {
    RestaurantApi.fetchReviews().then((result) {
      setState(() {
        reviews = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
              color: Colors.blue, // Color of the rectangular button
              child: TextButton(
                onPressed: () {
                  _navigateToReviewForm();
                  _getReviews();
                },
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Submit Review',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  child: ListTile(
                    title: Text(reviews[index].name),
                    subtitle: Text(reviews[index].description),
                    trailing: Text('${reviews[index].rating} stars'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToReviewForm() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ReviewForm(notify: notify)),
    );
  }
}
