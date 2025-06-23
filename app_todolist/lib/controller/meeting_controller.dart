import 'package:app_todolist/model/meeting.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MeetingController {
  Dio dio = Dio();

  Color getColorFromString(String colorString) {
    switch (colorString) {
      case 'Biru':
        return Colors.blue;
      case 'Merah':
        return Colors.red;
      case 'Kuning':
        return Colors.amber;
      case 'Hijau':
        return Colors.green;
      default:
        return Colors.blue; // Default color if no match
    }
  }

  String getStringFromColor(Color color) {
    switch (color) {
      case Colors.blue:
        return 'Biru';
      case Colors.red:
        return 'Merah';
      case Colors.amber:
        return 'Kuning';
      case Colors.green:
        return 'Hijau';
      default:
        return 'Biru'; // Default color if no match
    }
  }

  Future<List<Meeting>> getAll() async {
    var response = await dio.get('http://10.0.2.2:8000/api/tasks');
    List<Meeting> meetings = [];

    // Check if the response is successful
    if (response.statusCode == 200) {
      for (var meeting in response.data) {
        Color warna = getColorFromString(meeting['warna']);

        meetings.add(
          Meeting(
            id: meeting['id'],
            eventName: meeting['judul_tugas'],
            from: DateTime.parse(meeting['tanggal_mulai']),
            to: DateTime.parse(meeting['tanggal_selesai']),
            background: warna,
            mataKuliah: meeting['mata_kuliah'],
            jenisTugas: meeting['jenis_tugas'],
            deskripsiTugas: meeting['deskripsi_tugas'],
            pengingat: meeting['pengingat'],
          ),
        );
      }
    } else {
      throw Exception('Failed to load meetings');
    }

    return meetings;
  }

  Future<void> addMeeting(Map<String, dynamic> meeting) async {
    String warna = getStringFromColor(meeting['background']);
    await dio.post('http://10.0.2.2:8000/api/tasks', data: {
      'judul_tugas': meeting['eventName'],
      'tanggal_mulai': meeting['from'].toString(),
      'tanggal_selesai': meeting ['to'].toString(),
      'warna': warna,
      'mata_kuliah': meeting ['mataKuliah'],
      'jenis_tugas': meeting ['jenisTugas'],
      'deskripsi_tugas': meeting ['deskripsiTugas'],
      'pengingat': meeting ['pengingat'],
    });
  }


   Future<void> editMeeting(int id, Map<String, dynamic>data) async {
    String warna = getStringFromColor(data['background']);
    await dio.put('http://10.0.2.2:8000/api/tasks/${data['id']}',data: {
      'judul_tugas': data['eventName'],
      'tanggal_mulai': data['from'].toString(),
      'tanggal_selesai': data['to'].toString(),
      'warna': warna,
      'mata_kuliah': data['mataKuliah'],
      'jenis_tugas': data['jenisTugas'],
      'deskripsi_tugas': data['deskripsiTugas'],
      'pengingat': data['pengingat'],
    });
  }
}
