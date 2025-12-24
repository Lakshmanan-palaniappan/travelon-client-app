import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Myrequestpage extends StatelessWidget {
  const Myrequestpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.go('/home'),
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListTile(title: Text("New Request")),
          ListTile(title: Text("Pending Request")),
        ],
      ),
    );
  }
}
