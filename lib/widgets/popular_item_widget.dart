import 'package:flutter/material.dart';

class PopularItemWidget extends StatefulWidget {
  final Widget? ImageSrc;
  final String? nameProd;
  final String? descProd;
  final String? priceProd;
  final IconData? yourIcon;
  final VoidCallback onTap;
  final bool isFavorited;

  PopularItemWidget({
    super.key,
    required this.ImageSrc,
    required this.descProd,
    required this.nameProd,
    required this.priceProd,
    required this.yourIcon,
    required this.onTap,
    required this.isFavorited,
  });

  @override
  _PopularItemWidgetState createState() => _PopularItemWidgetState();
}

class _PopularItemWidgetState extends State<PopularItemWidget> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = widget.isFavorited;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 7),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7),
              child: Container(
                width: 170,
                height: 225,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.zero,
                          alignment: Alignment.center,
                          child: widget.ImageSrc,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        "${widget.nameProd}",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${widget.descProd}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                        maxLines: 1,
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${widget.priceProd}",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              widget.onTap();
                              setState(() {
                                isFavorited = !isFavorited;
                              });
                            },
                            child: Icon(
                              isFavorited
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorited ? Colors.red : Colors.black,
                              size: 26,
                              shadows: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
