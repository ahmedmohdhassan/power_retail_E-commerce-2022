// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gomla/classes/reward.dart';

import '../classes/cart_item_class.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'discount.dart';

class CartApi with ChangeNotifier {
  Map<String?, CartItem> _items = {};
  Map<String?, CartItem> get items {
    return {..._items};
  }

  List<Discount> _discounts = [];
  List<Discount> get discounts => [..._discounts];

  List<Reward> _rewards = [];
  List<Reward> get rwards => [..._rewards];

  String get clientDiscount {
    Discount? dis = _discounts.firstWhere(
        (element) => double.parse(element.billValue!) < totalCost,
        orElse: () => Discount(
              id: 0,
              billValue: '0',
              discountValue: '0',
            ));
    return dis.discountValue!;
  }

  int get itemCount {
    return _items.length;
  }

  double get totalCost {
    double total = 0;
    _items.forEach((key, CartItem cartItem) {
      total += cartItem.quantity * cartItem.price!;
    });
    return total;
  }

  double get clientReward {
    double total = 0;
    if (_rewards.isNotEmpty) {
      for (Reward i in _rewards) {
        total += (double.parse(i.reward!));
      }
    }
    return total;
  }

  double get rewardId {
    if (_rewards.isEmpty) {
      return 0;
    }
    return _rewards.last.id!;
  }
// CHECK FOR OPEN INVOICE OR CREATE NEW ONE API CALL:

  Future<String> createInvoice() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString('user_id')!;
    String invoiceId = _pref.getString('invoice_id') ?? 'null';
    if (invoiceId == 'null') {
      var url = Uri.parse(
          'https://eatdevelopers.com/market/api_cart/api.php/?add_invoice=all&Clients_id=$userId');

      try {
        var response = await http.get(url);
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          if (jsonData['result'] != null) {
            String newInvoiceId = '${jsonData['result']}';
            _pref.setString('invoice_id', newInvoiceId);
            print(newInvoiceId);
            invoiceId = newInvoiceId;
          }
        }
        notifyListeners();
      } catch (e) {
        print(e);
      }
    }
    print(invoiceId);
    return invoiceId;
  }

// ADD A NEW ITEM TO THE CART:

  Future<void> addItemToCart(
      BuildContext context,
      String? invoiceId,
      String? unitType,
      int? productId,
      int? quantity,
      double? orderPrice) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString('user_id')!;
    print('$userId,$invoiceId,$productId,$quantity,$orderPrice');

    var url = Uri.parse(
      'https://eatdevelopers.com/market/api_cart/api.php/?add_orders=all&product_id=$productId&order_quantity=$quantity&order_quantity_type=$unitType&order_Client_id=$userId&order_invoice_id=$invoiceId&order_price=$orderPrice',
    );

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      print(response.body);
      if (jsonData['result'] == 1) {
        showMyBar(context, 'تمت اضافة المنتج للسلة بنجاح');
        getCartItems();
        notifyListeners();
      } else {
        showErrorBar(context);
      }
    }
  }

// GET CART ITEMS API CALL:

  Future<void> getCartItems() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String invoiceId = _pref.getString('invoice_id') ?? 'null';
    if (invoiceId != 'null') {
      var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_orders=all&invoice_id=$invoiceId',
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
                packPrice: double.parse(i['product_price_Package']),
                quantity: int.parse(i['order_quantity']),
                imageUrl: i['product_image'],
                unitType: i['order_quantity_type'],
              ),
            );
          }
          _items = fetchedCartItems;
          notifyListeners();
        }
      } catch (e) {
        print(e);
      }
    }
  }

// REMOVE A SINGLE ITEM FROM CART:
  Future<void> removeCartItem(
      BuildContext context, String? cartItemId, String? prodId) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String invoiceId = _pref.getString('invoice_id') ?? 'null';
    if (invoiceId != 'null') {
      var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?remove_orders=all&invoice_id=$invoiceId&order_id=$cartItemId',
      );
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['result'] == 1) {
          _items.remove(prodId);
          getCartItems();
          notifyListeners();
          showMyBar(context, 'تم الحذف بنجاح');
        }
      }
    } else {
      showErrorBar(context);
    }
  }

