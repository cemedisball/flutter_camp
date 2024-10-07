import 'package:flutter/material.dart';
import 'package:flutter_camp/models/camp_model.dart';

class CampDetailPage extends StatelessWidget {
  final Camp camp;

  const CampDetailPage({Key? key, required this.camp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(camp.campName),
        backgroundColor:
            Color.fromARGB(255, 50, 198, 243), // เปลี่ยนสีของ AppBar
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue[50], // สีพื้นหลังคลุมทั้งหน้า
        ),
        child: Center(
          // ทำให้การ์ดอยู่ตรงกลาง
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 8,
              color: Colors.white, // สีพื้นหลังของการ์ด
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // มุมการ์ดมน
              ),
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.9, // กำหนดความกว้างของการ์ด
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min, // ปรับให้การ์ดพอดีกับเนื้อหา
                  children: [
                    Text(
                      camp.campName,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color:
                            Color.fromARGB(255, 5, 30, 248), // สีของชื่อแคมป์
                      ),
                    ),
                    SizedBox(height: 12),
                    _buildDetailRow('รายละเอียดแคมป์', camp.campDetail),
                    _buildDetailRow('หัวข้อ', camp.campTopic),
                    _buildDetailRow('วิทยาเขต', camp.campPlace),
                    _buildDetailRow('จำนวนคน', '${camp.peopleCount}'),
                    _buildDetailRow('วันที่',
                        camp.date.toLocal().toIso8601String().split('T')[0]),
                    _buildDetailRow('เวลา', camp.time),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildDetailRow(String title, String detail) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(
                255, 50, 198, 243), // สีของหัวข้อรายละเอียด
          ),
        ),
        SizedBox(height: 4),
        Text(
          detail,
          style: TextStyle(fontSize: 16),
        ),
      ],
    ),
  );
}
