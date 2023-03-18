import 'package:database/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CART'),
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false).clear();
                },
                icon: const Icon(Icons.delete_outline))
          ],
        ),
        body: Consumer<CartProvider>(
          builder: (context, value, child) {
            if (value.cartItems.isNotEmpty) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.cartItems.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 4,
                                  offset: Offset(0, 0),
                                )
                              ]),
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          Icons.shopping_cart_rounded)),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          value.cartItems[index].productName,
                                          style: GoogleFonts.cairo(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Quantity ${value.cartItems[index].count} - total ${value.cartItems[index].total}',
                                          style: GoogleFonts.cairo(
                                              fontSize: 12.sp,
                                              color: Colors.grey.shade500,
                                              height: 1.4),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .changQuantity(
                                                  index,
                                                  value.cartItems[index].count +
                                                      1);
                                        },
                                        icon: const Icon(Icons.add),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Provider.of<CartProvider>(context,
                                                  listen: false)
                                              .changQuantity(
                                                  index,
                                                  value.cartItems[index].count -
                                                      1);
                                        },
                                        icon: const Icon(Icons.remove),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      color: Colors.grey.shade300,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Total:',
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                              Spacer(),
                              Text(
                                value.total.toString(),
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                'Quantity:',
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                              Spacer(),
                              Text(
                                value.quantity.toString(),
                                style: GoogleFonts.cairo(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ],
                      )),
                ],
              );
            } else {
              return const Center(
                child: Text(
                  'NO Data',
                  style: TextStyle(fontSize: 22),
                ),
              );
            }
          },
        ));
  }
}