// INCREASE A CART ITEM QUANTITY:
  void increaseQuantity(String orderId, String? productId) {
    _items.update(
      '$orderId',
      (existingItem) => CartItem(
        id: productId!,
        title: existingItem.title,
        price: existingItem.price,
        packPrice: existingItem.packPrice,
        unitPrice: existingItem.unitPrice,
        quantity: existingItem.quantity + 1,
        imageUrl: existingItem.imageUrl,
        unitType: existingItem.unitType,
      ),
    );
    notifyListeners();
  }

// DECREASE A CART ITEM QUANTITY:
  void decreaseQuantity(String orderId, String? productId) {
    _items.update(
      '$orderId',
      (existingItem) => CartItem(
        id: productId!,
        title: existingItem.title,
        price: existingItem.price,
        packPrice: existingItem.packPrice,
        unitPrice: existingItem.unitPrice,
        quantity: existingItem.quantity - 1,
        imageUrl: existingItem.imageUrl,
        unitType: existingItem.unitType,
      ),
    );
    notifyListeners();
  }

// UPDATING QUANTITY FOR CART ITEM:
  Future<void> updateCartItem(BuildContext context, String orderId,
      String unitType, int? quantity, double? orderPrice) async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?update_orders=all&order_id=$orderId&order_quantity=$quantity&order_price=$orderPrice&order_quantity_type=$unitType');

    var response = await http.get(url);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['result'] == '1') {
        showMyBar(context, 'تم تعديل الكمية بنجاح');
        notifyListeners();
      } else {
        showErrorBar(context);
      }
    }
  }

// FETCHING DISCOUNT LIST:
  Future<void> fetchDiscountList() async {
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_discount_list=all');

    try {
      var response = await http.get(url);
      List<Discount> fetchedDiscounts = [];
      print(response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        for (Map i in jsonData) {
          fetchedDiscounts.add(
            Discount(
              id: i['discount_id'],
              billValue: i['discount_bill_value'],
              discountValue: i['discount_value'],
              validity: i['discount_validity'],
            ),
          );
        }
        _discounts = fetchedDiscounts;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

// FETCHING THE REWARD POINTS OF THE CLIENT
  Future<void> fetchClientReward() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString('user_id')!;
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_clients_reward=all&client_id=$userId');

    var response = await http.get(url);
    List<Reward> fetchedRewards = [];
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      for (Map i in jsonData) {
        fetchedRewards.add(
          Reward(
            id: i['Clients_reward_id'],
            reward: i['Clients_reward_cost'],
            rewardType: i['Clients_reward_type'],
            expDate: i['Clients_reward_exp'],
          ),
        );
      }
      _rewards = fetchedRewards;
      notifyListeners();
    }
  }

// UPDATING INVOICES AFTER ADDING OR CHANGING QUANTITY:
  Future<void> updateInvoice(int? invoiceType) async {
    String? invoiceId;
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString('user_id')!;
    invoiceId = _pref.getString('invoice_id');

    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?update_invoice=update&invoice_id=$invoiceId&clients_id=$userId&invoice_date=${DateTime.now().toString()}&invoice_type=$invoiceType&invoice_value=$totalCost&invoice_number=0&reward=$clientReward&reward_id=$rewardId&discount=$clientDiscount');
    if (invoiceId != null) {
      try {
        var response = await http.get(url);
        print(response.statusCode);
        print(response.body);
        if (response.statusCode == 200) {
          var jsonData = jsonDecode(response.body);
          if (jsonData['result'] == '1') {
            print('invoice Updated');
            print(
                '$totalCost, $userId, $invoiceId, $rewardId, $clientDiscount, $clientReward,');
            if (invoiceType != 0) {
              print('تم ارسال طلب الشراء');
              _items.clear();
              _pref.remove('invoice_id');
            }
          } else {
            print(
                '$totalCost, $userId, $invoiceId, $rewardId, $clientDiscount, $clientReward,');
            print('invoice did not update');
          }
        }
      } catch (e) {
        print(e);
      }
    }
  }

// CLEARING THE CART FROM ALL ITEMS:
  Future<void> clearCart(BuildContext context) async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    String userId = _pref.getString('user_id')!;
    String invoiceId = _pref.getString('invoice_id')!;

    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?remove_bill=remove&clients_id=$userId&invoice_id=$invoiceId');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      if (jsonData['result'] == 1) {
        showMyBar(context, 'تم مسح كل العناصر من سلة التسوق');
        _items.clear();
        _pref.remove('invoice_id');

        notifyListeners();
      } else {
        showErrorBar(context);
      }
    }
  }
}
