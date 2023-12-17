// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/constants.dart';
import '../../classes/cart_api.dart';
import 'package:provider/provider.dart';
import '../../widgets/cart_item_card.dart';
import '../../widgets/summary_card.dart';

class CartTab extends StatelessWidget {
  const CartTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<CartApi>(context, listen: false).getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('خطأ في الاتصال'),
            );
          }
          return Consumer<CartApi>(builder: (context, cartData, _) {
            return Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: cartData.items.isNotEmpty
                        ? Text(
                            '<-- إسحب العنصر لإزالته من سلة التسوق <--',
                            style: TextStyle(color: Colors.grey[500]),
                          )
                        : const Text(''),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartData.items.length,
                    itemBuilder: (context, i) => CartItemCard(
                      prodId: cartData.items.values.toList()[i].id,
                      id: cartData.items.keys.toList()[i],
                      title: cartData.items.values.toList()[i].title,
                      itemCount: cartData.items.values.toList()[i].quantity,
                      productPrice: cartData.items.values.toList()[i].unitPrice,
                      packagePrice: cartData.items.values.toList()[i].packPrice,
                      image: cartData.items.values.toList()[i].imageUrl,
                      unitType: cartData.items.values.toList()[i].unitType,
                    ),
                  ),
                ),
                SummaryCard(
                  value: '${cartData.totalCost.toStringAsFixed(2)}  ج.م',
                  onBuyPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text('تأكيد طلب الشراء'),
                        content: const Text(
                          'موافق على ارسال هذه الفاتورة؟ ',
                          softWrap: true,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('لا'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<CartApi>(context, listen: false)
                                  .updateInvoice(1)
                                  .catchError((e) {
                                return;
                              }).then((value) {
                                Navigator.of(context).pop();
                                showMyBar(context, 'تم ارسال طلب الشراء بنجاح');
                              });
                            },
                            child: const Text('نعم'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            );
          });
        });
  }
}
