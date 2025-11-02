import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/token_storage.dart'; // assuming this stores your agencyId or touristId

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> userAddedLocation = [];
  String? agencyId;

  @override
  void initState() {
    super.initState();
    _loadAgencyId();
  }

  Future<void> _loadAgencyId() async {
    final id =
        await TokenStorage.getTouristId(); // or getAgencyId() if you store it separately
    setState(() => agencyId = id ?? "Unknown Agency");
  }

  void _showAddLocationDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController latController = TextEditingController();
    final TextEditingController lngController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add New Location'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Location Name',
                    ),
                  ),
                  TextField(
                    controller: latController,
                    decoration: const InputDecoration(labelText: 'Latitude'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: lngController,
                    decoration: const InputDecoration(labelText: 'Longitude'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: agencyId ?? ''),
                    decoration: const InputDecoration(
                      labelText: 'Agency ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      latController.text.isNotEmpty &&
                      lngController.text.isNotEmpty) {
                    setState(() {
                      userAddedLocation.add({
                        'name': nameController.text,
                        'lat': latController.text,
                        'lng': lngController.text,
                        'agencyId': agencyId,
                      });
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Locations')),
      body:
          userAddedLocation.isEmpty
              ? const Center(child: Text('No locations added yet.'))
              : ListView.builder(
                itemCount: userAddedLocation.length,
                itemBuilder: (context, index) {
                  final loc = userAddedLocation[index];
                  return ListTile(
                    title: Text(loc['name']),
                    subtitle: Text(
                      'Lat: ${loc['lat']} | Lng: ${loc['lng']} | Agency: ${loc['agencyId']}',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() => userAddedLocation.removeAt(index));
                      },
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLocationDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
