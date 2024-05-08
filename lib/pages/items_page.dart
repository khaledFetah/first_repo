import 'package:clippy_flutter/arc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/auth/constans.dart';
import 'package:flutter_application_10/widgets/item_bootom_navbar.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ItemsPage extends StatefulWidget {
  final Map<String, dynamic> currentAddress;

  const ItemsPage({required this.currentAddress});

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  List<dynamic> products = [];

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getTimeLine();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // اضافة العنوان هنا
        title: Text('Items Page'),
      ),
      body: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: products.length, // تغيير عدد العناصر هنا
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print("Welcome");
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: products[index]['image'] != null
                        ? Image.network(
                            "${products[index]['image']}",
                            fit: BoxFit.cover,
                            width: 200,
                            height: 200,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Icon(
                                Icons.error,
                                size: 200,
                                color: Colors
                                    .red, // لون الأيقونة في حالة فشل عملية التحميل
                              );
                            },
                          )
                        : Icon(
                            Icons.image,
                            size: 200,
                            color: Colors
                                .grey, // لون الأيقونة في حالة عدم وجود عنوان URL
                          ),
                  ),
                ),
                Arc(
                  edge: Edge.TOP,
                  arcType: ArcType.CONVEY,
                  height: 30,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 60, bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBar.builder(
                                  initialRating: 4,
                                  minRating: 1,
                                  itemCount: 5,
                                  itemSize: 20,
                                  itemPadding:
                                      EdgeInsets.symmetric(horizontal: 4),
                                  direction: Axis.horizontal,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.red,
                                  ),
                                  onRatingUpdate: (context) {},
                                ),
                                Text(
                                  "\$${products[index]['price']}",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  products[index]['name'], // تغيير هنا
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  width: 90,
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        CupertinoIcons.minus,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      Text(
                                        "1",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        CupertinoIcons.plus,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              products[index]['description'], // تغيير هنا
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            child: Row(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "Remaining stock : ",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      TextSpan(
                                        text: "${products[index]['stock']}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors
                                              .red, // يمكنك تغيير اللون إذا كنت ترغب في ذلك
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.justify,
                                ),

                                // Add icon here if needed
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Delivery Time : ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      child: Icon(
                                        CupertinoIcons.clock,
                                        color: Colors.red,
                                      ),
                                    ),
                                    Text(
                                      "30 Minutes ",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: ItemBottomNAvBar(),
    );
  }

  Future<void> getTimeLine() async {
    setState(() {
      isLoading = true;
    });
    String url = API_URL + 'product/show/${widget.currentAddress['id']}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        isLoading = false;
        products = [jsonResponse['product']]; // تغيير هنا
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
