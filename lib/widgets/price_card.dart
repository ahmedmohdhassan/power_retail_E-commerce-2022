import 'package:flutter/material.dart';

import '../constants.dart';

class PriceCard extends StatelessWidget {
  const PriceCard({
    Key? key,
    required this.title,
    this.newPrice,
    this.oldPrice,
  }) : super(key: key);
  final String? title;
  final double? oldPrice;
  final double? newPrice;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title!,
              style: commonTextStyle.copyWith(
                color: Colors.blue,
                fontSize: 12,
              ),
            ),
            Row(
              children: [
                oldPrice == null
                    ? const Center()
                    : Text(
                        oldPrice!.toStringAsFixed(0),
                        style: commonTextStyle.copyWith(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.black,
                        ),
                      ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  newPrice!.toStringAsFixed(0),
                  style:
                      commonTextStyle.copyWith(color: Colors.red, fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
