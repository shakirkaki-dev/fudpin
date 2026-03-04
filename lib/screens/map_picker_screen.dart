import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {

  LatLng selectedLocation = const LatLng(12.9716, 77.5946);

  void onMapTapped(LatLng position) {
    setState(() {
      selectedLocation = position;
    });
  }

  void confirmLocation() {
    Navigator.pop(context, selectedLocation);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Location"),
        backgroundColor: Colors.orange,
      ),

      body: Stack(
        children: [

          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: selectedLocation,
              zoom: 14,
            ),
            onTap: onMapTapped,
            markers: {
              Marker(
                markerId: const MarkerId("restaurant"),
                position: selectedLocation,
              )
            },
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: confirmLocation,
              child: const Text("Confirm Location"),
            ),
          )

        ],
      ),
    );
  }
}