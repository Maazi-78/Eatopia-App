import 'dart:convert';

import 'package:eatopia/utilities/colours.dart';
import 'package:eatopia/utilities/custom_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class MapScreen extends StatefulWidget {
  @override
  const MapScreen({super.key});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool isLoading = true;
  late GoogleMapController mapController;
  LatLng _center = const LatLng(0, 0);
  final LatLng _markerLocation = const LatLng(0, 0);
  late Marker _marker = Marker(
    markerId: const MarkerId('Current Location'),
    position: _markerLocation,
  );

  String locTxt = '';

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  void _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      // Location services are disabled, show an error message
      return;
    }

    // Check if the app has permission to access location
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Permission to access location is denied forever, show an error message
      return;
    }

    if (permission == LocationPermission.denied) {
      // Request permission to access location
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Permission to access location is denied, show an error message
        return;
      }
    }

    // Get the user's current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _center = LatLng(position.latitude, position.longitude);
    _marker = Marker(
      markerId: const MarkerId('Current Location'),
      position: _center,
      infoWindow: const InfoWindow(
        title: 'Current Location',
      ),
    );
    List<Placemark> place =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    setState(() {
      locTxt =
          '${place[0].street}, ${place[0].subLocality}, ${place[0].subAdministrativeArea}';
      isLoading = false;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _marker = _marker.copyWith(positionParam: position.target);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterAlignment: AlignmentDirectional.center,
      persistentFooterButtons: [
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(MediaQuery.of(context).size.width, 60),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              backgroundColor: appGreen,
            ),
            onPressed: () async {
              List<Placemark> place = await placemarkFromCoordinates(
                  _marker.position.latitude, _marker.position.longitude);

              setState(() {
                locTxt =
                    '${place[0].street}, ${place[0].subLocality}, ${place[0].subAdministrativeArea}';
              });
              Navigator.pop(context, locTxt);
            },
            child: const Text(
              'Confirm Location',
              style: TextStyle(
                fontSize: 20,
              ),
            ))
      ],
      appBar: AppBar(
          title: const Text('Select your Location'),
          backgroundColor: appGreen,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: true,
                onTap: () async {
                  String? locStr = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapSearchPage(),
                    ),
                  );
                  if (locStr != null) {
                    List<Location> locations =
                        await locationFromAddress(locStr);
                    LatLng loc =
                        LatLng(locations[0].latitude, locations[0].longitude);
                    locTxt = locStr;

                    setState(() {
                      _center = loc;
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _center,
                            zoom: 16.0,
                          ),
                        ),
                      );
                      _marker = Marker(
                        markerId: const MarkerId('Current Location'),
                        position: _center,
                        infoWindow: const InfoWindow(
                          title: 'Current Location',
                        ),
                      );
                    });
                  }
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: 'Search for your location',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          )),
      body: isLoading
          ? CustomShimmer(
              height: double.infinity,
              width: MediaQuery.of(context).size.width,
            )
          : Stack(
              children: <Widget>[
                GoogleMap(
                  onCameraMove: _onCameraMove,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition:
                      CameraPosition(target: _center, zoom: 16.0),
                  markers: {
                    _marker,
                  },
                ),
                Positioned(
                  bottom: 16.0,
                  left: 16.0,
                  child: FloatingActionButton(
                    onPressed: () async {
                      //Update the location move the camera to current location
                      _getLocation();
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: _center,
                            zoom: 16.0,
                          ),
                        ),
                      );
                    },
                    backgroundColor: appGreen,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class MapSearchPage extends StatefulWidget {
  const MapSearchPage({super.key});

  @override
  State<MapSearchPage> createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  final controller = TextEditingController();
  final uuid = Uuid();
  String sessionToken = '';
  List<dynamic> placesList = [];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      onChange();
    });
  }

  void onChange() {
    if (sessionToken == '') {
      setState(() {
        sessionToken = uuid.v4();
      });
    } else {
      getSuggestions(controller.text.toString());
    }
  }

  void getSuggestions(String input) async {
    String PLACES_API_KEY = 'AIzaSyBke7Nj7T0wuGTK87noDEX1lC_v58xwH3s';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$PLACES_API_KEY&sessiontoken=$sessionToken';
    var response = await http.get(Uri.parse(request));

    if (response.statusCode == 200) {
      setState(() {
        placesList = json.decode(response.body)['predictions'];
      });
    } else {
      throw Exception('Failed to load suggestions');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Location'),
        backgroundColor: appGreen,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              textInputAction: TextInputAction.search,
              controller: controller,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: 'Search for your location',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            itemCount: placesList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(placesList[index]['description']),
                onTap: () async {
                  Navigator.pop(
                      context, placesList[index]['description'].toString());
                },
              );
            }),
      ),
    );
  }
}
