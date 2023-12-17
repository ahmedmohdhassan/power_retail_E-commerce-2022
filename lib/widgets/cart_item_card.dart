// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/classes/cart_api.dart';
import 'package:provider/provider.dart';

class CartItemCard extends StatefulWidget {
  const CartItemCard({
    Key? key,
    this.id,
    this.title,
    this.itemCount,
    this.productPrice,
    this.packagePrice,
    this.image,
    this.prodId,
    this.unitType,
  }) : super(key: key);

  final String? title;
  final int? itemCount;
  final double? productPrice;
  final double? packagePrice;
  final String? image;
  final String? id;
  final String? prodId;
  final String? unitType;

  @override
  State<CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends State<CartItemCard> {
  bool? isLoading;
  double? itemPrice;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartApi>(context, listen: false);
    if (widget.unitType == 'قطعه') {
      setState(() {
        itemPrice = widget.productPrice;
      });
    } else {
      setState(() {
        itemPrice = widget.packagePrice;
      });
    }
    final double total = widget.itemCount! * itemPrice!;

    return isLoading == true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Dismissible(
              key: ValueKey(widget.id),
              direction: DismissDirection.endToStart,
              background: Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                  vertical: 10,
                ),
                padding: const EdgeInsets.only(right: 20),
                color: Colors.red,
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 40,
                ),
                alignment: Alignment.centerRight,
              ),
              onDismissed: (direction) {
                setState(() {
                  isLoading = true;
                });
                cart
                    .removeCartItem(context, widget.id, widget.prodId)
                    .then((_) {
                  setState(() {
                    isLoading = false;
                  });
                });
              },
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: const Text(
                        'هل تريد تأكيد الحذف من سلة التسوق؟',
                        textDirection: TextDirection.rtl,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text(
                            'لا',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text(
                            'نعم',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Card(
                elevation: 3,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$total ج.م',
                                textDirection: TextDirection.rtl,
                                style: const TextStyle(color: Colors.teal),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${widget.title}',
                                textDirection: TextDirection.rtl,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '$itemPrice  ج.م',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                              Text(
                                '${widget.unitType}',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      if (widget.itemCount! > 1) {
                                        cart.decreaseQuantity(
                                            widget.id!, widget.prodId);
                                        setState(() {
                                          isLoading == true;
                                        });

                                        cart
                                            .updateCartItem(
                                                context,
                                                widget.id!,
                                                widget.unitType!,
                                                widget.itemCount! - 1,
                                                total)
                                            .then((_) {
                                          Provider.of<CartApi>(context,
                                                  listen: false)
                                              .updateInvoice(0)
                                              .catchError((e) {
                                            print(e);
                                          }).then((_) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });
                                        });
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 1),
                                    child: Text(
                                      '${widget.itemCount}',
                                      style: const TextStyle(
                                        color: Colors.blueAccent,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      size: 15,
                                    ),
                                    onPressed: () {
                                      if (widget.itemCount! < 10) {
                                        print(widget.prodId);
                                        cart.increaseQuantity(
                                            widget.id!, widget.prodId);
                                        setState(() {
                                          isLoading == true;
                                        });

                                        cart
                                            .updateCartItem(
                                                context,
                                                widget.id!,
                                                widget.unitType!,
                                                widget.itemCount! + 1,
                                                total)
                                            .then((_) {
                                          Provider.of<CartApi>(context,
                                                  listen: false)
                                              .updateInvoice(0)
                                              .catchError((e) {
                                            print(e);
                                          }).then((_) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                          });
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            child: Image.network(
                              widget.image!,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          );
  }
}

// ListTile(
//           leading: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 'القيمة الكلية',
//                 textDirection: TextDirection.rtl,
//               ),
//               Text(
//                 ' $total ج.م',
//                 textDirection: TextDirection.rtl,
//               ),
//             ],
//           ),
//           title: Text(
//             '$title',
//             textDirection: TextDirection.rtl,
//             overflow: TextOverflow.ellipsis,
//           ),
//           subtitle: Text(
//             '$itemPrice  ج.م       × $itemCount',
//             textDirection: TextDirection.rtl,
//             overflow: TextOverflow.ellipsis,
//           ),
//           trailing: CircleAvatar(
//             radius: 50,
//             backgroundImage: NetworkImage(
//               image,
//             ),
//             backgroundColor: Colors.white,
//           ),
//         ),

// Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Column(
//               children: [
//                 Text(
//                   'القيمة الكلية',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).accentColor,
//                   ),
//                 ),
//                 Text(
//                   '${(itemCount * itemPrice)}',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.teal,
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 Text(
//                   'سعر الوحدة',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).accentColor,
//                   ),
//                 ),
//                 Text(
//                   '$itemPrice',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.teal,
//                   ),
//                 ),
//               ],
//             ),
//             Column(
//               children: [
//                 Text(
//                   'العدد',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Theme.of(context).accentColor,
//                   ),
//                 ),
//                 Text(
//                   '$itemCount',
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//             Expanded(
//               child: Text(
//                 title,
//                 textDirection: TextDirection.rtl,
//                 softWrap: true,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).accentColor,
//                 ),
//               ),
//             ),
//           ],
//         ),
