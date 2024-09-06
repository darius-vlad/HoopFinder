import 'dart:async';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hoopfinder/consts.dart';
import 'package:location/location.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

class MapPage extends StatefulWidget {
  final String playerName;
  const MapPage({Key? key, required this.playerName}) : super(key: key);
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  BitmapDescriptor markerIcon1 = BitmapDescriptor.defaultMarker;
  Location _locationController = Location();
  GoogleMapController? _mapController;
  Map<PolylineId, Polyline> polylines = {};
  bool _isCurrentlyPlaying = false;
  static const googlePlex = LatLng(37.4223, -122.0848);
  static const LatLng _pcourt = LatLng(37.4233, -122.0648);
  LatLng? _currentP;

  Set<Marker> _markers = Set<Marker>();
  BitmapDescriptor mapMarker = BitmapDescriptor.defaultMarker;
  BitmapDescriptor courtMarker = BitmapDescriptor.defaultMarker;

  void setCourtMarker() async {
    courtMarker = await BitmapDescriptor.asset(
        ImageConfiguration(), 'assets/images/court_pin.png');
  }

  void setCustomMarker() async {
    mapMarker = await BitmapDescriptor.asset(
        ImageConfiguration(), 'assets/images/user_location.png');
  }

  @override
  void initState() {
    super.initState();
    setCustomMarker();
    setCourtMarker();
    _fetchUserPlayingStatus();
    getLocationUpdates();
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF15131C),
        title: Text(
          "Find a court",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: _currentP == null
          ? const Center(
              child: Text('Loading...'),
            )
          : GoogleMap(
              cloudMapId: 'e919a7a91c02b4bc',
              zoomControlsEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                if (mounted) {
                  setState(() {
                    _mapController = controller;
                  });
                }
              },
              initialCameraPosition:
                  CameraPosition(target: googlePlex, zoom: 13),
              markers: _markers,
              polylines: Set<Polyline>.of(polylines.values),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentP != null) {
            _cameraToPosition(_currentP!);
          }
        },
        child: Icon(Icons.my_location),
      ),
    );
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    if (_mapController != null) {
      final CameraPosition _newCameraPosition =
          CameraPosition(target: pos, zoom: 20);
      await _mapController!
          .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
    }
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) async {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        if (mounted) {
          setState(() {
            _currentP =
                LatLng(currentLocation.latitude!, currentLocation.longitude!);
          });

          _buildCourtMarkers();
        }
      }
    });
  }

  Future<List<LatLng>> getPolyLinePoints(
      LatLng source, LatLng destination) async {
    List<LatLng> polyLineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAPS_API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(source.latitude, source.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.walking,
      ),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }

    return polyLineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polyLineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue.shade400,
      points: polyLineCoordinates,
      width: 6,
    );

    if (mounted) {
      setState(() {
        polylines.clear();
        polylines[id] = polyline;
      });
    }
  }

  Container createMarkerContent(LatLng destinationLocation, int numberOfPlayers,
      List<String> names, String courtName) {
    return Container(
      width: double.infinity,
      height: 235,
      color: Color(0xFF15131C),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                numberOfPlayers,
                (index) => Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: Column(
                    children: [
                      Center(
                        child: CircleAvatar(
                          child: Icon(
                            Icons.account_circle,
                            size: 64,
                          ),
                          radius: 36,
                        ),
                      ),
                      Text(
                        names[index],
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 18,
            child: Text(
              'Now Playing Here:',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 30,
            child: Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF21222D)),
                onPressed: () async {
                  if (_currentP != null) {
                    List<LatLng> polylineCoordinates = await getPolyLinePoints(
                        _currentP!, destinationLocation);
                    generatePolyLineFromPoints(polylineCoordinates);
                  }
                },
                child: Container(
                  width: 94,
                  color: Color(0xFF21222D),
                  child: Text(
                    "Get Directions",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 20,
              right: 30,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF21222D),
                  ),
                  onPressed: () async {
                    if (_isCurrentlyPlaying == false)
                      await _joinCourt(widget.playerName, courtName);
                    else
                      await _leaveCourt(widget.playerName, courtName);
                  },
                  child: Container(
                    width: 94,
                    color: Color(0xFF21222D),
                    child: _isCurrentlyPlaying
                        ? Center(
                            child: Text(
                              "Leave court",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          )
                        : Center(
                            child: Text(
                              "Join court",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Future<void> _buildCourtMarkers() async {
    var collection = FirebaseFirestore.instance.collection('courts');
    var querySnapshot = await collection.get();
    _markers.add(Marker(
        markerId: MarkerId('current position'),
        position: _currentP!,
        icon: mapMarker));
    for (var queryDocumentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data = queryDocumentSnapshot.data();
      GeoPoint position = data['position'];
      String description = data['name'];
      double lat = position.latitude;
      double long = position.longitude;
      LatLng latLng = LatLng(lat, long);
      List<String> players = List.from(data['players']);
      int numberOfPlayers = players.length;
      Marker marker = Marker(
        markerId: MarkerId(description),
        icon: courtMarker,
        position: latLng,
        onTap: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return createMarkerContent(
                  latLng, numberOfPlayers, players, description);
            },
          );
        },
      );
      _markers.add(marker);
    }
  }

  Future<void> _joinCourt(String playerName, String courtName) async {
    var collection = FirebaseFirestore.instance.collection('courts');
    var courtQuery =
        await collection.where('name', isEqualTo: courtName).limit(1).get();

    if (courtQuery.docs.isNotEmpty) {
      var courtDoc = courtQuery.docs.first;

      await collection.doc(courtDoc.id).update({
        'players': FieldValue.arrayUnion([playerName])
      });

      await _updateUserPlayingStatus(true);

      await _fetchUserPlayingStatus();
      await _buildCourtMarkers();

      setState(() {});
    }
  }

  Future<void> _leaveCourt(String playerName, String courtName) async {
    var collection = FirebaseFirestore.instance.collection('courts');
    var courtQuery =
        await collection.where('name', isEqualTo: courtName).limit(1).get();

    if (courtQuery.docs.isNotEmpty) {
      var courtDoc = courtQuery.docs.first;

      await collection.doc(courtDoc.id).update({
        'players': FieldValue.arrayRemove([playerName])
      });

      await _updateUserPlayingStatus(false);

      await _fetchUserPlayingStatus();
      await _buildCourtMarkers();

      setState(() {});
    }
  }

  Future<void> _fetchUserPlayingStatus() async {
    User? _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(_user.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        _isCurrentlyPlaying = data?['isPlaying'] ?? false;
      }
    }
  }

  Future<void> _updateUserPlayingStatus(bool value) async {
    User? _user = FirebaseAuth.instance.currentUser;
    var collection = FirebaseFirestore.instance.collection('users');
    if (_user != null)
      await collection.doc(_user.uid).update({'isPlaying': value});
  }
}
