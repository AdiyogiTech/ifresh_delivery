import 'dart:convert';
import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ifresh_delivery/colors/colors.dart';

class TrackLocation extends StatefulWidget {
  final String? id;
  final String? name;
  final String? mobile;
  final String? address;
  final String? lat; // Latitude from product detail screen
  final String? long; // Longitude from product detail screen

  TrackLocation({
    Key? key,
    this.lat,
    this.long,
    this.id,
    this.name,
    this.mobile,
    this.address,
  }) : super(key: key);

  @override
  State<TrackLocation> createState() => _TrackLocationState();
}

class _TrackLocationState extends State<TrackLocation> {
  final Set<Polyline> _polylines = HashSet<Polyline>();
  final Set<Marker> _markers = HashSet<Marker>();
  final Completer<GoogleMapController> _controller = Completer();
  static CameraPosition startingPosition = CameraPosition(
    target: LatLng(26.263863, 73.008957), // Default starting position
    zoom: 15,
  );

  late LatLng currentLatLng;
  late LatLng destinationLatLng;

  @override
  void initState() {
    super.initState();
    currentLatLng = LatLng(26.263863, 73.008957); // Replace with actual current location
    if (widget.lat != null && widget.long != null) {
      destinationLatLng = LatLng(double.parse(widget.lat!), double.parse(widget.long!));
    } else {
      destinationLatLng = currentLatLng; // Fallback
    }

    _markers.add(Marker(
      markerId: MarkerId('sourceMarker'),
      position: currentLatLng,
      infoWindow: InfoWindow(title: 'Source'),
    ));

    _markers.add(Marker(
      markerId: MarkerId('destinationMarker'),
      position: destinationLatLng,
      infoWindow: InfoWindow(title: 'Destination'),
    ));

    _getPolyline();
  }

  Future<void> _getPolyline() async {
    final googleApiKey = 'YOUR_GOOGLE_MAPS_API_KEY'; // Replace with your API key
    final url = 'https://maps.googleapis.com/maps/api/directions/json?origin=${currentLatLng.latitude},${currentLatLng.longitude}&destination=${destinationLatLng.latitude},${destinationLatLng.longitude}&key=$googleApiKey';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final routes = data['routes'] as List;
      if (routes.isNotEmpty) {
        final polyline = routes[0]['overview_polyline']['points'];
        final points = _decodePolyline(polyline);
        setState(() {
          _polylines.add(Polyline(
            polylineId: PolylineId('route'),
            color: Colors.blue,
            points: points,
            width: 5,
          ));
        });
      }
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;
      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;
      points.add(LatLng(
        (lat / 1E5).toDouble(),
        (lng / 1E5).toDouble(),
      ));
    }
    return points;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: textcolor2,
            )),
        title: Text(
          "Track Location",
          style: TextStyle(
            color: textcolor2,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: primary,
      ),

      body: GoogleMap(
        initialCameraPosition: startingPosition,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: _markers,
        polylines: _polylines,
      ),
    );
  }
}
