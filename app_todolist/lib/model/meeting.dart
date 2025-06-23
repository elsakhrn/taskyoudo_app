import 'dart:ui';

class Meeting {
  int id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  String mataKuliah;
  String jenisTugas;
  String deskripsiTugas;
  int pengingat;

  Meeting({
    required this.id,
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.mataKuliah,
    required this.jenisTugas,
    required this.deskripsiTugas,
    required this.pengingat,
  });
}
