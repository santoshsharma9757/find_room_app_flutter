import 'package:find_your_room_nepal/constant/api_url.dart';
import 'package:find_your_room_nepal/view/login_screen.dart';
import 'package:find_your_room_nepal/view/room_details.dart';
import 'package:find_your_room_nepal/view/see_all_room.dart';
import 'package:find_your_room_nepal/view/upload_room.dart';
import 'package:find_your_room_nepal/view/user_rooms.dart';
import 'package:find_your_room_nepal/view_model.dart/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  @override
  void initState() {
    final provider = Provider.of<RoomViewModel>(context, listen: false);
    provider.initCall(context);
    super.initState();
  }

  List facilities = ["Washroom", "Bedroom"];

  final _appUrl = AppUrl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      drawer: _buildDrawer(context),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildNearestForyou(),
            _buildBestForyou(),
          ],
        ),
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton.extended(
          elevation: 50,
          onPressed: () {
            _appUrl.storeToken("");
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return UploadYourRoomScreen();
            }));
          },
          icon: const Icon(Icons.add),
          label: const Text('Post'),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  _buildDrawer(BuildContext context) {
    return Consumer<RoomViewModel>(
      builder: (context, value, child) => value.userData.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.indigo,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          value.userData['name'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          value.userData['mobile'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      // Handle Home item tap
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.apartment),
                    title: Text('Your Rooms'),
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return YourRoomsScreen();
                      }));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      _logoutAlert();
                    },
                  ),
                ],
              ),
            ),
    );
  }

  _logoutAlert() async {
    return showDialog(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setter) {
        return AlertDialog(
          title: Text('Warning'),
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            setter = setState;
            return Text(
              'Are you sure to Logout?',
            );
          }),
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          actionsPadding: EdgeInsets.only(bottom: 20),
          actions: [
            SizedBox(
              height: 35,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      width: .5,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                onPressed: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return LoginScreen();
                  }));
                },
                child: Text(
                  'Yes',
                  style: TextStyle(fontSize: 14, color: Colors.indigo),
                ),
              ),
            ),
            SizedBox(
              height: 35,
              child: TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      width: .5,
                      color: Colors.indigo,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.indigo,
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  _buildNearestForyou() {
    return Consumer<RoomViewModel>(
      builder: (context, value, child) => value.roomLoader
          ? Center(child: CircularProgressIndicator())
          : value.roomList.isEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.33,
                  child: Center(
                      child: Text(
                    "No Data Available",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.indigo),
                  )))
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildheadingTitle("Nearest for you"),
                          _buildseeAll()
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.33,
                      child: ListView.builder(
                          itemCount: value.roomList.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
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
                                                      ['gallery_images'][0]
                                                      ['image']
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
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                backgroundColor: Colors.red),
                                          ),
                                          Text(
                                            value.roomList[index]['price'],
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
                          }),
                    )
                  ],
                ),
    );
  }

  _buildBestForyou() {
    return IgnorePointer(
      ignoring: true,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildheadingTitle("Best For You"),
                      _buildseeAll()
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  child: ListView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return RoomDetailScreen(
                                roomId: "",
                              );
                            }));
                          },
                          child: Card(
                            color: Colors.blueGrey.shade400,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.asset(
                                        "assets/house.jpg",
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.30,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.12,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.57,
                                        child: const Text(
                                          "Kathmandu",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Text(
                                      "RS:5000",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    ),
                                    _buildFacilitiesSection()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                )
              ],
            ),
            Positioned(
                top: 200,
                left: 150,
                child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text("COMMING SOON!!!!"),
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  _buildseeAll() {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const SeeAllRoomScreen();
        }));
      },
      child: const Text(
        "See all",
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  _buildheadingTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  _buildFacilitiesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Wrap(
          spacing: 10.0, // Adjust the spacing between the Text widgets
          runSpacing: 10.0, // Adjust the run spacing (spacing between lines)
          children: List.generate(facilities.length, (index) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  facilities[index],
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RoomViewModel>(context);
    return SafeArea(
      child: Consumer<RoomViewModel>(
        builder: (context, value, child) => Container(
            height: 60,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.indigo),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Open the drawer here
                      Scaffold.of(context).openDrawer();
                    },
                    child: Consumer<RoomViewModel>(
                      builder: (context, value, child) => CircleAvatar(
                        radius: 30,
                        child: Text(value.userData['name'][0]),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.white),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        value: value.selectedDistrict,
                        iconEnabledColor: Colors.white,
                        dropdownColor: Colors.indigo.shade400,
                        items: value.districtList.map((e) {
                          return DropdownMenuItem(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                e.toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            value: e,
                          );
                        }).toList(),
                        onChanged: (value) {
                          provider.setSelectedDistrict(
                              value.toString(), context);
                        },
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
