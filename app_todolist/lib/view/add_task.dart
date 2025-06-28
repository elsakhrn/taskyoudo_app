import 'package:app_todolist/controller/meeting_controller.dart';
import 'package:app_todolist/controller/notification_controller.dart';
import 'package:app_todolist/model/meeting.dart';
import 'package:app_todolist/providers/calendar_provider.dart';
import 'package:app_todolist/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTask extends StatelessWidget {
  const AddTask({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController judulController = TextEditingController();
    TextEditingController tglmulaiController = TextEditingController();
    TextEditingController tglselesaiController = TextEditingController();
    TextEditingController deskripsiTugasController = TextEditingController();
    String matakuliah = '';
    String jenistugas = '';
    String warna = '';
    DateTime tglmulai;
    DateTime tglselesai;
    String pengingat = '';
    Map<String, Color> daftarWarna = {
      'Biru': Colors.blue,
      'Merah': Colors.red,
      'Kuning': Colors.amber,
      'Hijau': Colors.green,
    };
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Add Task'),
        backgroundColor: Colors.blue,
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: judulController,
              decoration: InputDecoration(hintText: 'Judul Tugas'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul Tugas tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mata Kuliah tidak boleh kosong';
                }
              },
              value: matakuliah,
              items: [
                DropdownMenuItem(child: Text('Mata Kuliah'), value: ''),
                DropdownMenuItem(
                  child: Text('Aljabar Linear'),
                  value: 'Aljabar Linear',
                ),
                DropdownMenuItem(
                  child: Text('Basis Data I'),
                  value: 'Basis Data I',
                ),
                DropdownMenuItem(
                  child: Text('Data Mining'),
                  value: 'Data Mining',
                ),
                DropdownMenuItem(
                  child: Text('Fisika Dasar I'),
                  value: 'Fisika Dasar I',
                ),
              ],
              onChanged: (value) {
                matakuliah = value!;
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jenis Tugas tidak boleh kosong';
                }
              },
              value: jenistugas,
              items: [
                DropdownMenuItem(child: Text('Jenis Tugas'), value: ''),
                DropdownMenuItem(child: Text('Individu'), value: 'Individu'),
                DropdownMenuItem(child: Text('Kelompok'), value: 'Kelompok'),
              ],
              onChanged: (value) {
                jenistugas = value!;
              },
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Warna tidak boleh kosong';
                }
              },
              value: warna,
              items: [
                DropdownMenuItem(child: Text('Warna'), value: ''),
                DropdownMenuItem(
                  child: Text('Merah', style: TextStyle(color: Colors.red)),
                  value: 'Merah',
                ),
                DropdownMenuItem(
                  child: Text('Kuning', style: TextStyle(color: Colors.amber)),
                  value: 'Kuning',
                ),
                DropdownMenuItem(
                  child: Text('Biru', style: TextStyle(color: Colors.blue)),
                  value: 'Biru',
                ),
                DropdownMenuItem(
                  child: Text('Hijau', style: TextStyle(color: Colors.green)),
                  value: 'Hijau',
                ),
              ],
              onChanged: (value) {
                warna = value!;
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                var selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2001),
                  lastDate: DateTime(2030),
                  locale: Locale('id', 'ID'),
                );
                if (selectedDate == null) return;
                tglmulaiController.text = DateFormat(
                  'EEEE, dd MMMM yyyy',
                  'id_ID',
                ).format(selectedDate);
              },
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Mulai tidak boleh kosong';
                  }
                  return null;
                },
                controller: tglmulaiController,
                enabled: false,
                decoration: InputDecoration(hintText: 'Tanggal Mulai:'),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () async {
                var selectedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2001),
                  lastDate: DateTime(2030),
                  locale: Locale('id', 'ID'),
                );
                if (selectedDate == null) return;
                tglselesaiController.text = DateFormat(
                  'EEEE, dd MMMM yyyy',
                  'id_ID',
                ).format(selectedDate);
              },
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal Selesai tidak boleh kosong';
                  } else if (DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                      .parse(value)
                      .isBefore(
                        DateTime.now().add(
                          Duration(
                            days:
                                pengingat.isNotEmpty ? int.parse(pengingat) : 0,
                          ),
                        ),
                      )) {
                    return 'Tanggal Selesai tidak valid';
                  }
                  return null;
                },
                controller: tglselesaiController,
                enabled: false,
                decoration: InputDecoration(hintText: 'Tanggal Selesai:'),
              ),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Pengingat tidak boleh kosong';
                }
              },
              value: pengingat,
              items: [
                DropdownMenuItem(child: Text('Pengingat'), value: ''),
                DropdownMenuItem(
                  child: Text('1 Hari Sebelum Pengumpulan'),
                  value: '1',
                ),
                DropdownMenuItem(
                  child: Text('2 Hari Sebelum Pengumpulan'),
                  value: '2',
                ),
                DropdownMenuItem(
                  child: Text('3 Hari Sebelum Pengumpulan'),
                  value: '3',
                ),
              ],
              onChanged: (value) {
                pengingat = value!;
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Deskripsi Tugas tidak boleh kosong';
                }
                return null;
              },
              maxLines: 5,
              controller: deskripsiTugasController,
              decoration: InputDecoration(hintText: 'Deskripsi Tugas'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await MeetingController().addMeeting({
                    'eventName': judulController.text,
                    'from': DateFormat(
                      'EEEE, dd MMMM yyyy',
                      'id_ID',
                    ).parse(tglmulaiController.text),
                    'to': DateFormat(
                      'EEEE, dd MMMM yyyy',
                      'id_ID',
                    ).parse(tglselesaiController.text),
                    'background': daftarWarna[warna],
                    'mataKuliah': matakuliah,
                    'jenisTugas': jenistugas,
                    'deskripsiTugas': deskripsiTugasController.text,
                    'pengingat': int.tryParse(pengingat) ?? 0,
                  });

                  NotificationController().scheduleNotification(
                    id: DateTime.now().millisecond,
                    title: 'Tugasmu Adalah: ${judulController.text}',
                    body:
                        'Deadline tinggal $pengingat hari lagi,kerjakan tugas $matakuliah sekarang!',
                    scheduledTime: DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                        .parse(tglselesaiController.text)
                        .subtract(Duration(days: int.tryParse(pengingat) ?? 0)),
                  );

                  if (!context.mounted) return;
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
                  );
                }
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save),
                  Text('Simpan Tugas', style: TextStyle(color: Colors.blue)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
