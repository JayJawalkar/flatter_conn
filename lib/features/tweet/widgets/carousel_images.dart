import 'package:carousel_slider/carousel_slider.dart';
import 'package:flatter_conn/theme/pallete.dart';
import 'package:flutter/material.dart';

class CarouselImages extends StatefulWidget {
  final List<String> imageLinks;
  const CarouselImages({super.key, required this.imageLinks});

  @override
  State<CarouselImages> createState() => _CarouselImagesState();
}

class _CarouselImagesState extends State<CarouselImages> {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            CarouselSlider(
              items: widget.imageLinks.map((link) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  margin: const EdgeInsets.all(10),
                  child: Image.network(
                    link,
                    fit: BoxFit.contain,
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height * 0.3,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.imageLinks.asMap().entries.map(
                (e) {
                  return Container(
                    width: 12,
                    height: 12,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Pallete.whiteColor.withOpacity(
                        _current == e.key ? 0.9 : 0.4,
                      ),
                    ),
                  );
                },
              ).toList(),
            )
          ],
        )
      ],
    );
  }
}
