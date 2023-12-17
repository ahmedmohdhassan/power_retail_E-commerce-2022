import 'package:flutter/material.dart';
import '../providers/productsProvider.dart';
import 'package:provider/provider.dart';
import 'custom_gridtile.dart';

class NewProdWidget extends StatelessWidget {
  const NewProdWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ProductsProvider>(context, listen: false)
            .getNewProducts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SliverToBoxAdapter(
              child: Center(
                child: Text('${snapshot.error}'),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const SliverToBoxAdapter(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return Consumer<ProductsProvider>(
              builder: (context, prodData, _) => prodData.items.isEmpty
                  ? const SliverToBoxAdapter(child: Text('empty'))
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => CustomGridTile(
                          id: prodData.prodItems[i].id!,
                          productName: prodData.prodItems[i].name!,
                          imageUrl: prodData.prodItems[i].imageUrl!,
                          newPrice: prodData.prodItems[i].newPrice!,
                          packPrice: prodData.prodItems[i].packagePrice!,
                        ),
                        childCount: prodData.prodItems.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 3 / 4,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10),
                    ),
            );
          }
        });
  }
}
