import 'package:app_todolist/controller/meeting_controller.dart';
import 'package:app_todolist/controller/notification_controller.dart';
import 'package:app_todolist/model/meeting.dart';
import 'package:app_todolist/providers/calendar_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditTask extends StatelessWidget {
  final Meeting meeting;
  const EditTask({super.key, required this.meeting});

  @override
  Widget build(BuildContext context) {
    TextEditingController judulController = TextEditingController(text: meeting.eventName);
    TextEditingController tglmulaiController = TextEditingController(text: DateFormat('EEEE, dd MMMM yyyy').format(meeting.from));
    TextEditingController tglselesaiController = TextEditingController(text: DateFormat('EEEE, dd MMMM yyyy').format(meeting.to));
    TextEditingController deskripsiTugasController = TextEditingController(text: meeting.deskripsiTugas);
    String matakuliah = meeting.mataKuliah;
    String jenistugas = meeting.jenisTugas;
    String warna = MeetingController().getStringFromColor(meeting.background);
    String pengingat = meeting.pengingat.toString();
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
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 20),
        children: [
          TextFormField(
            controller: judulController,
            decoration: InputDecoration(hintText: 'Judul Tugas'),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
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
            value: jenistugas,
            items: [
              DropdownMenuItem(child: Text('Jenis Tugas'), value: ''),
              DropdownMenuItem(
                child: Text('Individu'),
                value: 'Individu',
              ),
              DropdownMenuItem(
                child: Text('Kelompok'),
                value: 'Kelompok',
              ),
            ],
            onChanged: (value) {
              jenistugas = value!;
            },
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
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
              );
              if (selectedDate == null) return;
              tglmulaiController.text = DateFormat(
                'EEEE, dd MMMM yyyy',
              ).format(selectedDate);
            },
            child: TextFormField(
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
              );
              if (selectedDate == null) return;
              tglselesaiController.text = DateFormat(
                'EEEE, dd MMMM yyyy',
              ).format(selectedDate);
            },
            child: TextFormField(
              controller: tglselesaiController,
              enabled: false,
              decoration: InputDecoration(hintText: 'Tanggal Selesai:'),
            ),
          ),
          SizedBox(height: 20),
          DropdownButtonFormField(
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
            maxLines: 5,
            controller: deskripsiTugasController,
            decoration: InputDecoration(
              hintText: 'Deskripsi Tugas',
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await MeetingController().editMeeting(
                meeting.id,
                {
                  'eventName': judulController.text,
                  'from': DateFormat('EEEE, dd MMMM yyyy').parse(tglmulaiController.text),
                  'to': DateFormat('EEEE, dd MMMM yyyy').parse(tglselesaiController.text),
                  'background': MeetingController().getColorFromString(warna),
                  'mataKuliah': matakuliah,
                  'jenisTugas': jenistugas,
                  'deskripsiTugas': deskripsiTugasController.text,
                  'pengingat': int.tryParse(pengingat) ?? 0,
                },
              );

              // NotificationController().scheduleNotification(
              //   id: DateTime.now().millisecond,
              //   title: 'Tugasmu Adalah: ${judulController.text}',
              //   body: 'Deadline tinggal $pengingat hari lagi,kerjakan tugas $matakuliah sekarang!',
              //   scheduledTime: DateFormat('EEEE, dd MMMM yyyy').parse(tglselesaiController.text).subtract(
              //     Duration(days: int.tryParse(pengingat) ?? 0),
              //   ),
              // );

              // if (!context.mounted) return;
              // context.read<CalendarProvider>().tambahMeeting(Meeting(
              //   eventName: judulController.text,
              //   from: DateFormat('EEEE, dd MMMM yyyy').parse(tglmulaiController.text),
              //   to: DateFormat('EEEE, dd MMMM yyyy').parse(tglselesaiController.text),
              //   background: daftarWarna[warna]!,
              //   mataKuliah: matakuliah,
              //   jenisTugas: jenistugas,
              //   deskripsiTugas: deskripsiTugasController.text,
              //   pengingat: int.tryParse(pengingat) ?? 0,
              // ));
              Navigator.pop(context);
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
    );
  }
}
