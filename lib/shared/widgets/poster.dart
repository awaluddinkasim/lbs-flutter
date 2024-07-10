import 'package:flutter/material.dart';
import 'package:locomotive21/shared/constants.dart';

class PosterImage extends StatelessWidget {
  final String img;

  const PosterImage({super.key, required this.img});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: img,
          child: Image.network(
            "${Constants.baseUrl}/poster/$img",
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
