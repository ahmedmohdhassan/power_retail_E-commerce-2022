import 'package:flutter/material.dart';
import 'package:gomla/constants.dart';
import 'package:gomla/screens/search_screen.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(SearchScreen.routeName);
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[200],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'ابحث باسم المنتج،الشركة أو القسم ...',
                textDirection: TextDirection.rtl,
                style: commonTextStyle.copyWith(
                  color: const Color(0XFFCCCACA),
                ),
              ),
            ),
            const Icon(
              Icons.search,
              color: Color(0XFFCCCACA),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
    );
  }
}
