import 'package:flutter/material.dart';
import 'package:flutter_application_10/auth/constans.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class CreateOrderPage extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final double totalPrice;
  final String dateOfDelivery;

  const CreateOrderPage({
    required this.orderItems,
    required this.totalPrice,
    required this.dateOfDelivery,
  });

  @override
  _CreateOrderPageState createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends State<CreateOrderPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Order'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Total Price: \$${widget.totalPrice}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Date of Delivery: ${widget.dateOfDelivery}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      createOrder();
                    },
                    child: Text('Place Order'),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> createOrder() async {
    setState(() {
      isLoading = true;
    });

    try {
      // تحضير بيانات الطلب
      Map<String, dynamic> orderData = {
        'total_price': widget.totalPrice,
        'date_of_delivery': widget.dateOfDelivery,
        'order_items': widget.orderItems,
      };

      // إرسال طلب الإنشاء إلى الخادم
      String url = API_URL + 'order/store';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        // تم إنشاء الطلب بنجاح
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Order created successfully'),
        ));
      } else {
        // فشل في إنشاء الطلب
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create order'),
        ));
      }
    } catch (error) {
      // حدث خطأ ما
      print('Error creating order: $error');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error creating order. Please try again later.'),
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
