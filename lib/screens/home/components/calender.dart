import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:newapp/user_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'section_title.dart';

class CalendarWidget extends StatefulWidget {
  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  CalendarController? _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
    _calendarController?.selectedDate = DateTime.now();
    _fetchRemarks();
  }

  Future<void> _fetchRemarks() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userHris = userProvider.userHris;

      final response = await http.post(
        Uri.parse(
            'https://demo.secretary.lk/electronics_mobile_app/backend/calendar_data.php'),
        body: {'userHris': userHris},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        if (data['remarks'] != null) {
          setState(() {
            _appointments = data['remarks'].map<Appointment>((remark) {
              return Appointment(
                startTime: DateTime.parse(remark['action_date']),
                endTime: DateTime.parse(remark['action_date'])
                    .add(Duration(hours: 1)),
                subject:
                    "🏢 ${remark['customer_company_name']}\n📝 ${remark['remarks']}",
                color: const Color.fromARGB(255, 174, 115, 247),
                isAllDay: true,
              );
            }).toList();
          });
        }
      } else {
        throw Exception('Failed to load remarks');
      }
    } catch (error) {
      print('Error fetching remarks: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardWidth = MediaQuery.of(context).size.width * 0.9;
    double cardHeight = MediaQuery.of(context).size.height * 0.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          child: SectionTitle(
            title: "Remarks Calendar",
            press: () {},
          ),
        ),
        Center(
          child: SizedBox(
            width: cardWidth,
            height: cardHeight,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 18,
              shadowColor:
                  const Color.fromARGB(184, 125, 251, 228).withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _isLoading
                    ? Center(
                        child: SpinKitThreeBounce(
                          color: Color(0xFF674AEF),
                          size: 50.0,
                        ),
                      )
                    : SfCalendar(
                        view: CalendarView.month,
                        controller: _calendarController,
                        dataSource: AppointmentDataSource(_appointments),
                        monthViewSettings: const MonthViewSettings(
                          appointmentDisplayMode:
                              MonthAppointmentDisplayMode.indicator,
                          showAgenda: true,
                          agendaItemHeight: 50,
                        ),
                        headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          backgroundColor: const Color(0xFF674AEF),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        showNavigationArrow: true,
                        onTap: (details) {
                          if (details.targetElement ==
                              CalendarElement.header) {}
                        },
                        monthCellBuilder: (context, details) {
                          bool hasEvent = details.appointments.isNotEmpty;
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: hasEvent
                                    ? const Color.fromARGB(255, 174, 115, 247)
                                    : const Color.fromARGB(32, 166, 6, 206),
                              ),
                              color: hasEvent
                                  ? const Color.fromARGB(176, 33, 243, 93)
                                      .withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              details.date.day.toString(),
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AppointmentDataSource extends CalendarDataSource {
  AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
}
