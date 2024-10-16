import 'package:flutter/material.dart';
import 'package:flutter_camp/models/camp_model.dart';
import 'package:flutter_camp/controller/auth_service.dart';
import 'package:flutter_camp/page/CampDetailPage.dart';
import 'package:flutter_camp/page/login.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  _GuestPageState createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {
  final AuthService authService = AuthService();
  List<Camp> camps = [];
  List<String> years = []; // รายการปีที่เป็น String
  String? selectedYear; // ปีที่เลือก
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCamps();
  }

  Future<void> fetchCamps() async {
    final fetchedCamps = await authService.fetchCamps();
    setState(() {
      camps = fetchedCamps;
      years = fetchedCamps
          .map((camp) => camp.date.year.toString())
          .toSet()
          .toList()
        ..sort();

      years.insert(0, 'ทั้งหมด'); // เพิ่มตัวเลือก "ทั้งหมด"
      isLoading = false;
    });
  }

  List<Camp> getFilteredCamps() {
    if (selectedYear == null || selectedYear == 'ทั้งหมด') {
      return camps; // แสดงค่ายทั้งหมดถ้ายังไม่มีการเลือกปีหรือเลือก "ทั้งหมด"
    }
    return camps
        .where((camp) => camp.date.year.toString() == selectedYear)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCamps = getFilteredCamps();

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Page'),
        backgroundColor: const Color.fromARGB(255, 146, 209, 238),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const LoginForm()), // เปลี่ยนไปยังหน้า AdminPage
              );
            },
            child: Text(
              'Admin',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 255, 255, 255), // เปลี่ยนสี
                shadows: [
                  Shadow(
                    blurRadius: 10.0,
                    color: Colors.black45,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                DropdownButton<String>(
                  hint: const Text('เลือกปี'),
                  value: selectedYear,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue; // ใช้ค่า null สำหรับ "ทั้งหมด"
                    });
                  },
                  items: years.map((String year) {
                    return DropdownMenuItem<String>(
                      value: year == 'ทั้งหมด' ? null : year,
                      child: Text(year),
                    );
                  }).toList(),
                ),
                Expanded(
                  child: filteredCamps.isEmpty
                      ? const Center(
                          child: Text('No camps available',
                              style: TextStyle(fontSize: 18)),
                        )
                      : ListView.builder(
                          itemCount: filteredCamps.length,
                          itemBuilder: (context, index) {
                            final camp = filteredCamps[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(camp.campName,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 5, 30, 248))),
                                    const SizedBox(height: 8),
                                    Text('หัวข้อ: ${camp.campTopic}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text('วิทยาเขต: ${camp.campPlace}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text('${camp.peopleCount} คน',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text(
                                        'วันที่: ${camp.date.toLocal().toIso8601String().split('T')[0]}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text('เวลา: ${camp.time}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CampDetailPage(camp: camp)),
                                        );
                                      },
                                      child: const Text('More Detail'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 142, 223, 248),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
