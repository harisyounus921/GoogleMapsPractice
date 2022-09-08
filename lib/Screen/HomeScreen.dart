import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {

  final Completer<GoogleMapController> _controller=Completer();

  static const CameraPosition kgoogleplex=CameraPosition(
      target: LatLng(31.572197762446823, 74.36913417243082),
  zoom: 14.4746);

  List<Marker> marker=[];
  List<Marker> list=const[
    Marker(
      markerId: MarkerId('1'),
    position: LatLng(31.572197762446823, 74.36913417243082),
    infoWindow: InfoWindow(
      title: "Home",
    ),
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    marker.addAll(list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          initialCameraPosition: kgoogleplex,

          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          compassEnabled: true,

          markers: Set<Marker>.of(marker),
          onMapCreated: (GoogleMapController controller){
            _controller.complete(controller);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.location_on),
        onPressed:()async{
          GoogleMapController controller=await _controller.future;
          controller.animateCamera(
              CameraUpdate.newCameraPosition(const CameraPosition(
                target: LatLng(31.572197762446823, 74.36913417243082),
                zoom: 14,
              )));
          } ,
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
