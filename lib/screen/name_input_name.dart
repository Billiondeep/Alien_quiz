import 'package:flutter/material.dart';
import 'home_screen.dart';

class NameInputScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF29243E),
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text("Masukan Nama"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(hintText: "Username"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                },
                child: Text("Enter"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}