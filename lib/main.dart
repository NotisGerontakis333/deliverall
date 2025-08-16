import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
void main() => runApp(const DeliverAllApp());
class DeliverAllApp extends StatelessWidget {
  const DeliverAllApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeliverAll',
      theme: ThemeData.dark(),
      home: const MapScreen(),
    );
  }
}
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}
class _MapScreenState extends State<MapScreen> {
  final List<LatLng> customers = [LatLng(37.9838, 23.7275)];
  final List<LatLng> vendors = [LatLng(37.9850, 23.7290)];
  final List<LatLng> drivers = [LatLng(37.9810, 23.7250)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(initialCenter: LatLng(37.9838, 23.7275), initialZoom: 13),
        children: [
          TileLayer(urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: const ['a','b','c']),
          MarkerLayer(markers: [
            ...customers.map((p) => Marker(point: p, width: 30, height: 30, child: const Icon(Icons.person,color: Colors.blue))),
            ...vendors.map((p) => Marker(point: p, width: 30, height: 30, child: const Icon(Icons.store,color: Colors.orange))),
            ...drivers.map((p) => Marker(point: p, width: 30, height: 30, child: const Icon(Icons.delivery_dining,color: Colors.green))),
          ])
        ],
      ),
    );
  }
}
