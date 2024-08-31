import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Map By MegaSoft(Dana Sherzad)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController mapController;
  LatLng currentLocation = const LatLng(
      36.1904, 44.0094); // ئەوە درێژی و پانی هەولێرە دەتوانی بیگۆڕی
  double zoomLevel = 13.0;
  Marker? marker;

  // لایەری سەرەکی hybrid م داناوە
  String currentLayer = 'y'; // دەتوانی بیگۆڕیت

  // ئەو جۆرە لەیارانەی تیایە
  List<Map<String, String>> layers = [
    {'layer': 'm', 'name': 'Standard Roadmap'},
    {'layer': 'y', 'name': 'Hybrid'},
    {'layer': 's', 'name': 'Satellite'},
    {'layer': 't', 'name': 'Terrain'},
    {'layer': 'h', 'name': 'Roads only'},
    {'layer': 'r', 'name': 'Different Roadmap'},
    {'layer': 'p', 'name': 'Terrain Map'},
  ];

  // دەتوانی داتاکان لە داتابەیس بهێنیتەوە
  final List<Map<String, dynamic>> places = [
    {
      'name': 'Erbil Citadel',
      'location': const LatLng(36.1912, 44.0094),
      'image':
          'https://whc.unesco.org/uploads/thumbs/site_1437_0005-1000-667-20140606145438.jpg',
      'description':
          'The Erbil Citadel (Kurdish: قەڵای هەولێر Qelay Hewlêr, Arabic: قلعة اربيل, romanized: Qal\'at Erbīl) locally called Qalat, is a tell or occupied mound, and the historical city centre of Erbil in the Kurdistan Region of Iraq.[1] The citadel has been included in the World Heritage List since 21 June 2014.',
    },
    {
      'name': 'Center of sulaymaniyah',
      'location': const LatLng(35.5558, 45.4351),
      'image':
          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Grand_Millennium_Sulaimani_Hotel_in_Sulaymaniyah%2C_Kurdistan.jpg/280px-Grand_Millennium_Sulaimani_Hotel_in_Sulaymaniyah%2C_Kurdistan.jpg', // Replace with actual image URL
      'description':
          'Sulaymaniyah or Slemani (Kurdish: سلێمانی, romanized: Silêmanî;[3][4] Arabic: السليمانية, romanized: as-Sulaymāniyyah[5]), is a city in the east of the Kurdistan Region of Iraq and is the capital of the Sulaymaniyah Governorate. It is surrounded by the Azmar (Ezmer), Goizha (Goyje) and Qaiwan (Qeywan) Mountains in the northeast, Baranan Mountain in the south and the Tasluja Hills in the west. The city has a semi-arid climate with very hot dry summers and cold wet winters.',
    },
  ];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Map By Dana Sherzad'),
      ),
      body: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: currentLocation,
          initialZoom: zoomLevel,
          maxZoom: 18,
          minZoom: 2,
        ),
        children: [
          TileLayer(
            urlTemplate:
                "https://mt0.google.com/vt/lyrs=$currentLayer@221097413,traffic,transit,bike&x={x}&y={y}&z={z}",
            subdomains: const ['mt0', 'mt1', 'mt2', 'mt3'],
          ),
          MarkerLayer(
            markers: places.map((place) {
              return Marker(
                point: place['location'],
                width: 150.0,
                height: 150.0,
                child: IconButton(
                  icon: const Icon(Icons.location_on, color: Colors.yellow),
                  onPressed: () {
                    _showPlaceInfo(context, place);
                  },
                ),
              );
            }).toList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeLayer,
        child: const Icon(Icons.layers),
      ),
    );
  }

  void _changeLayer() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: layers.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(layers[index]['name']!),
              onTap: () {
                setState(() {
                  currentLayer = layers[index]['layer']!;
                });
                Navigator.pop(context);
              },
            );
          },
        );
      },
    );
  }

  void _showPlaceInfo(BuildContext context, Map<String, dynamic> place) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(place['name']),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(place['image']),
              const SizedBox(height: 10),
              Text(place['description']),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
