import 'package:flutter/material.dart';
import 'package:flutter_application_10/auth/constans.dart';
import 'package:flutter_application_10/auth/onehelpers.dart';
import 'package:flutter_application_10/main.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ReviewsPage extends StatefulWidget {
  final int productId;
  const ReviewsPage({Key? key, required this.productId}) : super(key: key);

  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = true;
  List<dynamic> reviews = [];
  double rating = 3.0;
  final TextEditingController reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5F5f3),
        title: Text('Reviews Page'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : reviews.isEmpty
              ? Center(child: Text('No reviews available'))
              : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(reviews[index]['title']),
                      subtitle: Text(reviews[index]['content']),
                      trailing: Text('${reviews[index]['rating']} ⭐'),
                    );
                  },
                ),
      floatingActionButton: ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Add Review'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: formKey,
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'the content is required';
                        }

                        // Check if the value is a valid email address

                        return null;
                      },
                      cursorColor: Colors.red,
                      controller: reviewController,
                      decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                            color: Colors.red,
                            width: 2,
                          )),
                          hintText: 'Enter your review'),
                    ),
                  ),
                  SizedBox(height: 20),
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (newRating) {
                      setState(() {
                        rating = newRating;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      await addNewReview().then((response) {
                        setState(() {
                          isLoading = false;
                        });

                        var jsonResponse = json.decode(response.body);

                        final _context = MyApp.navKey.currentContext;

                        if (response.statusCode == 200) {
                          if (_context != null) {
                            ScaffoldMessenger.of(_context)
                                .showSnackBar(SnackBar(
                                    content: Text(transformErrors(
                              jsonResponse.containsKey("errors")
                                  ? jsonResponse['errors']
                                  : {},
                              singleError: jsonResponse.containsKey("message")
                                  ? jsonResponse['message']
                                  : "",
                            ))));
                            reviewController.clear();

                            Navigator.pushNamed(context, 'rev');
                          }
                        } else {
                          if (_context != null) {
                            ScaffoldMessenger.of(_context)
                                .showSnackBar(SnackBar(
                                    content: Text(transformErrors(
                              jsonResponse.containsKey("errors")
                                  ? jsonResponse['errors']
                                  : {},
                              singleError: jsonResponse.containsKey("message")
                                  ? jsonResponse['message']
                                  : "",
                            ))));
                          }
                        }
                      });
                    }
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        icon: Icon(
          Icons.add,
          color: Colors.red,
        ),
        label: Text(
          'New Review',
          style: TextStyle(color: Colors.red),
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Future<void> fetchReviews() async {
    String url =
        API_URL + 'product-review/showProductReviews/${widget.productId}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      setState(() {
        reviews = json.decode(response.body)['reviews'];
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Failed to load reviews');
    }
  }

  Future<Response> addNewReview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userIdInt = prefs.getInt('userId')!;
    String userId = userIdInt.toString();
    String token = prefs.getString('token')!;

    String url = API_URL + 'product-review/store';
    var response = await http.post(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'user_id': userId,
        'product_id': widget.productId,
        'review': reviewController.text,
        'rating': rating,
      }),
    );

    return response;
  }
}
