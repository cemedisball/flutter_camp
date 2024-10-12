import 'package:flutter/material.dart';
import 'package:flutter_camp/models/camp_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_camp/controller/auth_service.dart';
import 'package:intl/intl.dart';

class Admin_EditCampPage extends StatefulWidget {
  final Camp camp;

  const Admin_EditCampPage({Key? key, required this.camp}) : super(key: key);

  @override
  _Admin_EditCampPageState createState() => _Admin_EditCampPageState();
}

class _Admin_EditCampPageState extends State<Admin_EditCampPage> {
  final _formKey = GlobalKey<FormState>();
  late String campName;
  late String campDetail;
  late String campPlace;
  late String campTopic;
  late int peopleCount;
  late DateTime date;
  late String time;
  String? _image;

  final List<String> campPlaces = ['พัทลุง', 'สงขลา'];

  @override
  void initState() {
    super.initState();
    campName = widget.camp.campName;
    campDetail = widget.camp.campDetail;
    campPlace = widget.camp.campPlace;
    campTopic = widget.camp.campTopic;
    peopleCount = widget.camp.peopleCount;
    date = widget.camp.date;
    time = widget.camp.time;
    //_image = widget.camp.image;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile.path;
      });
    }
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      Camp updatedCamp = Camp(
        id: widget.camp.id,
        campName: campName,
        campDetail: campDetail,
        campPlace: campPlace,
        campTopic: campTopic,
        peopleCount: peopleCount,
        date: date,
        time: time,
        //image: _image,
      );

      try {
        await AuthService().updateCamp(updatedCamp, context);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ไม่สามารถบันทึกการเปลี่ยนแปลง: $e')),
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
      initialTime: TimeOfDay(
        hour: int.parse(time.split(':')[0]),
        minute: int.parse(time.split(':')[1]),
      ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        time =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขแคมป์: ${widget.camp.campName}'),
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
                  initialValue: campName,
                  decoration: const InputDecoration(labelText: 'ชื่อแคมป์'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อแคมป์';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    campName = value;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: campDetail,
                  decoration:
                      const InputDecoration(labelText: 'รายละเอียดแคมป์'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    campDetail = value;
                  },
                ),
                SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: campPlace,
                  decoration: const InputDecoration(labelText: 'วิทยาเขต'),
                  items: campPlaces.map((String place) {
                    return DropdownMenuItem<String>(
                      value: place,
                      child: Text(place),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      campPlace = value!;
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
                  initialValue: campTopic,
                  decoration: const InputDecoration(labelText: 'หัวข้อแคมป์'),
                  onChanged: (value) {
                    campTopic = value;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: peopleCount.toString(),
                  decoration: const InputDecoration(labelText: 'จำนวนคน'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนคน';
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
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "เวลา: $time", // แสดงเวลา
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
                //     ? const Text('ยังไม่มีรูปภาพที่เลือก.')
                //     : Image.file(File(_image!)),
                // SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveChanges,
                  child: const Text('บันทึกการเปลี่ยนแปลง'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
