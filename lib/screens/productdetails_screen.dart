// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gomla/widgets/cart_bottomsheet.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

import '../widgets/price_card.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const routeName = 'product_details_screen';
  const ProductDetailsScreen({
    Key? key,
    required this.productId,
  }) : super(key: key);
  final int? productId;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  String? productName;
  String? companyName;
  String? productDetails;
  String? productImage;
  String? productCompId;
  double? oldPackPrice;
  double? packagePrice;
  double? oldProdPrice;
  double? productPrice;
  double? packageunits;
  double? productPoints;

  Future<void> getProductInfo() async {
    if (widget.productId != null) {
      debugPrint('${widget.productId}');
      var url = Uri.parse(
          'https://eatdevelopers.com/market/api_cart/api.php/?get_product=all&product_id=${widget.productId}');

      try {
        var response = await http.get(url);
        debugPrint('${response.statusCode}');
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          productImage = jsonData[0]['product_image'];
          productName = jsonData[0]['product_name'];
          productDetails = jsonData[0]['product_description'];
          packagePrice = double.parse(jsonData[0]['product_price_Package']);
          productPrice = double.parse(jsonData[0]['product_price']);
          productCompId = '${jsonData[0]['product_manufacturer_id']}';
          packageunits = double.parse(jsonData[0]['product_units_pack']);
          productPoints = double.parse(jsonData[0]['product_points']);
          var url2 = Uri.parse(
              'https://eatdevelopers.com/market/api_cart/api.php/?get_manufactory=all&manufactory_id=$productCompId');
          var response2 = await http.get(url2);
          if (response2.statusCode == 200) {
            var jsonData = jsonDecode(response2.body);
            companyName = jsonData[0]['manufactory_name'];
          }
        }
      } catch (e) {
        debugPrint('$e');
      }
    }
  }

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
          offerPackPrice = double.parse(jsonData[0]['offer_price_Package']);
          priceWithoutOffer = double.parse(jsonData[0]['product_price']);
        });
      }
    }
  }

  bool isFavorite = false;
  bool isLoading = false;
  double? offerPrice;
  double? offerPackPrice;
  double? priceWithoutOffer;

  @override
  void initState() {
    if (widget.productId != null) {
      checkFav(widget.productId!);
      checkOffer(widget.productId!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getProductInfo(),
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapShot.hasError) {
              return const Center(
                child: Text('خطأ في الاتصال'),
              );
            } else {
              return ListView(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black54,
                              blurRadius: 15.0,
                              offset: Offset(0.0, 0.75))
                        ]),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      productImage ??
                                          'https://cdn.pixabay.com/photo/2016/04/24/19/39/supermarket-1350474_960_720.jpg',
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                right: 5,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      if (isFavorite == true) {
                                        removeFromWishList(widget.productId);
                                      } else {
                                        addToFavorites(
                                                context, widget.productId)
                                            .then((value) {
                                          if (value == true) {
                                            setState(() {
                                              isFavorite = true;
                                            });
                                          }
                                        });
                                      }
                                    },
                                    icon: Icon(
                                        isFavorite == false
                                            ? Icons.favorite_border
                                            : Icons.favorite,
                                        color: Colors.blue),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  productName ?? 'اسم المنتج',
                                  softWrap: true,
                                  style: commonTextStyle.copyWith(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  companyName ?? 'اسم الشركة',
                                  softWrap: true,
                                  style: commonTextStyle.copyWith(
                                    color: amber,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      PriceCard(
                                        title: 'سعر القطعه',
                                        oldPrice: offerPrice == null
                                            ? 0
                                            : productPrice,
                                        newPrice: offerPrice ?? productPrice,
                                      ),
                                      PriceCard(
                                        title: 'سعر العبوة',
                                        oldPrice: offerPackPrice == null
                                            ? 0
                                            : packagePrice,
                                        newPrice:
                                            offerPackPrice ?? packagePrice,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      child: Material(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'وصف المنتج',
                                style: commonTextStyle.copyWith(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                child: Text(
                                  productDetails ?? 'lorem Ipsum',
                                  softWrap: true,
                                  textAlign: TextAlign.justify,
                                  style: commonTextStyle.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'عدد قطع العبوة: $packageunits قطعه',
                                    style: commonTextStyle.copyWith(
                                      color: Colors.grey,
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
                  Container(
                    height: 60,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 15),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Scaffold.of(context)
                            .showBottomSheet((context) => CartBottomSheet(
                                  productId: widget.productId,
                                  imageUrl: productImage,
                                  prodName: productName,
                                  price: productPrice,
                                  packPrice: packagePrice,
                                ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'اطلب الان',
                            style: commonTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          }),
    );
  }
}
