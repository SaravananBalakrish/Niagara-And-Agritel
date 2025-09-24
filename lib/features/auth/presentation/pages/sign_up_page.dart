import 'package:flutter/material.dart';

import '../../../../core/utils/app_images.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        title: Text(
          'Create Account',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Personal Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue[900]),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Mobile Number *',
                        prefixIcon: Icon(Icons.phone, color: Colors.blue[900]),
                        prefixText: '+91 ',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'User Name *',
                        prefixIcon: Icon(Icons.person, color: Colors.blue[900]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Select One',
                        prefixIcon: Icon(Icons.list, color: Colors.blue[900]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      items: ['Option 1', 'Option 2', 'Option 3'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {},
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Address',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.blue[900]),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Address 1',
                        prefixIcon: Icon(Icons.location_on, color: Colors.blue[900]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Address 2',
                        prefixIcon: Icon(Icons.location_on, color: Colors.blue[900]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Town',
                              prefixIcon: Icon(Icons.location_city, color: Colors.blue[900]),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'Village',
                              prefixIcon: Icon(Icons.location_city, color: Colors.blue[900]),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Select Country',
                              prefixIcon: Icon(Icons.public, color: Colors.blue[900]),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            items: ['India', 'USA', 'UK'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Select State',
                              prefixIcon: Icon(Icons.map, color: Colors.blue[900]),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            items: ['State 1', 'State 2', 'State 3'].map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'City',
                        prefixIcon: Icon(Icons.location_city, color: Colors.blue[900]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Postal Code',
                        prefixIcon: Icon(Icons.mail, color: Colors.blue[900]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Alternate Phone Number',
                        prefixIcon: Icon(Icons.phone, color: Colors.blue[900]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email, color: Colors.blue[900]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Password *',
                        prefixIcon: Icon(Icons.lock, color: Colors.blue[900]),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixIcon: Icon(Icons.visibility_off),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}