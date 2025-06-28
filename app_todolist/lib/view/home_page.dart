import 'package:app_todolist/controller/meeting_controller.dart';
import 'package:app_todolist/controller/meeting_data_source.dart';
import 'package:app_todolist/model/meeting.dart';
import 'package:app_todolist/providers/calendar_provider.dart';
import 'package:app_todolist/view/add_task.dart';
import 'package:app_todolist/view/edit_task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    CalendarController calendarController = CalendarController();
    return FutureBuilder(
      future: MeetingController().getAll(),
      builder: (context, snapshot) {
        List<Meeting> meetingList = [];
        if (snapshot.hasData) {
          meetingList = snapshot.data!;
          Future.delayed(Duration(seconds: 1), () {
            if (!context.mounted) return;
            context.read<CalendarProvider>().ubahmeetingList(meetingList);
          });
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Apps ToDo', style: TextStyle(color: Colors.white)),
            backgroundColor: Colors.blue,
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddTask()),
                  );
                },
                icon: Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 25,
                  horizontal: 15,
                ),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: context.watch<CalendarProvider>().bT[0],
                        style: TextStyle(
                          fontFamily: 'ArchivoBlack',
                          color: Colors.blue,
                          fontSize: 40,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextSpan(
                        text: '\n${context.watch<CalendarProvider>().bT[1]}',
                        style: TextStyle(
                          fontFamily: 'ArchivoBlack',
                          color: Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SfCalendar(
                  view: CalendarView.month,
                  headerHeight: 0,
                  onViewChanged: (_) {
                    String tahun = DateFormat(
                      'yyyy', 'id_ID',
                    ).format(calendarController.displayDate!);
                    String bulan = DateFormat(
                      'MMMM', 'id_ID',
                    ).format(calendarController.displayDate!);
                    Future.delayed(Duration(seconds: 1), () {
                      if (!context.mounted) return;
                      context.read<CalendarProvider>().ubahbT([bulan, tahun]);
                    });
                  },
                  controller: calendarController,
                  monthViewSettings: MonthViewSettings(showAgenda: true),
                  dataSource: MeetingDataSource(
                    context.watch<CalendarProvider>().meetingList,
                  ),
                  onTap: (calendarTapDetails) {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      useSafeArea: true,
                      context: context,
                      builder:
                          (context) => GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            behavior: HitTestBehavior.opaque,
                            child: DraggableScrollableSheet(
                              builder:
                                  (context, scrollController) =>
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            Text(DateFormat(
                                              'EEEE, dd MMMM yyyy', 'id_ID',
                                            ).format(calendarTapDetails.date!),),
                                            Expanded(
                                              child: ListView.builder(
                                                controller: scrollController,
                                                itemCount: calendarTapDetails.appointments?.length ?? 0,
                                                itemBuilder: (context, index)=>Card(
                                                child: 
                                                ListTile(
                                                  onTap:(){
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => EditTask(
                                                          meeting: calendarTapDetails.appointments?[index],
                                                        ),
                                                      ),
                                                    );
                                                  } ,
                                                  title: Text(calendarTapDetails.appointments?[index].eventName),
                                                  subtitle: Text(calendarTapDetails.appointments?[index].deskripsiTugas),
                                                ),
                                              )),
                                            ),
                                          ],
                                        ),
                                      )
                            ),
                          ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
