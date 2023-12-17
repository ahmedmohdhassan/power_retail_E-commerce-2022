// ignore_for_file: avoid_print
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../screens/productdetails_screen.dart';
import 'cart_bottomsheet.dart';

class CustomGridTile extends StatefulWidget {
  const CustomGridTile({
    this.id,
    this.imageUrl,
    this.newPrice,
    this.oldPrice,
    this.productName,
    this.packPrice,
    Key? key,
  }) : super(key: key);
  final int? id;
  final String? imageUrl;
  final String? productName;
  final double? newPrice;
  final double? oldPrice;
  final double? packPrice;

  @override
  State<CustomGridTile> createState() => _CustomGridTileState();
}

class _CustomGridTileState extends State<CustomGridTile> {
  Future<bool> addToFavorites(BuildContext context, int? productId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var userId = _prefs.getString('user_id');
    bool? result;
    String url =
        'https://eatdevelopers.com/market/api_cart/api.php/?wishlistadd=add&Clients_id=$userId&product_id=$productId';

    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == 'Success') {
          result = true;
          showMyBar(context, 'تم الإضافة لقائمة المفضلات');
        } else {
          result = false;
        }
      }
    } catch (e) {
      print(e);
    }
    return result!;
  }

  Future<void> checkFav(int prodId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userId;
    setState(() {
      userId = _prefs.getString('user_id');
    });
    String url =
        'https://eatdevelopers.com/market/api_cart/api.php/?wishlist=show&Clients_id=$userId&product_id=$prodId';
    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        List jsonData = jsonDecode(response.body);
        if (jsonData[0].containsKey('Clients_wishlist_id')) {
          setState(() {
            isFavorite = true;
          });
        } else {
          setState(() {
            isFavorite = false;
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> checkOffer(int? productId) async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_offers_list=$productId');
    var response = await http.get(url);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List jsonData = jsonDecode(response.body);
      if (jsonData[0].containsKey('offer_id')) {
        setState(() {
          offerPrice = double.parse(jsonData[0]['offer_new_price']);
          priceWithoutOffer = double.parse(jsonData[0]['product_price']);
        });
      }
    }
  }

  Future<void> removeFromWishList(int? productId) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userId;
    setState(() {
      userId = _prefs.getString('user_id');
    });
    String url =
        'https://eatdevelopers.com/market/api_cart/api.php/?wishlistremoveone=remove&Clients_id=$userId&product_id=$productId';

    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] != 'Success') {
          setState(() {
            isFavorite = true;
          });
        } else {
          setState(() {
            isFavorite = false;
          });
          showMyBar(context, 'تم الحذف من قائمة المفضلات');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  bool isFavorite = false;
  bool isLoading = false;
  double? offerPrice;
  double? priceWithoutOffer;
  @override
  void initState() {
    if (widget.id != null) {
      checkOffer(widget.id!);
      checkFav(widget.id!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(
                  productId: widget.id,
                )));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                widget.imageUrl!,
              ),
              fit: BoxFit.fill,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                height: 80,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.productName!,
                        overflow: TextOverflow.ellipsis,
                        style: commonTextStyle.copyWith(
                            color: const Color(0XFF483457)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (kDebugMode) {
                                print('cart pressed');
                              }
                              Scaffold.of(context)
                                  .showBottomSheet((context) => CartBottomSheet(
                                        prodName: widget.productName,
                                        productId: widget.id,
                                        imageUrl: widget.imageUrl,
                                        price: widget.newPrice,
                                        packPrice: widget.packPrice,
                                      ));
                            },
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Color(0XFF483457),
                            ),
                          ),
                          Row(
                            children: [
                              offerPrice == null
                                  ? const Center()
                                  : Text(
                                      '$priceWithoutOffer \$',
                                      style: commonTextStyle.copyWith(
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        fontSize: 12,
                                      ),
                                    ),
                              const SizedBox(
                                width: 5,
                              ),
                              offerPrice == null
                                  ? Text(
                                      '${widget.newPrice} \$',
                                      style: commonTextStyle.copyWith(
                                          color: const Color(0XFF0D198F)),
                                    )
                                  : Text(
                                      '$offerPrice \$',
                                      style: commonTextStyle.copyWith(
                                          color: const Color(0XFF0D198F)),
                                    ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 60,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                ),
                child: IconButton(
                  icon: Icon(
                    isFavorite == false
                        ? Icons.favorite_border_outlined
                        : Icons.favorite,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    if (isFavorite == true) {
                      removeFromWishList(widget.id);
                    } else {
                      addToFavorites(context, widget.id).then((value) {
                        if (value == true) {
                          setState(() {
                            isFavorite = true;
                          });
                        }
                      });
                    }

                    print('favorite pressed');
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
