import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_10/main.dart';
import 'package:flutter_application_10/pages/categories_product.dart';
import 'package:flutter_application_10/pages/items_page.dart';
import 'package:flutter_application_10/widgets/app_bar_widget.dart';
import 'package:flutter_application_10/widgets/categories_widget.dart';
import 'package:flutter_application_10/widgets/my_drawer_widget.dart';
import 'package:flutter_application_10/widgets/newest_item_widget.dart';
import 'package:flutter_application_10/widgets/popular_item_widget.dart';
import 'dart:convert';
import 'package:flutter_application_10/auth/constans.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // my list for products
  List<dynamic> products = [];
  // my list for categries
  List<dynamic> categories = [];
// bool
  bool isLoading = false;
// insital state
  @override
  void initState() {
    super.initState();
    print("start");
    getTimeLine();
    print("ok");
    getCategories();
    print("Get categories");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (isLoading == false && products.length == 0)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (isLoading == true)
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    //Custom App Bar Widget
                    AppBarWidget(),

                    // Search
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print("search");
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  child: Icon(
                                    CupertinoIcons.search,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 300,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: TextFormField(
                                    decoration: InputDecoration(
                                        hintText:
                                            'What Would you like to have ?',
                                        border: InputBorder.none),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Category
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 10,
                      ),
                      child: Text(
                        "Categories",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    // Categories Widget
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          // استدعاء PopularItemWidget داخل ListView.builder
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CategoryProductScreen(categories[index]),
                                ),
                              );
                            },
                            child: Container(
                                child: CategoriesWidget(
                              CategoriesNameProduct: categories[index]['name'],
                              CategoriesProdCpount: categories[index]
                                      ['products_count']
                                  .toString(),
                            )),
                          );
                        },
                      ),
                    ),

                    // Popular items
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 10,
                      ),
                      child: Text(
                        "Popular",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    // Popular items widget
                    SizedBox(
                      height: 280,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          // استدعاء PopularItemWidget داخل ListView.builder
                          return Container(
                            child: GestureDetector(
                              onTap: () {
                                //
                                print("go to items page");
                                print(products[index]['id']);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ItemsPage(
                                      currentAddress: products[index],
                                    ),
                                  ),
                                );
                              },
                              child: PopularItemWidget(
                                ImageSrc: products[index]['image'].toString(),
                                descProd: products[index]['description'],
                                nameProd: products[index]['name'],
                                priceProd: products[index]['price'].toString(),
                                yourIcon: Icons.favorite_border,
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  int userId = prefs.getInt('userId') ??
                                      0; // استرجاع معرّف المستخدم من SharedPreferences
                                  if (userId != 0) {
                                    // التحقق مما إذا كان معرف المستخدم موجودًا
                                    try {
                                      await createWishlist(
                                          userId, products[index]['id']);
                                      // عرض رسالة النجاح في حالة نجاح الإضافة
                                      final _context =
                                          MyApp.navKey.currentContext;

                                      if (_context != null) {
                                        ScaffoldMessenger.of(_context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    "The Added Favoite Successfully")));
                                      }
                                    } catch (error) {
                                      print('Error creating wishlist: $error');
                                    }
                                  } else {
                                    print(
                                        'User ID not found in SharedPreferences');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'User ID not found. Please login again.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Newest items
                    Padding(
                      padding: EdgeInsets.only(
                        top: 20,
                        left: 10,
                      ),
                      child: Text(
                        "Newest",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),

                    // Newest item Widget
                    NewestItemWidget(),
                  ],
                ),
      // DRAWER WIDGET
      drawer: MYyDrawerWidget(),
      // FLOATING ACTION BUTTON
      floatingActionButton: Container(
        decoration:
            BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 4,
              blurRadius: 10,
              offset: Offset(0, 3))
        ]),
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          onPressed: () {
            Navigator.pushNamed(context, 'cart');
          },
          child: Icon(
            CupertinoIcons.cart,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // see every products
  Future<void> getTimeLine() async {
    //
    setState(() {
      isLoading = true;
    });
    // this Route
    String url = API_URL + 'product/timeline';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    var resposne = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    if (resposne.statusCode == 200) {
      var jsonResponse = jsonDecode(resposne.body);
      setState(() {
        isLoading = false;
        products = jsonResponse['products'];
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // see every categories
  Future<void> getCategories() async {
    //
    setState(() {
      isLoading = true;
    });
    // this Route
    String url = API_URL + 'categories';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    print(token);
    var resposne = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer $token',
    });
    if (resposne.statusCode == 200) {
      var jsonResponse = jsonDecode(resposne.body);
      setState(() {
        isLoading = false;
        categories = jsonResponse['categories'];
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Add New WishList
  Future<Response> createWishlist(int userId, int productId) async {
    setState(() {
      isLoading = true;
    });

    String url = API_URL + 'wishlists/store';

    SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString('token')!;

    print(token);

    var response = await http.post(Uri.parse(url),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          'user_id': userId,
          'product_id': productId,
        }));

    setState(() {
      isLoading = false;
    });

    return response;
  }
}
