import 'package:flutter/material.dart';
import 'package:flutter_camp/models/camp_model.dart';

class Admin_CampDetailPage extends StatelessWidget {
  final Camp camp;

  const Admin_CampDetailPage({Key? key, required this.camp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(camp.campName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ชื่อแคมป์: ${camp.campName}', style: TextStyle(fontSize: 24)),
            SizedBox(height: 8),
            Text('หัวข้อ: ${camp.campTopic}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('รายละเอียด: ${camp.campDetail}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('วิทยาเขต: ${camp.campPlace}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('จำนวนคน: ${camp.peopleCount}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text(
                'วันที่: ${camp.date.toLocal().toIso8601String().split('T')[0]}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('เวลา: ${camp.time}', style: TextStyle(fontSize: 16)),
            // เพิ่มข้อมูลเพิ่มเติมที่ต้องการแสดงที่นี่
          ],
        ),
      ),
    );
  }
}
