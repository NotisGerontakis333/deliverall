import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://your-supabase-url.supabase.co',
    anonKey: 'your-anon-key',
  );
  runApp(DeliverAllApp());
}

class DeliverAllApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black87),
    home: DeliverAllMap(),
  );
}

class DeliverAllMap extends StatefulWidget {
  @override
  _DeliverAllMapState createState() => _DeliverAllMapState();
}

class _DeliverAllMapState extends State<DeliverAllMap> {
  final Map<String, double> wallet = {'customer': 100.0, 'vendor': 0.0, 'driver': 0.0};
  final List<LatLng> customers = [LatLng(37.9838, 23.7275)];
  final List<LatLng> vendors = [LatLng(37.9858, 23.7275)];
  final List<LatLng> drivers = [LatLng(37.9848, 23.7295)];
  String currentRole = 'customer';
  List<Map<String, dynamic>> blockchain = [];

  void addTransaction(String from, String to, double amount) {
    if (wallet[from]! >= amount) {
      wallet[from] = wallet[from]! - amount;
      wallet[to] = wallet[to]! + amount * 0.97; // 3% fee for app
      blockchain.add({'from': from, 'to': to, 'amount': amount, 'time': DateTime.now().toIso8601String()});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Transaction $amount Dall coins from $from to $to')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: MapOptions(center: LatLng(37.9838, 23.7275), zoom: 13),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              ...customers.map((p) => Marker(
                  point: p, width: 30, height: 30, builder: (_) => Icon(Icons.person, color: Colors.blue))),
              ...vendors.map((p) => Marker(
                  point: p, width: 30, height: 30, builder: (_) => Icon(Icons.store, color: Colors.orange))),
              ...drivers.map((p) => Marker(
                  point: p, width: 30, height: 30, builder: (_) => Icon(Icons.delivery_dining, color: Colors.green))),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: 'role',
            label: Text('Role: $currentRole'),
            icon: Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                currentRole = currentRole == 'customer'
                    ? 'vendor'
                    : currentRole == 'vendor'
                    ? 'driver'
                    : 'customer';
              });
            },
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: 'action',
            label: Text('Pay 3 Dall'),
            icon: Icon(Icons.monetization_on),
            onPressed: () {
              String from = currentRole;
              String to = currentRole == 'customer' ? 'vendor' : 'customer';
              addTransaction(from, to, 3);
            },
          ),
        ],
      ),
    );
  }
}
