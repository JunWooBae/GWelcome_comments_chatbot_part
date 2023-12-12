import 'package:flutter/material.dart';

class MorePolicy extends StatefulWidget {
  const MorePolicy({super.key});

  @override
  State<MorePolicy> createState() => _MorePolicyState();
}

class _MorePolicyState extends State<MorePolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      body: Center(
        child: Text('SW World',
          style: TextStyle(
            color: Colors.white,
            fontSize: 60.0,
          ),
        ),
      ),
    );
  }
}
