import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemBottomNAvBar extends StatelessWidget {
  const ItemBottomNAvBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shadowColor: Colors.black,
      elevation: 0,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // total text
                Text(
                  "Total :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19),
                ),
                // sizedbox
                SizedBox(
                  width: 15,
                ),
                // total price
                Text(
                  "\$90",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 19,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            //material button
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              padding: EdgeInsets.symmetric(
                vertical: 13,
                horizontal: 18,
              ),
              color: Colors.red,
              onPressed: () {},
              child: Row(
                children: [
                  // icon
                  Icon(
                    CupertinoIcons.cart,
                    color: Colors.white,
                  ),
                  //text
                  Text(
                    "  Add To Cart",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
