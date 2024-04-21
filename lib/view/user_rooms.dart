import 'package:find_your_room_nepal/view/room_details.dart';
import 'package:find_your_room_nepal/view_model.dart/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class YourRoomsScreen extends StatefulWidget {
  const YourRoomsScreen({super.key});

  @override
  State<YourRoomsScreen> createState() => _YourRoomsScreenState();
}

class _YourRoomsScreenState extends State<YourRoomsScreen> {
  @override
  void initState() {
    final provider = Provider.of<RoomViewModel>(context, listen: false);
    provider.getUserRooms(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Your Rooms'),
      ),
      body: Consumer<RoomViewModel>(
        builder: (context, value, child) => value.userRooms.isEmpty
            ? Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: value.userRooms.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RoomDetailScreen(
                          roomId: value.userRooms[index]['id'],
                        );
                      }));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.asset(
                                "assets/house.jpg",
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
                                  value.userRooms[index]['district'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      backgroundColor: Colors.red),
                                ),
                                Text(
                                  value.userRooms[index]['price'].toString(),
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
