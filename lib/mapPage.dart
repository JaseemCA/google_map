// // ignore_for_file: no_leading_underscores_for_local_identifiers

// import 'dart:async';
// // import 'dart:developer';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:flutter/material.dart';
// import 'package:google_maps/const.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

// class Mappage extends StatefulWidget {
//   const Mappage({super.key});

//   @override
//   State<Mappage> createState() => _MappageState();
// }

// class _MappageState extends State<Mappage> {
//   final Completer<GoogleMapController> _mapcontroller =
//       Completer<GoogleMapController>();
//   Location _locationconntroller = Location();
//   static const LatLng pCalicut = LatLng(11.2588, 75.7804);

//   static const LatLng pMarineDriveKochi = LatLng(9.9816, 76.2810);
//   LatLng? _currentP = null;
//   Map<PolylineId, Polyline> polylines = {};

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getlocationupdates().then((_) => {
//           getPloyLinepoints().then((coordinates) => {
//                 generatePolyLineFromPoints(coordinates),
//                 // print(coordinates),
//               })
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentP == null
//           ? const Center(
//               child: Text("loading..."),
//             )
//           : GoogleMap(
//               onMapCreated: ((controller) =>
//                   _mapcontroller.complete(controller)),
//               mapType: MapType.hybrid,
//               initialCameraPosition: CameraPosition(
//                 target: pCalicut,
//                 zoom: 13,
//               ),
//               markers: {
//                 Marker(
//                     markerId: MarkerId("_currentLocattion"),
//                     icon: BitmapDescriptor.defaultMarker,
//                     position: _currentP!),
//                 Marker(
//                     markerId: MarkerId("_sourceLocation"),
//                     icon: BitmapDescriptor.defaultMarker,
//                     position: pCalicut),
//                 Marker(
//                     markerId: MarkerId("_destinationLocation"),
//                     icon: BitmapDescriptor.defaultMarker,
//                     position: pMarineDriveKochi),
//               },
//               polylines: Set<Polyline>.of(polylines.values),
//             ),
//     );
//   }

// //focusonCurrentLocation
//   Future<void> _cameraToposition(LatLng pos) async {
//     final GoogleMapController controller = await _mapcontroller.future;
//     CameraPosition _newCameraPosition = CameraPosition(
//       target: pos,
//       zoom: 13,
//     );
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(_newCameraPosition),
//     );
//   }

//   //userLocation
//   Future<void> getlocationupdates() async {
//     bool _serviceEnabled;
//     PermissionStatus _permisionGranded;

//     _serviceEnabled = await _locationconntroller.serviceEnabled();
//     if (_serviceEnabled) {
//       _serviceEnabled = await _locationconntroller.requestService();
//     } else {
//       return;
//     }

//     _permisionGranded = await _locationconntroller.hasPermission();
//     if (_permisionGranded == PermissionStatus.denied) {
//       _permisionGranded = await _locationconntroller.requestPermission();
//       if (_permisionGranded != PermissionStatus.granted) {
//         return;
//       }
//     }

//     _locationconntroller.onLocationChanged
//         .listen((LocationData _currentLocation) {
//       if (_currentLocation.latitude != null &&
//           _currentLocation.longitude != null) {
//         setState(() {
//           _currentP =
//               LatLng(_currentLocation.latitude!, _currentLocation.longitude!);

//           _cameraToposition(_currentP!);
//         });
//       }
//     });
//   }

//   Future<List<LatLng>> getPloyLinepoints() async {
//     List<LatLng> polyLineCordinates = [];
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//         googleApiKey: GOOGLE_MAPS_API_KEY,
//         request: PolylineRequest(
//           origin: PointLatLng(pCalicut.latitude, pCalicut.longitude),
//           destination: PointLatLng(
//               pMarineDriveKochi.latitude, pMarineDriveKochi.longitude),
//           mode: TravelMode.driving,
//         ));

//     if (result.points.isEmpty) {
//       for (var point in result.points) {
//         polyLineCordinates.add(LatLng(point.latitude, point.longitude));
//       }
//     } else {
//       // print(result.errorMessage);
//     }
//     return polyLineCordinates;
//   }

//   void generatePolyLineFromPoints(List<LatLng> polycoordinates) {
//   if (polycoordinates.isEmpty) {
//     print("No polyline points generated!");
//     return;
//   }

//   PolylineId id = PolylineId("poly");
//   Polyline polyline = Polyline(
//     polylineId: id,
//     color: Colors.blue,
//     points: polycoordinates,
//     width: 5,
//     startCap: Cap.roundCap,
//     endCap: Cap.roundCap,
//     jointType: JointType.round,
//   );

//   setState(() {
//     polylines[id] = polyline;
//   });

//   print("Polyline added successfully!");
// }

//   // void generatePolyLineFromPoints(List<LatLng> polycoordinates) async {
//   //   PolylineId id = PolylineId("poly");
//   //   Polyline polyline = Polyline(
//   //       polylineId: id, color: Colors.blue, points: polycoordinates, width: 8);
//   //   setState(() {
//   //     polylines[id] = polyline;
//   //   });
//   // }
// }
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:google_maps/const.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Mappage extends StatefulWidget {
  const Mappage({super.key});

  @override
  State<Mappage> createState() => _MappageState();
}

class _MappageState extends State<Mappage> {
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  Location _locationController = Location();
  static const LatLng pCalicut = LatLng(11.2588, 75.7804);
  static const LatLng pMarineDriveKochi = LatLng(9.9816, 76.2810);
  LatLng? _currentP;
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then((_) {
      getPolyLinePoints().then((coordinates) {
        generatePolyLineFromPoints(coordinates);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          : GoogleMap(
              onMapCreated: (controller) => _mapController.complete(controller),
              mapType: MapType.hybrid,
              initialCameraPosition: const CameraPosition(
                target: pCalicut,
                zoom: 13,
              ),
              markers: {
                Marker(
                    markerId: const MarkerId("_currentLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _currentP!),
                const Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: pCalicut),
                const Marker(
                    markerId: MarkerId("_destinationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: pMarineDriveKochi),
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  // Focus camera on current location
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 10,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  // Get user location updates
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
        .listen((LocationData _currentLocation) {
      if (_currentLocation.latitude != null &&
          _currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
          _cameraToPosition(_currentP!);
        });
      }
    });
  }

  // Get polyline points between two locations
  Future<List<LatLng>> getPolyLinePoints() async {
    List<LatLng> polyLineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: GOOGLE_MAPS_API_KEY,
      request: PolylineRequest(
        origin: PointLatLng(pCalicut.latitude, pCalicut.longitude),
        destination: PointLatLng(
            pMarineDriveKochi.latitude, pMarineDriveKochi.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polyLineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {
      // print("Error fetching polyline: ${result.errorMessage}");
    }
    return polyLineCoordinates;
  }

  // Generate and add polyline to the map
  void generatePolyLineFromPoints(List<LatLng> polyCoordinates) {
    if (polyCoordinates.isEmpty) {
      // print("No polyline points generated!");
      return;
    }

    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polyCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      jointType: JointType.round,
    );

    setState(() {
      polylines[id] = polyline;
    });

    // print("Polyline added successfully!");
  }
}
