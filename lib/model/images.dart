import 'dart:math';

class Images {
  Images();
  List<String> imagePathes = [
    "images/home_image.png",
    "images/home_image2.png",
    "images/home_image3.png",
    "images/home_image4.png",
    "images/home_image5.png",
  ];

  String getImagePath() {
    final random = Random();
    int randomIndex = random.nextInt(imagePathes.length);
    return imagePathes[randomIndex];
  }
}
