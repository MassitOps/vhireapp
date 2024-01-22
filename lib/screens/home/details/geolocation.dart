import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vhireapp/models/agency.dart';
import 'package:vhireapp/shared/loading.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class Geolocation extends StatefulWidget {

  final String agency_id;
  const Geolocation({super.key, required this.agency_id});

  @override
  State<Geolocation> createState() => _GeolocationState();
}

class _GeolocationState extends State<Geolocation> {

  late GeoPoint location;
  late LatLng coordinates;
  bool _isLoading = true;
  String url = "https://www.google.com/maps?q=";

  Future<void> loadLocation() async {
    setState(() => _isLoading = true );
    location = await Agency.getLocationFromID(widget.agency_id);
    coordinates = LatLng(location.latitude, location.longitude);
    url += "${location.latitude},${location.longitude}";
    setState(() => _isLoading = false );
  }

  Future _launchURL(String url) async {
    if(await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw "Impossible de lancer $url";
    }
  }

  @override
  void initState() {
    super.initState();
    loadLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: (!_isLoading) ? SafeArea(
        child: FlutterMap(
          options: MapOptions(
            initialCenter: coordinates,
            initialZoom: 13,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 50.0,
                  height: 50.0,
                  point: coordinates,
                  child: const Icon(
                    Icons.location_pin,
                    size: 40.0,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            RichAttributionWidget(
              attributions: [
                const TextSourceAttribution(
                  '2024 - vhireapp',
                  onTap: null,
                ),
                TextSourceAttribution(
                  'Ouvrir dans Google Maps',
                  onTap: () => _launchURL(url),
                  textStyle: const TextStyle(
                    color: Colors.deepPurple,
                    decoration: TextDecoration.underline
                  ),
                ),
              ],
            ),
          ],
        )
      ) : const Loading(),
    );
  }
}
