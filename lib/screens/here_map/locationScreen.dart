import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:here_sdk/core.dart';
import 'package:here_sdk/mapview.dart';
import 'package:ifresh_delivery/screens/here_map/routing.dart';


class LocationTrackerScreen extends StatefulWidget {
  GeoCoordinates Start, end, deliveryBoyLocation;
    LocationTrackerScreen({super.key, required this.Start, required this.end,required this.deliveryBoyLocation});

  @override
  State<LocationTrackerScreen> createState() => _LocationTrackerScreenState();
}

class _LocationTrackerScreenState extends State<LocationTrackerScreen> {

  // late Position position;

  Timer? _locationTimer;



  @override
  void dispose() {
    _locationTimer?.cancel();   // yaha cancel

    super.dispose();
  }


  RoutingExample? _routingExample;
  HereMapController? _hereMapController;

  String timeDistance = '';
  String Distance = '';


  ///on Map Created Function
  void _onMapCreated(HereMapController hereMapController) {
    _hereMapController = hereMapController;
    _hereMapController?.mapScene.loadSceneForMapScheme(MapScheme.normalDay,
            (MapError? error) {
          if (error == null) {
            _hereMapController?.mapScene.enableFeatures(
                {MapFeatures.lowSpeedZones: MapFeatureModes.lowSpeedZonesAll});
            _routingExample = RoutingExample(hereMapController);
            _routingExample!.addRoute(startCoordination: widget.Start, endCoordination:widget.end);
            _routingExample!.setTapListener(context: context);
            log('yes');
          } else {
            print("Map scene not loaded. MapError: $error");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HereMap(
        onMapCreated: _onMapCreated,
      ),
    );
  }
}
