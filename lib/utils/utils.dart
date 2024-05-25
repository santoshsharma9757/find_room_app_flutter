import 'package:find_your_room_nepal/view/upload_room.dart';
import 'package:find_your_room_nepal/view_model.dart/room_view_model.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';

class Utils {
  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: Colors.red, content: Text(message)));
  }

  static showMyDialog(String message, BuildContext context,
      [String? title = ""]) {
    return showDialog(
      context: context,
      // barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title.toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('${message.toString()}'),
              ],
            ),
          ),
        );
      },
    );
  }

  static showSubscriptionDialog(
    String title,
    String message,
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 20),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: 30, // Adjust the width and height as needed
                            height: 30,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.indigo,
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          )),
                      const SizedBox(height: 5),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 35),
                      GestureDetector(
                        onTap: () {
                          KhaltiScope.of(context).pay(
                            config: PaymentConfig(
                              amount: 1000, //in paisa
                              productIdentity: 'Product Id',
                              productName: 'Product Name',
                              mobileReadOnly: false,
                            ),
                            preferences: [
                              PaymentPreference.khalti,
                              PaymentPreference.connectIPS,
                              PaymentPreference.eBanking,
                              PaymentPreference.mobileBanking,
                            ],
                            onFailure: (PaymentFailureModel value) {
                              Utils.snackBar(
                                  "Payment Failed !!!".toString(), context);
                            },
                            onSuccess: (PaymentSuccessModel value) {
                              print("PAYMENT SUCCCESSFUL::");
                              Utils.snackBar(
                                  "Payment Successful !!!".toString(), context);
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return const UploadYourRoomScreen();
                              }));
                            },
                          );
                        },
                        child: Container(
                          // ignore: sort_child_properties_last
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: Text(
                              message,
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.indigo),
                        ),
                      ),
                      const SizedBox(height: 22),
                    ],
                  ),
                ),
              ],
            ));
      },
    );
  }

  static showSubscriptionDialogForQRScanner(
    String title,
    String message,
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      top: 20, left: 20, right: 20, bottom: 20),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(0, 10),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Scrollbar(
                    isAlwaysShown: true,
                    child: SingleChildScrollView(
                      child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                width:
                                    30, // Adjust the width and height as needed
                                height: 30,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.indigo,
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              )),
                          const SizedBox(height: 5),
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 35),
                          Image.asset(
                            "assets/qr_code.jpeg",
                            height: 250,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 35),
                          // _buildExpansionTile(),
                          _buildTransactionField(),
                          const SizedBox(height: 22),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ));
      },
    );
  }
}

_buildTransactionField() {
  return Consumer<RoomViewModel>(
    builder: (context, providerData, child) => Column(
      children: [
        SizedBox(
          height: 40,
          child: TextField(
            controller: providerData.transactionCodeController,
            decoration: InputDecoration(
              hintText: 'Transaction ID',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(height: 13.0),
        GestureDetector(
          onTap: providerData.transactionCodeController.text.isEmpty
              ? () {
                  Utils.showMyDialog(
                      "Your trancation ID is empty", context, "Attention!!!");
                }
              : providerData.isUnderReview
                  ? () {
                      Utils.showMyDialog(
                          "Your payment is under progress please wait 10-20 min",
                          context,
                          "Verifying...");
                    }
                  : () {
                      providerData.transactionSubmit(context);
                    },
          child: Container(
            // ignore: sort_child_properties_last
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: providerData.isSubmitLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const Text(
                      "Submit",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.indigo),
          ),
        ),
      ],
    ),
  );
}

_buildExpansionTile() {
  return Consumer<RoomViewModel>(
    builder: (context, providerData, child) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
            initiallyExpanded: true,
            title: const Text(
              'Click to add transaction ID',
              style: TextStyle(fontSize: 13),
            ),
            onExpansionChanged: (valuedata) {
              providerData.setIsExpanded(valuedata);
            },
            children: [
              if (providerData.isExpanded)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: providerData.transactionCodeController,
                        decoration: InputDecoration(
                          hintText: 'Transaction ID',
                        ),
                      ),
                      const SizedBox(height: 13.0),
                      GestureDetector(
                        onTap: providerData
                                    .transactionCodeController.text.isEmpty ||
                                providerData.isUnderReview
                            ? null
                            : () {
                                providerData.transactionSubmit(context);
                              },
                        child: Container(
                          // ignore: sort_child_properties_last
                          child: Padding(
                            padding: const EdgeInsets.all(13.0),
                            child: providerData.isSubmitLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Text(
                                    "Submit",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.indigo),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    ),
  );
}
