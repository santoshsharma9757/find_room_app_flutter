import 'dart:io';

import 'package:find_your_room_nepal/constant/app_text.dart';
import 'package:find_your_room_nepal/view_model.dart/auth_view_model.dart';
import 'package:find_your_room_nepal/view_model.dart/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UploadYourRoomScreen extends StatefulWidget {
  const UploadYourRoomScreen({super.key});

  @override
  _UploadYourRoomScreenState createState() => _UploadYourRoomScreenState();
}

class _UploadYourRoomScreenState extends State<UploadYourRoomScreen> {
  List facilitiesRoom = [];
  String selectedOption = '';

  @override
  void initState() {
    final authprovider = Provider.of<AuthViewModel>(context, listen: false);
    authprovider.initCall(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RoomViewModel>(context, listen: false);
    final authprovider = Provider.of<AuthViewModel>(context, listen: false);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Post Room'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<RoomViewModel>(
            builder: (context, value, child) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Consumer<AuthViewModel>(
                  builder: (context, value, child) => Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton(
                              value: value.selectedDistrict,
                              iconEnabledColor: Colors.grey,
                              dropdownColor: Colors.indigo.shade400,
                              items: value.districtList.map((e) {
                                return DropdownMenuItem(
                                  value: e,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      e.toString(),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                authprovider
                                    .setSelectedDistrict(value.toString());
                              },
                            ),
                          ),
                        ),
                      ),
                      Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: const Text(
                            "Select District",
                            style: TextStyle(
                                backgroundColor: Colors.white,
                                fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 5,
                ),
                OutlineTextField(
                  controller: value.addressController,
                  hintText: 'Address',
                ),
                const SizedBox(height: 16),
                OutlineTextField(
                  controller: value.priceController,
                  hintText: 'Price',
                ),
                const SizedBox(height: 16),
                OutlineTextField(
                  controller: value.descriptionController,
                  hintText: 'Description',
                ),
                const SizedBox(height: 16),
                // TypeAheadField(
                //   textFieldConfiguration: const TextFieldConfiguration(
                //     decoration: InputDecoration(
                //       hintText: 'Facilities',
                //       border: OutlineInputBorder(),
                //     ),
                //   ),
                //   suggestionsCallback: (pattern) async {
                //     return [
                //       "Typeahead Data 1",
                //       "Typeahead Data 2",
                //       "Typeahead Data 3"
                //     ];
                //   },
                //   itemBuilder: (context, suggestion) {
                //     return ListTile(
                //       title: Text(suggestion),
                //     );
                //   },
                //   onSuggestionSelected: (suggestion) {
                //     facilitiesRoom.add(suggestion.toString());
                //     setState(() {});
                //   },
                // ),
                // const SizedBox(height: 16),
                // Wrap(
                //   spacing: 10.0,
                //   runSpacing: 10.0,
                //   children: List.generate(facilitiesRoom.length, (index) {
                //     return Container(
                //       decoration: BoxDecoration(
                //           color: Colors.indigo,
                //           borderRadius: BorderRadius.circular(12)),
                //       child: Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           facilitiesRoom[index].toString(),
                //           style: const TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     );
                //   }),
                // ),

                GestureDetector(
                  onTap: () {
                    provider.pickImages();
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                              "Pick images",
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 16),
                Consumer<RoomViewModel>(
                  builder: (context, value, child) => SizedBox(
                    height: value.images!.isEmpty ? 5 : 100,
                    child: GridView.builder(
                      itemCount: value.images?.length ??
                          0, // Handle null or empty list
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Adjust columns as needed
                      ),
                      itemBuilder: (context, index) {
                        final XFile image = value.images![index];
                        return Image.file(File(image.path), fit: BoxFit.cover);
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.indigo,
                  ),
                  child: InkWell(
                    onTap: () {
                      provider.uploadRoom(context);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text('SUBMIT', style: AppTextStyle.buttonText),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const OutlineTextField(
      {Key? key, required this.controller, required this.hintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
