import 'dart:developer';

import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:find_your_room_nepal/view_model.dart/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomDetailScreen extends StatefulWidget {
  final dynamic roomId;
  const RoomDetailScreen({super.key, required this.roomId});

  @override
  State<RoomDetailScreen> createState() => _RoomDetailScreenState();
}

class _RoomDetailScreenState extends State<RoomDetailScreen> {
  @override
  void initState() {
    final provider = Provider.of<RoomViewModel>(context, listen: false);
    provider.getRoomByID(context, widget.roomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text("Room Detail"),
      ),
      body: Consumer<RoomViewModel>(
        builder: (context, value, child) => value.roomLoader
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainImageSection(context),
                    _buildDescriptionSection(),
                    _buildFacilitiesSection(),
                    _buildOwnerSection(),
                    _buildGallerySection(context)
                  ],
                ),
              ),
      ),
    );
  }

  _buildGallerySection(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          _buildHeadinTitle("GALLERY"),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.30,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: value.roomData['gallery_images'].length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          AppUrl.primaryUrl +
                              value.roomData['gallery_images'][index]['image']
                                  .toString(),
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.height * 0.12,
                          fit: BoxFit.cover,
                        )),
                  );
                }),
          )
        ],
      ),
    );
  }

  _buildOwnerSection() {
    return Consumer<RoomViewModel>(
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Card(
            color: Colors.blueGrey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        child: Text(value.roomData['user']['name'][0]),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        children: [
                          Text(
                            value.roomData['user']['name'],
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                          Text(
                            "Owner",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                  Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(8)),
                      child: GestureDetector(
                        onTap: () {
                          log(value.roomData['user']['mobile']);
                        },
                        child: Icon(
                          Icons.call,
                          color: Colors.white,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        _buildHeadinTitle("FACILITIES"),
        SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 10.0, // Adjust the spacing between the Text widgets
          runSpacing: 10.0, // Adjust the run spacing (spacing between lines)
          children: List.generate(10, (index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Text ${index + 1}",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _buildDescriptionSection() {
    return Consumer<RoomViewModel>(
      builder: (context, value, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          _buildHeadinTitle("DESCRIPTION"),
          SizedBox(
            height: 2,
          ),
          Text(value.roomData['description'].toString()),
        ],
      ),
    );
  }

  _buildMainImageSection(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, value, child) => Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                AppUrl.primaryUrl +
                    value.roomData['gallery_images'][0]['image'].toString(),
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
              )),
          Positioned(
            bottom: 10,
            left: 30,
            child: Column(
              children: [
                Text(
                  value.roomData['district'].toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.red),
                ),
                Text(
                  value.roomData['price'].toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      backgroundColor: Colors.red),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildHeadinTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
