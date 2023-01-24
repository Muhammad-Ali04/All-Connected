import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LoactionScreen extends StatefulWidget {
  const LoactionScreen({Key? key}) : super(key: key);

  @override
  State<LoactionScreen> createState() => _LoactionScreenState();
}

class _LoactionScreenState extends State<LoactionScreen> {
  double lat = 0.0;

  double long = 0.0;

  String address = "";

  bool status = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        Get.snackbar(
          "Failed",
          "Please turn on your Location",
        );
        return Future.error('Location services are disabled.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    status = false;
    Future<Position> data = _determinePosition();
    data.then((value) {
      print("value $value");
      setState(() {
        lat = value.latitude;
        long = value.longitude;
        status = true;
      });

      getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      print("Error $error");
    });
  }

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    setState(() {
      address = placemarks[0].street! +
          " " +
          placemarks[0].administrativeArea! +
          " " +
          placemarks[0].subAdministrativeArea.toString() +
          " " +
          placemarks[0].country!;
    });

    for (int i = 0; i < placemarks.length; i++) {
      print("INDEX $i ${placemarks[i]}");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff182848),
          automaticallyImplyLeading: false,
          shadowColor: Color(0xff182848),
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color(0xff182848),
              statusBarIconBrightness: Brightness.light),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded),
              color: Color.fromARGB(255, 178, 190, 218)),
          title: Text(
            "Live Location",
            style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Ubuntu"),
          )),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: height * 0.05),
                height: height * 0.15,
                child: Image.asset(
                  "assets/images/route.png",
                  fit: BoxFit.fitWidth,
                ),
              ),
            ],
          ),
          Expanded(child: Center()),
          Container(
            height: height * 0.2,
            width: width,
            margin: EdgeInsets.only(
                left: width * 0.01, right: width * 0.01, top: height * 0.02),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                    color: Color.fromARGB(249, 204, 217, 245),
                    blurRadius: 4,
                    offset: Offset(0, 3),
                    spreadRadius: 2)
              ],
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.02),
                  child: Row(
                    children: [
                      Text(
                        "Latitude",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          fontFamily: "Ubuntu",
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(
                        ": $lat",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          fontFamily: "Ubuntu",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.02),
                  child: Row(
                    children: [
                      Text(
                        "Longitude",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          fontFamily: "Ubuntu",
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(
                        ": $long",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          fontFamily: "Ubuntu",
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Container(
                  margin: EdgeInsets.only(left: width * 0.02),
                  child: Row(
                    children: [
                      Text(
                        "Address",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          fontSize: 16,
                          fontFamily: "Ubuntu",
                        ),
                      ),
                      SizedBox(
                        width: width * 0.01,
                      ),
                      Text(
                        ": $address",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 14,
                          fontFamily: "Ubuntu",
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: height * 0.06,
          ),
          Container(
            margin: EdgeInsets.only(left: width * 0.1, right: width * 0.1),
            width: width,
            height: height * 0.072,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurStyle: BlurStyle.outer,
                    blurRadius: 2,
                    spreadRadius: 2,
                    offset: Offset(0, 0),
                    color: Color(0xff4B6CB7),
                  )
                ],
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Color(0xff4B6CB7),
                    Color(0xff182848),
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topRight,
                )),
            child: TextButton(
                onPressed: () {
                  getLatLong();
                },
                child: Text(
                  "Get Location",
                  style: TextStyle(
                      fontFamily: "Ubuntu",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                )),
          ),
          Flexible(
            child: Center(),
            flex: 2,
          )
          // Container(
          //     margin: EdgeInsets.only(
          //         left: width * 0.01, right: width * 0.01, top: height * 0.02),
          //     width: width,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: [
          //         BoxShadow(
          //             color: Color.fromARGB(249, 204, 217, 245),
          //             blurRadius: 4,
          //             offset: Offset(0, 3),
          //             spreadRadius: 2)
          //       ],
          //       color: Colors.white,
          //     ),
          //     child: Text(
          //       "Lat : $lat",
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontFamily: "Ubuntu",
          //       ),
          //     )),
          // Text("Long : $long"),
          // Text("Address : $address "),
          // ElevatedButton(
          //   onPressed: getLatLong,
          //   child: const Text("Get Location"),
          // ),
        ],
      ),
    );
  }
}
