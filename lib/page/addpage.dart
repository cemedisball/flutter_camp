import 'package:flutter/material.dart';
import 'package:flutter_camp/models/camp_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_camp/controller/auth_service.dart';
import 'package:intl/intl.dart';

class Admin_AddCampPage extends StatefulWidget {
  const Admin_AddCampPage({Key? key}) : super(key: key);

  @override
  _Admin_AddCampPageState createState() => _Admin_AddCampPageState();
}

class _Admin_AddCampPageState extends State<Admin_AddCampPage> {
  final _formKey = GlobalKey<FormState>();
  String campName = '';
  String campDetail = '';
  String campPlace = '';
  String campTopic = '';
  int peopleCount = 0;
  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();
  String? _image;

  final List<String> campPlaces = ['พัทลุง', 'สงขลา'];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile.path;
      });
    }
  }

  void _saveCamp() async {
    if (_formKey.currentState!.validate()) {
      Camp newCamp = Camp(
        id: '', // ตั้งค่าที่เหมาะสม
        campName: campName,
        campDetail: campDetail,
        campPlace: campPlace,
        campTopic: campTopic,
        peopleCount: peopleCount,
        date: date,
        time:
            '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
        //image: _image,
      );

      try {
        await AuthService().addCamp(newCamp, context);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add camp: $e')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != date) {
      setState(() {
        date = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != time) {
      setState(() {
        time = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Camp'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ชื่อแคมป์'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ชื่อแคมป์';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    campName = value;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'รายละเอียดแคมป์'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่รายละเอียดแคมป์';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    campDetail = value;
                  },
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: campPlace.isEmpty ? null : campPlace,
                  decoration: const InputDecoration(labelText: 'วิทยาเขต'),
                  items: campPlaces.map((String place) {
                    return DropdownMenuItem<String>(
                      value: place,
                      child: Text(place),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      campPlace = value ?? ''; // เก็บค่าที่เลือก
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'กรุณาเลือกวิทยาเขต';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'หัวข้อแคมป์'),
                  onChanged: (value) {
                    campTopic = value;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'จำนวนคน'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่จำนวนคน';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    peopleCount = int.tryParse(value) ?? 0;
                  },
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "วันที่:  ${DateFormat('dd-MM-yyyy').format(date)}",
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('เลือกวัน'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "เวลา: ${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}", // แสดงเวลา
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(context),
                      child: const Text('เลือกเวลา'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // ElevatedButton(
                //   onPressed: _pickImage,
                //   child: const Text('เลือกรูปภาพจาก Gallery'),
                // ),
                // SizedBox(height: 20),
                // _image == null
                //     ? const Text('No image selected.')
                //     : Image.file(File(_image!)),
                //SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveCamp,
                  child: const Text('Save Camp'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
