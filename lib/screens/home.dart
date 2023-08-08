import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_fonts/google_fonts.dart';

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

  void scanAndConnect() {
    flutterBlue.scan().listen((scanResult) {
      // device.name == ism device li yodhher f parametre bluetooth
      if (scanResult.device.name == 'HM10') {
        targetDevice = scanResult.device;
        flutterBlue.stopScan();
        connectToDevice();
      }
    });
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
        // exemple 0000XXXX-0000-1000-8000-00805F9B34FB
         "YOUR_CHARACTERISTIC_UUID" 
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
    return Scaffold(
     
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
                      Text("Let's check your activity")
                    ],
                  ),
                ],
              ) , 
              ElevatedButton(
                onPressed:() {
                   print("object");
                  scanAndConnect ; 
                 
        
                } ,
                child: Text('Connect to Device'),
              ),
              Text('Received Data: ${receivedData.isEmpty ? "None" : receivedData.join(", ")}'),
            ],
          ),
        ),
      ),
    );
  }
}
