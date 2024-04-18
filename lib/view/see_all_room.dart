import 'package:flutter/material.dart';

class SeeAllRoomScreen extends StatefulWidget {
  const SeeAllRoomScreen({super.key});

  @override
  State<SeeAllRoomScreen> createState() => _SeeAllRoomScreenState();
}

class _SeeAllRoomScreenState extends State<SeeAllRoomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Room List'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, 
          crossAxisSpacing: 8.0, 
          mainAxisSpacing: 8.0, 
        ),
        itemCount: 10, 
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: (){
              // Navigator.push(context, MaterialPageRoute(builder: (context){
              //   return const RoomDetailScreen();
              // }));
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
                      children: const [
                        Text(
                          "Kathmandu",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              backgroundColor: Colors.red),
                        ),
                        Text(
                          "RS:40000",
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
    );
  }
}
