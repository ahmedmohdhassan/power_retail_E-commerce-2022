// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:gomla/classes/cart_api.dart';
import 'package:gomla/screens/edit_store_screen.dart';
import 'package:gomla/screens/my_invoices.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../providers/user_provider.dart';
import '../../screens/edit_profile_screen.dart';
import '../../widgets/account_tile.dart';
import '/constants.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({Key? key}) : super(key: key);

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  String? userId;
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImage;
  XFile? pickedFile;

  void getUserId() async {
    SharedPreferences _pref = await SharedPreferences.getInstance();
    setState(() {
      userId = _pref.getString('user_id');
    });
  }

  @override
  void initState() {
    getUserId();
    super.initState();
  }

  Future<void> uploadPhoto(String? userId, XFile? fileToUpload) async {
    if (userId != null) {
      var url = Uri.parse(
          'https://eatdevelopers.com/market/api_cart/api.php?getfile=1&clients_id=$userId');
      try {
        http.MultipartRequest request = http.MultipartRequest('POST', url);

        http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
            'fileToUpload', fileToUpload!.path);

        request.files.add(multipartFile);

        http.StreamedResponse response = await request.send();

        print(response.statusCode);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> fromCamera() async {
    pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile == null) {
      showMyBar(context, 'لم يتم اختيار صورة');
    } else {
      setState(() {
        pickedImage = XFile(pickedFile!.path);
        print(pickedImage!.path);
      });
      uploadPhoto(userId!, pickedImage!).catchError((e) {
        showErrorBar(context);
        return;
      }).then((_) {
        showMyBar(context, 'تم تحميل الصورة بنجاح');
        setState(() {});
      });
    }
  }

  Future<void> fromGallery() async {
    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      showMyBar(context, 'لم يتم اختيار صورة');
    } else {
      setState(() {
        pickedImage = XFile(pickedFile!.path);
        print(pickedImage!.path);
      });
      uploadPhoto(userId!, pickedImage!).catchError((e) {
        showErrorBar(context);
        return;
      }).then((_) {
        showMyBar(context, 'تم تحميل الصورة بنجاح');
        setState(() {});
      });
    }
  }

  void pickImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: const Text(
          'Choose image ...',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              fromCamera();
            },
            child: Row(
              children: const [
                Icon(
                  Icons.camera,
                  color: Colors.blue,
                  size: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'From Camera...',
                    style: TextStyle(
                      color: amber,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.blue,
            thickness: 1,
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
              fromGallery();
            },
            child: Row(
              children: const [
                Icon(
                  Icons.photo_album,
                  color: Colors.blue,
                  size: 30,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'From Gallery...',
                    style: TextStyle(
                      color: amber,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<UserProvider>(context, listen: false)
            .getProfileInfo(context),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapShot.hasError) {
            return const Text('خطأ في الإتصال');
          } else {
            return Consumer<UserProvider>(builder: (context, userData, _) {
              return ListView(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 15.0,
                              offset: const Offset(0.0, 0.75))
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
                                      userData.user.imageUrl!,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 5,
                                left: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    pickImage();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: blue,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'الرصيد',
                                        style: commonTextStyle,
                                      ),
                                      Consumer<CartApi>(
                                          builder: (context, cartData, _) {
                                        return Text(
                                          '${cartData.clientReward}',
                                          style: commonTextStyle,
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      userData.user.userName!,
                                      style: commonTextStyle.copyWith(
                                          color: Colors.blue, fontSize: 20),
                                    ),
                                    Text(
                                      userData.user.storeName!,
                                      softWrap: true,
                                      style: commonTextStyle.copyWith(
                                        fontSize: 10,
                                        color: amber,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          userData.user.userAddress!,
                                          softWrap: true,
                                          textDirection: TextDirection.rtl,
                                          style: commonTextStyle.copyWith(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.location_pin,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          userData.user.userMobile!,
                                          style: commonTextStyle.copyWith(
                                              color: Colors.grey),
                                        ),
                                        const Icon(
                                          Icons.phone_android,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ],
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
                    child: Column(
                      children: [
                        AccountTile(
                          title: 'مشترياتك',
                          icon: Icons.shopping_cart_outlined,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(MyInvoices.routeName);
                          },
                        ),
                        AccountTile(
                          title: 'الملف الشخصي',
                          icon: Icons.file_copy_outlined,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EditProfileScreen.routeName);
                          },
                        ),
                        AccountTile(
                          title: 'الملف التجاري',
                          icon: Icons.file_copy,
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(EditStoreScreen.routeName);
                          },
                        ),
                        SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.network(
                              'https://chart.googleapis.com/chart?chs=300x300&cht=qr&chl=$userId&choe=UTF-8'),
                        ),
                        AccountTile(
                          title: 'تسجيل الخروج',
                          icon: Icons.exit_to_app_outlined,
                          color: Colors.red,
                          onPressed: () {
                            signOut();
                          },
                        )
                      ],
                    ),
                  )
                ],
              );
            });
          }
        });
  }
}
