import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location extends StatefulWidget {
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {
  List<Marker> allMarkers = [];
  GoogleMapController? _mapController;
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition cameraPosition = CameraPosition(
    target: LatLng(18.03725763177138, -77.50673009422687),
    zoom: 17,
  );

  @override
  void initState() {
    super.initState();
    allMarkers.add(
      Marker(
        markerId: MarkerId('myMaker'),
        draggable: true,
        onTap: () {
          print('Marker Tapped');
        },
        position: LatLng(18.037828254274224, -77.50662637092024),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.hybrid,
        markers: Set.from(allMarkers),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  void mapCreated(controller) {
    setState(() {
      _controller = controller;
    });
  }
}
