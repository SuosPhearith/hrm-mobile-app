import 'package:flutter/material.dart';
import 'package:mobile_app/widgets/custom_header.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Card",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        bottom: CustomHeader(),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "កំពុងអភិវឌ្ឍន៍",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
