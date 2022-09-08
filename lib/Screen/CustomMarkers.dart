import 'dart:async';
import 'dart:typed_data';
import 'dart:ui'as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:custom_info_window/custom_info_window.dart';

class CustomMarkerScreen extends StatefulWidget {
  const CustomMarkerScreen({Key? key}) : super(key: key);

  @override
  _CustomMarkerScreenState createState() => _CustomMarkerScreenState();
}

class _CustomMarkerScreenState extends State<CustomMarkerScreen> {

  CustomInfoWindowController _customInfoWindowController=CustomInfoWindowController();

  final Completer<GoogleMapController> _controller=Completer();

  static const CameraPosition kgoogleplex=CameraPosition(
      target: LatLng(31.572197762446823, 74.36913417243082),
      zoom: 14.4746);

  Uint8List? Markerimage;

  List<String>images=['assets/bike.png','assets/car.png','assets/car_ac.png','assets/delevory.png'];

  List<LatLng> _latlng=<LatLng>[
    LatLng(31.572197762446823, 74.36913417243082),
    LatLng(31.582197762446823, 74.36913417243082),
    LatLng(31.559197762446823, 74.36913417243082),
    LatLng(31.569197762446823, 74.36913417243082),];

  List<Marker> _marker=[];

  List<Marker> list=[
    Marker(
      markerId: MarkerId('1'),
      position: LatLng(31.772197762446823, 74.36913417243082),
      infoWindow: InfoWindow(
        title: "Home",
      ),
    ),
  ];

  Future<Uint8List> getBytesFromAssets(String path,int width)async{
    ByteData data= await rootBundle.load(path);
    ui.Codec codec=await ui.instantiateImageCodec(data.buffer.asUint8List(),targetHeight: width);
    ui.FrameInfo fi=await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void loaddata()async{
    for(int i=0;i<images.length;i++){
      final Uint8List markericion=await getBytesFromAssets(images[i], 100);
      _marker.add(
        Marker(
          markerId: MarkerId(i.toString()),
          position:_latlng[i],
          icon: BitmapDescriptor.fromBytes(markericion),
          onTap: (){
            _customInfoWindowController.addInfoWindow!(
              Container(height: 300,width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.grey),
              ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/food.jpg"),
                          //image: NetworkImage('https://www.google.com/imgres?imgurl=https%3A%2F%2Fimages.unsplash.com%2Fphoto-1536782376847-5c9d14d97cc0%3Fixlib%3Drb-1.2.1%26ixid%3DMnwxMjA3fDB8MHxzZWFyY2h8M3x8ZnJlZXxlbnwwfHwwfHw%253D%26w%3D1000%26q%3D80&imgrefurl=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Ffree&tbnid=OZLcqhQvtyhHPM&vet=12ahUKEwjb9dL0loP6AhVNG8AKHQgmCa0QMygGegUIARDwAQ..i&docid=3wkP0UfsW3vNTM&w=1000&h=662&q=free%20pics&ved=2ahUKEwjb9dL0loP6AhVNG8AKHQgmCa0QMygGegUIARDwAQ'),
                          fit: BoxFit.fitWidth,
                          filterQuality: FilterQuality.high,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10.0),
                        ),
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              _latlng[i]
            );
          },
         // infoWindow: InfoWindow(title: "This is title marker$i",),
        ),
      );
    }
  }

  Future <Position> getusercurrentlucation()async{
    await Geolocator.requestPermission()
        .then((value){}).onError((error, stackTrace) { print("error : $error");});
    return await Geolocator.getCurrentPosition();
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    //marker.addAll(list);
    loaddata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: kgoogleplex,

                mapType: MapType.normal,
                myLocationEnabled: true,

                markers: Set<Marker>.of(_marker),
                //markers: _marker,
                onTap: (position){
                  _customInfoWindowController.hideInfoWindow!();
                },
                onCameraMove: (position){
                  _customInfoWindowController.onCameraMove!();
                },
                onMapCreated: (GoogleMapController controller){
                 _customInfoWindowController.googleMapController=controller;
                  // _controller.complete(controller);
                },
              ),
              CustomInfoWindow(controller: _customInfoWindowController,
                height: 200,
                width:300,
                offset: 35,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(

          child:Icon(Icons.location_on),
          onPressed:(){
            getusercurrentlucation().then((value) async {
              _marker.add( Marker(
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
