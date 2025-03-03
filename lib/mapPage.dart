import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  final Completer<GoogleMapController> _mapcontroller =
      Completer<GoogleMapController>();
  Location _locationconntroller = Location();
  static const LatLng pCalicut = LatLng(11.2588, 75.7804);

  static const LatLng pMarineDriveKochi = LatLng(9.9816, 76.2810);
  LatLng? _currentP = null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocationupdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text("loading..."),
            )
          : GoogleMap(
              onMapCreated: ((controller) =>
                  _mapcontroller.complete(controller)),
              mapType: MapType.hybrid,
              initialCameraPosition: CameraPosition(
                target: pCalicut,
                zoom: 13,
              ),
              markers: {
                  Marker(
                      markerId: MarkerId("_currentLocattion"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _currentP!),
                  Marker(
                      markerId: MarkerId("_sourceLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: pCalicut),
                  Marker(
                      markerId: MarkerId("_destinationLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: pMarineDriveKochi), 
                }),
    );
  }

//focusonCurrentLocation
  Future<void> _cameraToposition(LatLng pos) async {
    final GoogleMapController controller = await _mapcontroller.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  //userLocation
  Future<void> getlocationupdates() async {
    bool _serviceEnabled;
    PermissionStatus _permisionGranded;

    _serviceEnabled = await _locationconntroller.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationconntroller.requestService();
    } else {
      return;
    }

    _permisionGranded = await _locationconntroller.hasPermission();
    if (_permisionGranded == PermissionStatus.denied) {
      _permisionGranded = await _locationconntroller.requestPermission();
      if (_permisionGranded != PermissionStatus.granted) {
        return;
      }
    }

    _locationconntroller.onLocationChanged
        .listen((LocationData _currentLocation) {
      if (_currentLocation.latitude != null &&
          _currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(_currentLocation.latitude!, _currentLocation.longitude!);

          _cameraToposition(_currentP!);
        });
      }
    });
  }
}
