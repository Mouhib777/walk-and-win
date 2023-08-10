import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:walk_and_win/constant/constant.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
 FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? targetDevice;
  BluetoothCharacteristic? targetCharacteristic;
  List<int> receivedData = [];

  void scanAndConnect() async {
  if (await Permission.bluetoothScan.request().isGranted) {
    StreamSubscription<ScanResult>? scanSubscription; // Define a StreamSubscription
    Timer? timeoutTimer; // Define a Timer

    // Set a timeout duration (in seconds)
    const int scanTimeout = 15; // Adjust this value as needed

    scanSubscription = flutterBlue.scan().listen((scanResult) {
      // device.name == ism device li yodhher f parametre bluetooth
      if (scanResult.device.name == 'HM10') {
        targetDevice = scanResult.device;
        scanSubscription?.cancel(); // Cancel the scanSubscription
        timeoutTimer?.cancel(); // Cancel the timeoutTimer
        print('Target device found and scanning stopped.'); // Print the message
        connectToDevice();
      }
    });

    // Set up a timeout
    timeoutTimer = Timer(Duration(seconds: scanTimeout), () {
      scanSubscription?.cancel(); // Cancel the scanSubscription
      flutterBlue.stopScan();
      EasyLoading.showError('Scanning timed out. Target device not found.') ; 
      print('Scanning timed out. Target device not found.'); // Print the message
    });
  }
}

  void connectToDevice() async {
    if (targetDevice != null) {
      await targetDevice!.connect();
      discoverServices();
    }
  }

  void discoverServices() async {
    List<BluetoothService> services = await targetDevice!.discoverServices();
    services.forEach((service) {
      service.characteristics.forEach((characteristic) {
        if (characteristic.uuid.toString() ==
        // badelha bil uuid 
        // exemple: 0000XXXX-0000-1000-8000-00805F9B34FB
         "YOUR_CHARACTERISTIC_UUID" //na7y ""
         ) {
          targetCharacteristic = characteristic;
          subscribeToCharacteristic();
        }
      });
    });
  }

  void subscribeToCharacteristic() async {
    if (targetCharacteristic != null) {
      await targetCharacteristic!.setNotifyValue(true);
      targetCharacteristic!.value.listen((value) {
        setState(() {
          receivedData = value;
        });
      });
    }
  }
  var user_data;

  @override
  void initState() {
    super.initState();
    // initializeBluetooth();
    getUserData();
    
  }

  Future<void> getUserData() async {
    final User? user1 = FirebaseAuth.instance.currentUser;
    String? _uid = user1!.uid;
    var result1 =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    setState(() {
      user_data = result1;
    });
  }
  @override
  Widget build(BuildContext context) {
      var steps = receivedData.isEmpty ? "5749" : receivedData.join(", ") ; 
      double? percentage = double.tryParse(steps)! / 10000 ; 
      double? argent = double.tryParse(steps)! /100 ;
    return Scaffold(
      backgroundColor: Colors.white,
     
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(15.0),
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 30,),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hi , ${user_data?["full name"] ?? ""}" , 
                      style: GoogleFonts.montserrat(
                        fontSize: 18 , 
                        fontWeight:  FontWeight.w700 
                      ),
                      ), 
                      SizedBox(height: 10,) , 
                      Text("Let's check your activity" , 
                      style: GoogleFonts.montserrat(
                        fontSize: 16 , 
                        fontWeight:  FontWeight.w500 
                      ),
                      )
                    ],
                  ), 
                  SizedBox(width: 60,),
                  Container(
                    height: 70 , 
                    width: 70,
                    decoration: BoxDecoration(
                      color: Colors.transparent , 
                      border: Border.all(
                        color: Colors.grey , 
                        width: 5
                      ) , 
                      borderRadius: BorderRadius.circular(40)
                    ),
                    child: CircleAvatar(
                      radius: 30,
                    ),
                  )
                ],
              ) , 
            
              SizedBox(height: 20,),
                 CircularPercentIndicator(
                radius: 130.0,
                animation: true,
                animationDuration: 1200,
                lineWidth: 15.0,
                percent: percentage,
                center:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          steps,
                          style: GoogleFonts.montserrat(
                        fontSize: 40 , 
                        fontWeight: FontWeight.w800 , 
              ),
                        ),
                  
                        SizedBox(height: 15,),
                      ],
                    ), 
                    Text("Steps" , 
                     style: GoogleFonts.montserrat(
                    fontSize: 12 , 
                    fontWeight: FontWeight.w500 , 
                     )
                    )
                  ],
                ),
                circularStrokeCap: CircularStrokeCap.round,
                backgroundColor: Color.fromARGB(62, 158, 158, 158),
                progressColor: primarycolor,
              ),
              SizedBox(height: 20,),
               Text("You'll earn $argent TND" , 
              style: GoogleFonts.montserrat(
                fontSize: 14 , 
                fontWeight: FontWeight.w500
              ),
              ) , 
              Image.asset("images/pic3.jpg" , height: 220,),
                      
                      SizedBox(
                width: 130,
                 child: ElevatedButton(
                  onPressed:() {
                     EasyLoading.show(status: "Connecting to HM10...");
                    scanAndConnect() ;      
                  } ,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Connect', 
                      style: GoogleFonts.montserrat(),
                      ), 
                      SizedBox(width: 5,),
                      Icon(CupertinoIcons.bluetooth)
                    ],
                  ), 
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  ),
                       ),
               ),
              
            ],
          ),
        ),
      ),
    );
  }
}
