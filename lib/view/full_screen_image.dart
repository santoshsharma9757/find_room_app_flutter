import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imagepath;
  const FullScreenImage({super.key, required this.imagepath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: Colors.indigo,
        title: Text("Image view"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                AppUrl.primaryUrl + imagepath,
                width: MediaQuery.of(context).size.width,
                height: 300,
                fit: BoxFit.cover,
              )),
        ),
      ),
    );
  }
}
