import 'package:flutter/material.dart';
import 'package:flutter_camp/main.dart';
import 'package:flutter_camp/models/camp_model.dart';
import 'package:flutter_camp/controller/auth_service.dart';
import 'package:flutter_camp/page/CampDetailPage.dart';
import 'package:flutter_camp/page/guest_page.dart';
import 'package:flutter_camp/page/login.dart';
import 'package:flutter_camp/provider/admin_providers.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_camp/variables.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_camp/page/editpage.dart';
import 'package:flutter_camp/page/addpage.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final AuthService authService = AuthService();
  List<Camp> camps = [];
  List<String> years = []; // รายการปี
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
        ..sort(); // สร้างรายการปี
      years.insert(0, 'ทั้งหมด'); // เพิ่มตัวเลือก "ทั้งหมด"
      isLoading = false;
    });
  }

  List<Camp> getFilteredCamps() {
    if (selectedYear == null || selectedYear == '-1') {
      return camps; // แสดงค่ายทั้งหมดถ้ายังไม่มีการเลือกปีหรือเลือก "ทั้งหมด"
    }
    return camps
        .where((camp) => camp.date.year.toString() == selectedYear)
        .toList();
  }

  void _editCamp(Camp camp) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Admin_EditCampPage(camp: camp), // เปิดหน้า Edit
      ),
    );
    if (result == true) {
      fetchCamps(); // โหลดข้อมูลใหม่หลังจากแก้ไข
    }
  }

  void _deleteCamp(Camp camp) async {
    final userProvider = Provider.of<AdminProviders>(context, listen: false);
    String? token = userProvider.accessToken;
    print("accessToken: $token");

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Camp'),
          content: const Text('Are you sure you want to delete this camp?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await authService.deleteCamp(camp, context);
        setState(() {
          camps.remove(camp);
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete camp: $e')),
        );
      }
    }
  }

  void _addCamp() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Admin_AddCampPage(),
      ),
    );
    if (result == true) {
      fetchCamps(); // โหลดข้อมูลใหม่หลังจากเพิ่ม
    }
  }

  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?'),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('ออกจากระบบ'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    if (confirm == true) {
      // ทำการ logout
      final userProvider = Provider.of<AdminProviders>(context, listen: false);
      userProvider.onLogout();
      // หรือทำการนำทางกลับไปยังหน้า Login
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => const GuestPage()), // เปลี่ยนไปหน้า LoginForm
        (route) => false, // ลบเส้นทางทั้งหมดใน stack
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredCamps = getFilteredCamps();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Page'),
        backgroundColor: const Color.fromARGB(255, 146, 209, 238),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout, // เรียกใช้ฟังก์ชัน Logout
            tooltip: 'Logout',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100, // กำหนดความกว้างของ DropdownButton
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: const Text('เลือกปี'),
                        value: selectedYear,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedYear = newValue;
                          });
                        },
                        items: years.map((String year) {
                          return DropdownMenuItem<String>(
                            value: year == 'ทั้งหมด' ? null : year,
                            child: Text(year),
                          );
                        }).toList(),
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(
                        width: 50), // เพิ่มระยะห่างระหว่าง Dropdown และ Icon
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addCamp,
                      tooltip: 'Add New Camp',
                    ),
                  ],
                ),
                Expanded(
                  child: filteredCamps.isEmpty
                      ? const Center(
                          child: Text('ไม่มีแคมป์',
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
                                        'วันที่: ${DateFormat('dd-MM-yyyy').format(camp.date)}',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    Text('เวลา: ${camp.time} น.',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 0, 0, 0))),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CampDetailPage(
                                                          camp: camp)),
                                            );
                                          },
                                          child: const Text('More Detail'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 142, 223, 248),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => _editCamp(camp),
                                              color: Colors.blue,
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () =>
                                                  _deleteCamp(camp),
                                              color: Colors.red,
                                            ),
                                          ],
                                        ),
                                      ],
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
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //     children: [
      //       IconButton(
      //         icon: const Icon(Icons.add),
      //         onPressed: _addCamp, // เรียกใช้ฟังก์ชันเพิ่มค่าย
      //         tooltip: 'Add New Camp',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
