// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gomla/classes/auth_api.dart';
import 'package:gomla/classes/location_item.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/widgets/login_button.dart';
import 'package:http/http.dart' as http;

import '../widgets/custom_form_field.dart';

class EditStoreScreen extends StatefulWidget {
  static const routeName = 'edit_store_screen';
  const EditStoreScreen({Key? key}) : super(key: key);

  @override
  State<EditStoreScreen> createState() => _EditStoreScreenState();
}

class _EditStoreScreenState extends State<EditStoreScreen> {
  final AuthApi _api = AuthApi();
  final _form = GlobalKey<FormState>();
  List<LocationItem> locations = [];
  List<LocationItem> subLocations = [];
  Future<void> getLocations() async {
    String url =
        'https://eatdevelopers.com/market/api_cart/api.php/?get_location=all';

    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<LocationItem> fetchedLocations = [];
        var jsonData = jsonDecode(response.body);
        for (Map i in jsonData) {
          fetchedLocations.add(LocationItem(
              id: '${i['location_id']}', name: i['location_name']));
        }
        locations = fetchedLocations;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSubLocations(String location) async {
    String url =
        'https://eatdevelopers.com/market/api_cart/api.php/?get_location=all&location_sub=$location';

    try {
      var response = await http.get(Uri.parse(url));
      print(response.statusCode);
      if (response.statusCode == 200) {
        List<LocationItem> fetchedLocations = [];
        var jsonData = jsonDecode(response.body);
        for (Map i in jsonData) {
          fetchedLocations.add(LocationItem(
              id: '${i['location_id']}', name: i['location_name']));
        }
        setState(() {
          subLocations = fetchedLocations;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  DropdownButton getlocationButton() {
    List<DropdownMenuItem<String>> locList = [];
    for (LocationItem loc in locations) {
      var newItem = DropdownMenuItem(
        child: Text(
          loc.name!,
          textAlign: TextAlign.end,
          style: commonTextStyle.copyWith(color: const Color(0xFFCCCACA)),
        ),
        value: loc.id,
      );
      locList.add(newItem);
    }
    var newButton = DropdownButton(
      hint: Text(
        'اختر المنطقة',
        style: commonTextStyle.copyWith(color: const Color(0xFFCCCACA)),
      ),
      itemHeight: 58.0,
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.grey,
      ),
      iconSize: 35.0,
      underline: const Divider(
        color: Colors.transparent,
      ),
      focusNode: locationNode,
      value: location,
      items: locList,
      onChanged: (String? value) {
        setState(() {
          location = value;
          print(location);
        });
        getSubLocations(location!);
      },
    );
    return newButton;
  }

  DropdownButton getSubLocationButton() {
    List<DropdownMenuItem<String>> subLocList = [];
    for (LocationItem loc in subLocations) {
      var newItem = DropdownMenuItem(
        child: Text(
          loc.name!,
          textAlign: TextAlign.end,
          style: commonTextStyle.copyWith(color: const Color(0xFFCCCACA)),
        ),
        value: loc.id,
      );
      subLocList.add(newItem);
    }
    var newButton = DropdownButton(
      hint: Text(
        'اختر المنطقة',
        style: commonTextStyle.copyWith(color: const Color(0xFFCCCACA)),
      ),
      itemHeight: 58.0,
      isExpanded: true,
      icon: const Icon(
        Icons.arrow_drop_down_circle,
        color: Colors.grey,
      ),
      iconSize: 35.0,
      underline: const Divider(
        color: Colors.transparent,
      ),
      focusNode: locationNode,
      value: subLocation,
      items: subLocList,
      onChanged: (String? value) {
        setState(() {
          subLocation = value;
          print(subLocation);
        });
      },
    );
    return newButton;
  }

  saveform() {
    _form.currentState!.validate();
    bool valid = _form.currentState!.validate();
    if (valid) {
      _form.currentState!.save();
      if (location != null && subLocation != null && lat != null) {
        setState(() {
          isLoading = true;
        });
        _api
            .updateStoreProfile(
          context,
          storeName!,
          lat!,
          long!,
          mobile!,
          address!,
          subLocation!,
        )
            .catchError((e) {
          print(e);
          showErrorBar(context);
          return;
        }).then((_) {
          setState(() {
            isLoading = false;
          });
          showMyBar(context, 'تم التعديل بنجاح');
        });
      } else {
        showMyBar(context, 'كل الخانات مطلوبة لا يجب تجاهل اياً منها');
      }
    }
  }

  String? storeName;
  double? lat;
  double? long;
  String? mobile;
  String? address;
  String? location;
  String? subLocation;
  bool? isLoading = false;
  bool? buttonLoading;
  final storeNode = FocusNode();
  final mobileNode = FocusNode();
  final addressNode = FocusNode();
  final latLongNode = FocusNode();
  final locationNode = FocusNode();

  @override
  void dispose() {
    addressNode.dispose();
    storeNode.dispose();
    mobileNode.dispose();
    latLongNode.dispose();
    locationNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    getLocations().catchError((e) {
      print(e);
      return;
    }).then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الملف التجاري')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: isLoading == true
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _form,
                child: ListView(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: CustomFormField(
                        focusNode: storeNode,
                        labelText: 'اسم النشاط',
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'أدخل اسم النشاط';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (String? value) {
                          setState(() {
                            storeName = value;
                          });
                        },
                        onSubmitted: (String? value) {
                          setState(() {
                            storeName = value;
                          });
                          FocusScope.of(context).requestFocus(mobileNode);
                        },
                        onSaved: (String? value) {
                          setState(() {
                            storeName = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: CustomFormField(
                        focusNode: mobileNode,
                        labelText: 'رقم الهاتف',
                        textInputType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'أدخل رقم الهاتف';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (String? value) {
                          setState(() {
                            mobile = value;
                          });
                        },
                        onSubmitted: (String? value) {
                          setState(() {
                            mobile = value;
                          });
                          FocusScope.of(context).requestFocus(addressNode);
                        },
                        onSaved: (String? value) {
                          setState(() {
                            mobile = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: CustomFormField(
                        focusNode: addressNode,
                        labelText: 'عنوان النشاط',
                        textInputType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'أدخل عنوان النشاط';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (String? value) {
                          setState(() {
                            address = value;
                          });
                        },
                        onSubmitted: (String? value) {
                          setState(() {
                            address = value;
                          });
                          FocusScope.of(context).requestFocus(locationNode);
                        },
                        onSaved: (String? value) {
                          setState(() {
                            address = value;
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: getlocationButton(),
                        ),
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(25))),
                      ),
                    ),
                    subLocations.isEmpty
                        ? const Center()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: subLocations.isEmpty
                                    ? const Text('')
                                    : getSubLocationButton(),
                              ),
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: buttonLoading == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : OnTapFormField(
                              onTap: () {
                                setState(() {
                                  buttonLoading = true;
                                });
                                determinePosition().then((_) {
                                  setState(() {
                                    buttonLoading = false;
                                  });
                                  showMyBar(context, 'تم تحديد الموقع بنجاح');
                                });
                              },
                              labelText: 'تحديد الموقع',
                              focusNode: latLongNode,
                            ),
                    ),
                    LogInButton(
                      text: 'تعديل',
                      onTap: () {
                        saveform();
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showMyBar(context, ' من فضلك قم بتشغيل الوصول للموقع');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showMyBar(context, 'تم رفض الوصول للموقع');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      showMyBar(context, ' تم رفض الوصول للموقع نهائياً');
    }
    var position = await Geolocator.getCurrentPosition();
    print('${position.latitude}, ${position.longitude}');
    setState(() {
      lat = position.latitude;
      long = position.longitude;
    });
    return position;
  }
}
