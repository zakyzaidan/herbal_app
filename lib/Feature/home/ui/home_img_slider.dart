import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:herbal_app/data/models/slider_model.dart';

class HomeImgSlider extends StatefulWidget {
  const HomeImgSlider({super.key});

  @override
  State<HomeImgSlider> createState() => _HomeImgSliderState();
}

class _HomeImgSliderState extends State<HomeImgSlider> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  // Mengambil data dari SliderDataSource
  late final List<SliderData> sliderDataList;

  @override
  void initState() {
    super.initState();
    sliderDataList = SliderDataSource.getSliderData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: sliderDataList.map((data) => _buildSlide(data)).toList(),
          carouselController: _controller,
          options: CarouselOptions(
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enlargeCenterPage: false,
            viewportFraction: 1.0, // Full width
            height: 220, // Lebih tinggi dari sebelumnya
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: sliderDataList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: _current == entry.key ? 24 : 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _current == entry.key
                      ? const Color(0xFF0A400C)
                      : Colors.grey[300],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSlide(SliderData data) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: data.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Opacity(
                opacity: data.overlayImageUrl != null ? 0.3 : 0.1,
                child: Image.network(
                  data.backgroundImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(color: data.gradientColors.first);
                  },
                ),
              ),
            ),

            // Content
            Positioned(
              left: 24,
              top: 0,
              bottom: 0,
              right: data.overlayImageUrl != null ? 120 : 24,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.description,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: data.onButtonPressed ?? () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: data.gradientColors.first,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      data.buttonText,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Overlay image on the right (if exists)
            if (data.overlayImageUrl != null)
              Positioned(
                right: -20,
                top: 0,
                bottom: 0,
                child: Image.network(
                  data.overlayImageUrl!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
// final List<String> imgList = [
//   'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
//   'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
//   'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
//   'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
//   'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
// ];

// final List<Widget> imageSliders = imgList
//     .map(
//       (item) => Container(
//         margin: EdgeInsets.all(5.0),
//         child: ClipRRect(
//           borderRadius: BorderRadius.all(Radius.circular(5.0)),
//           child: Stack(
//             children: <Widget>[
//               Image.network(item, fit: BoxFit.cover, width: 1000.0),
//               Positioned(
//                 bottom: 0.0,
//                 left: 0.0,
//                 right: 0.0,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color.fromARGB(200, 0, 0, 0),
//                         Color.fromARGB(0, 0, 0, 0),
//                       ],
//                       begin: Alignment.bottomCenter,
//                       end: Alignment.topCenter,
//                     ),
//                   ),
//                   padding: EdgeInsets.symmetric(
//                     vertical: 10.0,
//                     horizontal: 20.0,
//                   ),
//                   child: Text(
//                     'No. ${imgList.indexOf(item)} image',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     )
//     .toList();

// class HomeImgSlider extends StatefulWidget {
//   const HomeImgSlider({super.key});

//   @override
//   State<HomeImgSlider> createState() => _HomeImgSliderState();
// }

// class _HomeImgSliderState extends State<HomeImgSlider> {
//   int _current = 0;
//   final CarouselSliderController _controller = CarouselSliderController();

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         CarouselSlider(
//           items: imageSliders,
//           carouselController: _controller,
//           options: CarouselOptions(
//             autoPlay: true,
//             enlargeCenterPage: true,
//             aspectRatio: 2.0,
//             onPageChanged: (index, reason) {
//               setState(() {
//                 _current = index;
//               });
//             },
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: imgList.asMap().entries.map((entry) {
//             return GestureDetector(
//               onTap: () => _controller.animateToPage(entry.key),
//               child: Container(
//                 width: 6.0,
//                 height: 6.0,
//                 margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color:
//                       (Theme.of(context).brightness == Brightness.dark
//                               ? Colors.white
//                               : Colors.black)
//                           .withValues(alpha: _current == entry.key ? 0.9 : 0.4),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
