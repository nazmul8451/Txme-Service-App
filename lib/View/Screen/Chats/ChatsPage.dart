import 'package:flutter/material.dart';

import '../../Widgegt/CustomBottomNavBar/ProviderNavBar.dart';

class Chatspage extends StatefulWidget {
  const Chatspage({super.key});

  @override
  State<Chatspage> createState() => _ChatspageState();
}

class _ChatspageState extends State<Chatspage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("sakil")),


      //bottomNavigationBar: CustomProvidernavbar(selectedIndex: 3),
    );
  }
}
