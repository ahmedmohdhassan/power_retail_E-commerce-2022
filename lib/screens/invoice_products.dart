// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gomla/classes/cart_item_class.dart';
import 'package:http/http.dart' as http;

class InvoiceProducts extends StatefulWidget {
  const InvoiceProducts({
    Key? key,
    required this.invoiceId,
  }) : super(key: key);

  final num? invoiceId;

  @override
  State<InvoiceProducts> createState() => _InvoiceProductsState();
}

class _InvoiceProductsState extends State<InvoiceProducts> {
  Map<String?, CartItem> invoiceProducts = {};

  Future<void> getCartItems() async {
    var url = Uri.parse(
      'https://eatdevelopers.com/market/api_cart/api.php/?get_orders=all&invoice_id=${widget.invoiceId}',
    );

    try {
      var response = await http.get(url);
      Map<String?, CartItem> fetchedCartItems = {};
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (Map i in jsonData) {
          fetchedCartItems.putIfAbsent(
            '${i['order_id']}',
            () => CartItem(
              id: '${i['product_id']}',
              title: i['product_name'],
              price: double.parse(i['order_price']),
              unitPrice: double.parse(i['product_price']),
              quantity: int.parse(i['order_quantity']),
              imageUrl: i['product_image'],
              unitType: i['order_quantity_type'],
            ),
          );
        }
        invoiceProducts = fetchedCartItems;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('محتويات الفاتورة'),
      ),
      body: FutureBuilder(
        future: getCartItems(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapShot.hasData) {
            return const Center(
              child: Text('خطأ في الاتصال'),
            );
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              itemCount: invoiceProducts.length,
              itemBuilder: (context, i) => ListTile(
                leading:
                    Image.network(invoiceProducts.values.toList()[i].imageUrl!),
                title: Text(invoiceProducts.values.toList()[i].title!),
                subtitle: Text(
                    '${invoiceProducts.values.toList()[i].quantity} ${invoiceProducts.values.toList()[i].unitType}'),
                trailing:
                    Text('${invoiceProducts.values.toList()[i].price} ج.م'),
              ),
            ),
          );
        },
      ),
    );
  }
}
