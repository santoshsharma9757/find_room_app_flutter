import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:find_your_room_nepal/view/room_details.dart';
import 'package:find_your_room_nepal/view_model.dart/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SeeAllRoomScreen extends StatefulWidget {
  const SeeAllRoomScreen({super.key});

  @override
  State<SeeAllRoomScreen> createState() => _SeeAllRoomScreenState();
}

class _SeeAllRoomScreenState extends State<SeeAllRoomScreen> {
  @override
  void initState() {
    final provider = Provider.of<RoomViewModel>(context, listen: false);
    provider.getRoom(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Rooms'),
      ),
      body: Consumer<RoomViewModel>(
        builder: (context, value, child) => value.roomList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: value.roomList.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RoomDetailScreen(
                          roomId: value.roomList[index]['id'],
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                AppUrl.primaryUrl +
                                          value.roomList[index]
                                                  ['gallery_images'][0]['image']
                                              .toString(),
                                width: 200,
                                height: 300,
                                fit: BoxFit.cover,
                              )),
                          Positioned(
                            bottom: 10,
                            left: 30,
                            child: Column(
                              children: [
                                Text(
                                  value.roomList[index]['district'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.red),
                                ),
                                Text(
                                  value.roomList[index]['price'].toString(),
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
                    ),
                  );
                },
              ),
      ),
    );
  }
}
