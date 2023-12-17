// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gomla/classes/invoices.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/screens/invoice_products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyInvoices extends StatefulWidget {
  static const routeName = 'my_invoices';
  const MyInvoices({Key? key}) : super(key: key);

  @override
  State<MyInvoices> createState() => _MyInvoicesState();
}

class _MyInvoicesState extends State<MyInvoices> {
  List<Invoice> invoicesList = [];

  Future<void> getMyInvoices() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String userId = _prefs.getString('user_id')!;
    var url = Uri.parse(
        'https://eatdevelopers.com/market/api_cart/api.php/?get_invoice=all&clients_id=$userId');

    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        List<Invoice> fetchedInvoices = [];
        for (Map i in jsonData) {
          fetchedInvoices.add(
            Invoice(
              id: i['invoice_id'],
              invoiceNumber: i['invoice_id'],
              invoiceDate: i['invoice_date'],
              clientId: i['invoice_Client_id'],
              invoiceType: i['invoice_type'],
              invoiceValue: i['invoice_value'],
              invoiceReward: i['invoice_reward_value'],
              invoiceDiscount: i['invoice_discount_value'],
            ),
          );
        }
        invoicesList = fetchedInvoices;
      }
    } catch (e) {
      print(e);
    }
  }

  String invoiceStatus(num? invoiceStatus) {
    String? status;

    if (invoiceStatus == 0) {
      status = 'مفتوحة للطلب';
    } else if (invoiceStatus == 1) {
      status = 'طلب جديد';
    } else if (invoiceStatus == 2) {
      status = 'تحت التجهيز';
    } else if (invoiceStatus == 3) {
      status = 'جار الشحن';
    } else if (invoiceStatus == 4) {
      status = 'تم التسليم';
    } else if (invoiceStatus == 6) {
      status = 'طلب ملغي';
    }

    return status!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشترياتك'),
      ),
      body: FutureBuilder(
        future: getMyInvoices(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapShot.hasError) {
            return const Center(
              child: Text('خطأ في الاتصال'),
            );
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: ListView.builder(
              itemCount: invoicesList.length,
              itemBuilder: (context, i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: Material(
                  elevation: 1,
                  child: ExpansionTile(
                    tilePadding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'رقم الفاتورة :  ${invoicesList[i].invoiceNumber!}',
                          textDirection: TextDirection.rtl,
                          style: commonTextStyle.copyWith(color: blue),
                        ),
                        Text(
                          invoicesList[i].invoiceDate!,
                          style: commonTextStyle.copyWith(color: amber),
                        ),
                      ],
                    ),
                    children: [
                      RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                            text: 'قيمة الفاتورة : ',
                            style: commonTextStyle.copyWith(
                              color: blue,
                            ),
                            children: [
                              TextSpan(
                                  text: invoicesList[i].invoiceValue,
                                  style: commonTextStyle.copyWith(
                                    color: amber,
                                  )),
                            ]),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                            text: 'قيمة الخصم : ',
                            style: commonTextStyle.copyWith(
                              color: blue,
                            ),
                            children: [
                              TextSpan(
                                  text: invoicesList[i].invoiceDiscount,
                                  style: commonTextStyle.copyWith(
                                    color: amber,
                                  )),
                            ]),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                            text: 'نقاط المكافأة : ',
                            style: commonTextStyle.copyWith(
                              color: blue,
                            ),
                            children: [
                              TextSpan(
                                  text: invoicesList[i].invoiceReward,
                                  style: commonTextStyle.copyWith(
                                    color: amber,
                                  )),
                            ]),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      RichText(
                        textDirection: TextDirection.rtl,
                        text: TextSpan(
                            text: 'حالة الفاتورة : ',
                            style: commonTextStyle.copyWith(
                              color: blue,
                            ),
                            children: [
                              TextSpan(
                                  text: invoiceStatus(
                                      invoicesList[i].invoiceType),
                                  style: commonTextStyle.copyWith(
                                    color: amber,
                                  )),
                            ]),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.network(
                          'https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=${invoicesList[i].id}&choe=UTF-8',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => InvoiceProducts(
                                  invoiceId: invoicesList[i].id!)));
                        },
                        child: Text(
                          'عرض منتجات الفاتورة',
                          style: commonTextStyle.copyWith(
                            color: blue,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
