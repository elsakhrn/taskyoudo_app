import 'dart:ffi';

import 'package:app_todolist/model/meeting.dart';
import 'package:flutter/cupertino.dart';

class CalendarProvider with ChangeNotifier {
  List<String> _bT = ['bulan', 'tahun'];
  List<String> get bT => _bT;
  void ubahbT(List<String> bTbaru) {
    _bT = bTbaru;
    notifyListeners();
  }


  List<Meeting> _meetingList= [];
  List<Meeting> get meetingList => _meetingList;
  void ubahmeetingList(List<Meeting> meetingListBaru){
    _meetingList = meetingListBaru;
    notifyListeners();
  }
  void tambahMeeting(Meeting meetingBaru){
    _meetingList.add(meetingBaru);
    notifyListeners();
  }
}
