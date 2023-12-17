import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gomla/providers/adslider_provider.dart';
import 'package:provider/provider.dart';

class AdsBanner extends StatelessWidget {
  const AdsBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      color: Colors.grey[200],
      child: Consumer<AdSliderProvider>(
        builder: (context, sliderData, _) => CarouselSlider.builder(
          itemCount: sliderData.adSliderItems.length,
          itemBuilder: (context, i, index) => SizedBox(
            width: double.infinity,
            child: Image.network(
              sliderData.adSliderItems[i].imageUrl!,
              fit: BoxFit.fill,
            ),
          ),
          options: CarouselOptions(
            autoPlay: true,
          ),
        ),
      ),
    );
  }
}



//  [
//           SizedBox(
//             width: double.infinity,
//             child: Image.network(
//               'https://cdn.pixabay.com/photo/2020/10/06/11/55/woman-5632026_960_720.jpg',
//               fit: BoxFit.fill,
//             ),
//           ),
//           SizedBox(
//             width: double.infinity,
//             child: Image.network(
//               'https://cdn.pixabay.com/photo/2020/10/06/11/55/woman-5632026_960_720.jpg',
//               fit: BoxFit.fill,
//             ),
//           ),
//           SizedBox(
//             width: double.infinity,
//             child: Image.network(
//               'https://cdn.pixabay.com/photo/2020/10/06/11/55/woman-5632026_960_720.jpg',
//               fit: BoxFit.fill,
//             ),
//           ),
//         ]