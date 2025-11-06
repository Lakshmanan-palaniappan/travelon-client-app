import 'package:flutter/material.dart';
import 'package:Travelon/core/utils/token_storage.dart';
import 'package:go_router/go_router.dart'; // assuming this stores your agencyId or touristId

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List<Map<String, dynamic>> userAddedLocation = [];
  String? agencyId;
  String? TouristID;

  @override
  void initState() {
    super.initState();
    _loadAgencyId();
  }

  Future<void> _loadAgencyId() async {
    final id = await TokenStorage.getAgencyId();
    final Tid = await TokenStorage.getAgencyId(); // ✅ use getAgencyId()
    setState(() {
      agencyId = id ?? "Unknown Agency";
      TouristID = Tid ?? "2584";
    });
  }

  void _showAddLocationDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController latController = TextEditingController();
    final TextEditingController lngController = TextEditingController();

    String? TouristId;
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
                  TextField(
                    readOnly: true,
                    controller: TextEditingController(text: TouristId ?? ''),
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
      appBar: AppBar(
        title: const Text('My Locations'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              final shouldLogout = await _confirmLogout(context);
              if (shouldLogout) {
                await TokenStorage.clear(); // remove all tokens & data
                if (context.mounted) {
                  context.go('/login'); // redirect to login
                }
              }
            },
          ),
        ],
      ),

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

  Future<bool> _confirmLogout(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to log out?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
        ) ??
        false;
  }
}
