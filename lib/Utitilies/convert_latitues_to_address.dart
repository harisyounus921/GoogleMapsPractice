import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class ConvertLatituesToAddress extends StatefulWidget {
  const ConvertLatituesToAddress({Key? key}) : super(key: key);

  @override
  _ConvertLatituesToAddressState createState() => _ConvertLatituesToAddressState();
}

class _ConvertLatituesToAddressState extends State<ConvertLatituesToAddress> {
  String Aaddress="demo";
  String Baddress="demo";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google map"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(Aaddress),
          Text(Baddress),
          InkWell(
            onTap: ()async{

              List<Location> locations = await locationFromAddress("Gronausestraat 710, Enschede");

              List<Placemark> placemarks = await placemarkFromCoordinates(31.572197762446823,74.36913417243082);

                setState(() {
                  Aaddress = "${locations.last.latitude}  ${locations.last.longitude}";
                  //Aaddress = locations.last.latitude.toString()+ "  " + locations.last.longitude.toString();
                  Baddress = placemarks.reversed.last.name.toString();
                });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.grey
                ),
                child: const Center(child: Text("Convert")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
