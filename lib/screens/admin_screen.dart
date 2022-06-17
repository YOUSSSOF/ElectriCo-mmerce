import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:book_ecommerce/models/product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/submit_button.dart';
import '../widgets/text_input.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    Future<Products> fetchProducts() async {
      var response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/products/'));
      return Products.fromJson(jsonDecode(response.body));
    }

    void handleDelete(Product product) {
      showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Deleting ${product.name}'),
          content: const Text('Are you sure to delete this product?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await http.delete(
                  Uri.parse(
                      "http://127.0.0.1:8000/api/products/${product.id}/"),
                  headers: {
                    'Authorization': 'JWT $token',
                  },
                );
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }

    void handleEdit(Product product) {
      final editFormKey = GlobalKey<FormState>();
      final nameController = TextEditingController(text: product.name);
      final priceController = TextEditingController(text: product.price);
      final decriptionController =
          TextEditingController(text: product.description);
      final ImagePicker picker = ImagePicker();
      var image = product.image;
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0)), //this right here
          child: Container(
              height: 500.0,
              width: 350.0,
              padding: const EdgeInsets.all(30),
              child: Form(
                key: editFormKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        image =
                            await picker.pickImage(source: ImageSource.gallery);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          image,
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    TextInput(
                      placeholder: 'Name',
                      controller: nameController,
                    ),
                    TextInput(
                      placeholder: 'Price',
                      controller: priceController,
                      keyboardType: TextInputType.number,
                    ),
                    TextInput(
                      placeholder: 'Description',
                      controller: decriptionController,
                      maxLines: 3,
                    ),
                    SubmitButton(
                        title: "Confirm",
                        onPressed: () async {
                          print(image.toString());
                          await http.patch(
                            Uri.parse(
                              "http://127.0.0.1:8000/api/products/${product.id}/",
                            ),
                            headers: {
                              'Authorization': 'JWT $token',
                            },
                            body: {
                              "name": nameController.text,
                              "price": priceController.text.toString(),
                              "description":
                                  decriptionController.text.toString(),
                              // "image": image,
                              "last_upload": product.lastUpload,
                            },
                          );
                          setState(() {});
                          Navigator.pop(context);
                        })
                  ],
                ),
              )),
        ),
      );
    }

    void handleAdd() {
      final editFormKey = GlobalKey<FormState>();
      final nameController = TextEditingController();
      final priceController = TextEditingController();
      final decriptionController = TextEditingController();
      final ImagePicker picker = ImagePicker();
      var image;
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            height: 500.0,
            width: 350.0,
            padding: const EdgeInsets.all(30),
            child: Form(
              key: editFormKey,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      image =
                          await picker.pickImage(source: ImageSource.gallery);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        color: Colors.grey.shade400,
                        width: 100,
                        height: 100,
                        child: const Icon(
                          Icons.camera,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  TextInput(
                    placeholder: 'Name',
                    controller: nameController,
                  ),
                  TextInput(
                    placeholder: 'Price',
                    controller: priceController,
                    keyboardType: TextInputType.number,
                  ),
                  TextInput(
                    placeholder: 'Description',
                    controller: decriptionController,
                    maxLines: 3,
                  ),
                  SubmitButton(
                      title: "Confirm",
                      onPressed: () async {
                        await http.post(
                          Uri.parse(
                            "http://127.0.0.1:8000/api/products/",
                          ),
                          headers: {
                            'Authorization': 'JWT $token',
                          },
                          body: {
                            "name": nameController.text.toString(),
                            "price": priceController.text.toString(),
                            "description": decriptionController.text.toString(),
                            "image": image,
                          },
                        );
                        setState(() {});
                        Navigator.pop(context);
                      })
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            onPressed: handleAdd,
            icon: const Icon(Icons.add),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: FutureBuilder<Products>(
        future: fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Align(
              alignment: Alignment.topCenter,
              child: DataTable(
                dataRowHeight: 80,
                columnSpacing: 30,
                columns: const [
                  DataColumn(
                    label: Text(''),
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Price',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Text(''),
                  ),
                ],
                rows: snapshot.data!.products
                    .map(
                      (e) => DataRow(
                        cells: [
                          DataCell(
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.network(
                                e.image,
                                width: 80,
                                height: 60,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          DataCell(
                            Text(e.name),
                          ),
                          DataCell(
                            Text(
                              e.price.toString(),
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => handleEdit(e),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () => handleDelete(e),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
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
