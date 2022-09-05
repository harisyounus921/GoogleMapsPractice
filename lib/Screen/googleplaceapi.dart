import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class GoogleplaceApi extends StatefulWidget {
  const GoogleplaceApi({Key? key}) : super(key: key);

  @override
  _GoogleplaceApiState createState() => _GoogleplaceApiState();
}

class _GoogleplaceApiState extends State<GoogleplaceApi> {
  TextEditingController _controller=TextEditingController();
  List<dynamic> placeslist=[];
  String _secciontoken='122344';
  var uuid=Uuid();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      onChange();
    });
  }

  void onChange(){
    if(_secciontoken==null)
    {
      setState(() {
        _secciontoken=uuid.v4();
      });
    }
    getSuggestion(_controller.text);
  }

  void getSuggestion(String input)async{
    String PlaceApiKey="AIzaSyBtbiW49HEIhVUuu-vy3rdQUKhP5b6fgL0";
    String baseURL ='https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$PlaceApiKey&sessiontoken=$_secciontoken';
    var response=await http.get(Uri.parse(request));

    print(response.body.toString());
    if(response.statusCode==200){
      setState(() {
        placeslist=jsonDecode(response.body.toString())['predictions'];
      });
    }
    else {
      throw Exception("Fail to load the data");
    }

  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Place holder page"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText:"Search by name",),),
            Expanded(
              child: ListView.builder(
                  itemCount: placeslist.length,
                  itemBuilder: (context,index){
                return ListTile(
                  onTap: ()async{
                    List<Location> locations = await locationFromAddress(placeslist[index]['predictions']);
                    print(locations.last.longitude);
                    print(locations.last.latitude);
                  },
                  title: Text(placeslist[index]['predictions']),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
