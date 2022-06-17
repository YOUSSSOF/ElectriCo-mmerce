
import 'package:book_ecommerce/models/product.dart';
import 'package:book_ecommerce/screens/home_screen.dart';
import 'package:flutter/material.dart';
import '../auth/authentication_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({Key? key, required this.product})
      : super(key: key);
  final Product product;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.product.name),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.product.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Container(
              margin: const EdgeInsets.only(left: 30, top: 20),
              child: Text(
                "\$ ${widget.product.price}",
                style: TextStyle(
                  color: Colors.green.shade400,
                  fontSize: 35,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                widget.product.description,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: Colors.grey.shade800,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (token != null) {
                      Navigator.pop(context);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthenticationScreen(),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text("Add to cart"),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
