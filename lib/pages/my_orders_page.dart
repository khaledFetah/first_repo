import 'package:flutter/material.dart';
import 'package:flutter_application_10/auth/constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isLoading = false;
  List<dynamic> orders = [];
  Map<String, dynamic> orderDetails = {};

  Future<void> getOrders() async {
    setState(() {
      isLoading = true;
    });

    String url = API_URL + 'orders/index';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Token is null');
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        setState(() {
          isLoading = false;
          orders = jsonResponse['data'];
        });
      } else {
        print('Failed to load orders');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching orders: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> viewOrderDetails(int orderId) async {
    String url = API_URL + 'orders/show/$orderId';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      print('Token is null');
      return;
    }

    try {
      var response = await http.get(Uri.parse(url), headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse != null &&
            jsonResponse is Map &&
            jsonResponse.isNotEmpty) {
          // التحقق من أن jsonResponse ليس فارغًا وهو من النوع المتوقع
          setState(() {
            orderDetails = jsonResponse.cast<String,
                dynamic>(); // تحويل النوع إلى Map<String, dynamic>
          });
          print('Order details: $orderDetails');
        } else {
          print('Invalid response or empty data');
        }
      } else {
        print('Failed to load order details');
      }
    } catch (error) {
      print('Error fetching order details: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : orders.isNotEmpty
              ? ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Order #${orders[index]['id']}'),
                      subtitle: Text('Status: ${orders[index]['status']}'),
                      trailing: Text('Total: ${orders[index]['total']}'),
                      onTap: () {
                        viewOrderDetails(orders[index]['id']);
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Order Details'),
                                  Divider(),
                                  Text('Status: ${orderDetails['status']}'),
                                  Text('Total: ${orderDetails['total']}'),
                                  Text('Items:'),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    itemCount:
                                        orderDetails['order_details'].length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return ListTile(
                                        title: Text(
                                            '${orderDetails['order_details'][index]['product_id']}'),
                                        subtitle: Text(
                                            'Quantity: ${orderDetails['order_details'][index]['quantity']}'),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                )
              : Center(
                  child: Text('No orders found'),
                ),
    );
  }
}
