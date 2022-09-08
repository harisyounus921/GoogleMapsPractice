import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class getCurrentLucation extends StatefulWidget {
  const getCurrentLucation({Key? key}) : super(key: key);

  @override
  _getCurrentLucationState createState() => _getCurrentLucationState();
}

class _getCurrentLucationState extends State<getCurrentLucation> {

  final Completer<GoogleMapController> _controller=Completer();

  static const CameraPosition kgoogleplex=CameraPosition(
      target: LatLng(31.772197762446823, 74.36913417243082),
      zoom: 14.4746);

  List<Marker> marker=[];
  List<Marker> list=[
     Marker(
      markerId: MarkerId('1'),
      position: LatLng(31.772197762446823, 74.36913417243082),
      infoWindow: InfoWindow(
        title: "Home",
      ),
    ),
  ];

  void loaddata(){
    getusercurrentlucation().then((value) async {
      marker.add( Marker(
        markerId: const MarkerId('2'),
        position: LatLng(value.longitude, value.longitude),
        infoWindow: const InfoWindow(
          title: "My current location",
        ),
      ));
      GoogleMapController controller=await _controller.future;
      controller.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(value.latitude,value.longitude),
            zoom: 14,
          )));
      setState(() {
      });
    });
  }

  Future <Position> getusercurrentlucation()async{
    await Geolocator.requestPermission()
        .then((value){}).onError((error, stackTrace) { print("error : $error");});
    return await Geolocator.getCurrentPosition();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    marker.addAll(list);
    //loaddata();
  }
  @override

  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: GoogleMap(
            initialCameraPosition: kgoogleplex,

            mapType: MapType.normal,
            //myLocationEnabled: true,

            markers: Set<Marker>.of(marker),
            onMapCreated: (GoogleMapController controller){
              _controller.complete(controller);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(

          child:Icon(Icons.location_on),
          onPressed:(){
              getusercurrentlucation().then((value) async {
                marker.add( Marker(
                  markerId: const MarkerId('21'),
                  position: LatLng(value.longitude, value.longitude),
                  infoWindow: const InfoWindow(
                    title: "My current location",
                  ),
                ));
                GoogleMapController controller=await _controller.future;
                controller.animateCamera(
                    CameraUpdate.newCameraPosition(CameraPosition(
                      target: LatLng(value.latitude,value.longitude),
                      zoom: 14,
                    ),
                    ));
                setState(() {

                });
              });
            } ,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
    );
  }
}
