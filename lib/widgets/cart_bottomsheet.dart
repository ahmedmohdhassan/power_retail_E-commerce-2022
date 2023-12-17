// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/classes/cart_api.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class CartBottomSheet extends StatefulWidget {
  const CartBottomSheet({
    Key? key,
    required this.productId,
    required this.imageUrl,
    required this.prodName,
    required this.price,
    required this.packPrice,
  }) : super(key: key);
  final int? productId;
  final String? imageUrl;
  final String? prodName;
  final double? price;
  final double? packPrice;

  @override
  State<CartBottomSheet> createState() => _CartBottomSheetState();
}

class _CartBottomSheetState extends State<CartBottomSheet> {
  bool isVisible = false;
  String? selectedunit;
  int itemCount = 0;
  List<String> unitTypes = [
    'عبوة كاملة',
    'قطعه',
  ];
  DropdownButton dropDown() {
    List<DropdownMenuItem> unitItems = [];
    for (String i in unitTypes) {
      DropdownMenuItem item = DropdownMenuItem(
        child: Center(child: Text(i)),
        value: i,
      );
      unitItems.add(item);
    }
    return DropdownButton(
      items: unitItems,
      value: selectedunit,
      onChanged: (val) {
        setState(() {
          selectedunit = val;
        });
      },
      icon: const Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.blue,
      ),
      isExpanded: true,
      hint: Text(
        'اختر نوع الوحدة',
        style: commonTextStyle.copyWith(
          color: Colors.blueGrey,
        ),
      ),
      underline: const SizedBox(),
      style: commonTextStyle.copyWith(
        color: Colors.blueGrey,
      ),
      itemHeight: 50,
    );
  }

  void increase() {
    setState(() {
      itemCount++;
    });
  }

  void decrease() {
    if (itemCount > 0) {
      setState(() {
        itemCount--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(25),
        topLeft: Radius.circular(25),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 10,
            ),
            Center(
                child: Text(
              'أضف للسلة',
              style: commonTextStyle.copyWith(
                color: Colors.blueGrey,
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: SizedBox(
                height: 2,
                child: Container(
                  color: Colors.black,
                ),
              ),
            ),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: [
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'نوع الوحدة :',
                              style: commonTextStyle.copyWith(
                                  color: Colors.blueGrey),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blueGrey,
                                width: 2,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            width: 200,
                            child: dropDown(),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'عدد الوحدات :',
                              style: commonTextStyle.copyWith(
                                  color: Colors.blueGrey),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                onPressed: increase,
                                child: Text(
                                  '+',
                                  style: commonTextStyle.copyWith(
                                      color: Colors.blueGrey),
                                ),
                              ),
                              Text(
                                '$itemCount',
                                style: commonTextStyle.copyWith(
                                    color: Colors.blueGrey),
                              ),
                              TextButton(
                                onPressed: decrease,
                                child: Text(
                                  '-',
                                  style: commonTextStyle.copyWith(
                                      color: Colors.blueGrey),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'إلغاء',
                                  style: commonTextStyle.copyWith(
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Row(
                              children: [
                                const Icon(Icons.add_shopping_cart_outlined,
                                    color: Colors.green),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  'أضف للسلة',
                                  style: commonTextStyle.copyWith(
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                            onPressed: () {
                              double? currentPrice;
                              selectedunit == 'قطعه'
                                  ? currentPrice = widget.price!
                                  : currentPrice = widget.packPrice!;
                              if (selectedunit != null &&
                                  itemCount != 0 &&
                                  widget.productId != null) {
                                Provider.of<CartApi>(context, listen: false)
                                    .createInvoice()
                                    .catchError((e) {
                                  print(e);
                                }).then((value) {
                                  double orderPrice = itemCount * currentPrice!;
                                  Provider.of<CartApi>(context, listen: false)
                                      .addItemToCart(
                                          context,
                                          value,
                                          selectedunit,
                                          widget.productId,
                                          itemCount,
                                          orderPrice)
                                      .then((_) {
                                    Provider.of<CartApi>(context, listen: false)
                                        .updateInvoice(0)
                                        .then(
                                            (_) => Navigator.of(context).pop());
                                  });
                                });
                              } else {
                                setState(() {
                                  isVisible = true;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      Visibility(
                        visible: isVisible,
                        child: Center(
                          child: Text(
                            'من فضلك اختر نوع الوحدة و العدد المطلوب',
                            style: commonTextStyle.copyWith(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
