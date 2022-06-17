import 'dart:convert';
import 'package:book_ecommerce/models/product.dart';
import 'package:book_ecommerce/auth/authentication_screen.dart';
import 'package:book_ecommerce/models/user.dart';
import 'package:book_ecommerce/screens/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'admin_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Products> fetchProducts() async {
    var response =
        await http.get(Uri.parse('http://127.0.0.1:8000/api/products/'));
    return Products.fromJson(jsonDecode(response.body));
  }

  Future<User?> fetchUser() async {
    if (token != null) {
      var response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/auth/users/me/'),
        headers: {
          'Authorization': 'JWT $token',
        },
      );
      return User.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  String search = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: FutureBuilder<User?>(
        future: fetchUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Center(
                        child: CircleAvatar(
                      radius: 50,
                      backgroundImage: snapshot.data!.profilePhoto != null
                          ? Image.network(snapshot.data!.profilePhoto).image
                          : null,
                      child: snapshot.data!.profilePhoto == null
                          ? Text(snapshot.data!.username)
                          : null,
                    )),
                  ),
                  ListTile(
                    title: Text(snapshot.data!.email),
                    leading: const Icon(Icons.person),
                  ),
                  if (snapshot.data!.isAdmin)
                    Column(
                      children: [
                        const Divider(),
                        ListTile(
                          title: const Text("Admin panel"),
                          leading: const Icon(Icons.admin_panel_settings),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AdminScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            );
          }
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Container(),
                ),
                ListTile(
                  title: const Text('Sign In/Sign Up'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AuthenticationScreen()));
                  },
                  leading: const Icon(Icons.person),
                ),
              ],
            ),
          );
        },
      ),
      appBar: AppBar(
        actions: const [
          Icon(
            Icons.shopping_bag_outlined,
            size: 30,
          ),
          SizedBox(
            width: 20,
          ),
        ],
        centerTitle: true,
        title: const Text('Welcome to my store !'),
      ),
      body: FutureBuilder<Products>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 10, left: 20, right: 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        search = value;
                      });
                    },
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search)),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 10,
                    left: 15,
                  ),
                  child: const Text(
                    'Latest products',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.products.length,
                    itemBuilder: (context, index) {
                      Product product = snapshot.data!.products[index];
                      return product.name.toLowerCase().contains(search)
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ProductDetailsScreen(
                                              product: product,
                                            )));
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 5),
                                    child: ListTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10.0),
                                        child: Text(product.name),
                                      ),
                                      subtitle: Text(
                                        product.description,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      trailing: Text(product.price.toString()),
                                      leading: Image.network(
                                        product.image,
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey.shade800,
                                    thickness: .2,
                                    height: 20,
                                  ),
                                ],
                              ),
                            )
                          : Container();
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
