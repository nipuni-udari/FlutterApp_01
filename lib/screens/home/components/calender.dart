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
        if (data['remarks'] != null) {
          setState(() {
            _appointments = data['remarks'].map<Appointment>((remark) {
              return Appointment(
                startTime: DateTime.parse(remark['action_date']),
                endTime: DateTime.parse(remark['action_date'])
                    .add(const Duration(hours: 1)),
                subject:
                    "🏢 ${remark['customer_company_name']}\n📝 ${remark['remarks']}",
                color: const Color(0xFF674AEF),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SectionTitle(
            title: "Remarks Calendar",
            press: () {},
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF674AEF).withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white,
                        Color(0xFFF9F6FF),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _isLoading
                      ? Center(
                          child: SpinKitFadingCircle(
                            color: const Color(0xFF674AEF),
                            size: 40.0,
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
                            agendaItemHeight: 70,
                            agendaStyle: AgendaStyle(
                              backgroundColor: Colors.transparent,
                              appointmentTextStyle: TextStyle(
                                color: Color(0xFF2D2D2D),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          headerStyle: const CalendarHeaderStyle(
                            textAlign: TextAlign.center,
                            backgroundColor: Color(0xFF674AEF),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 0.8,
                            ),
                          ),
                          selectionDecoration: BoxDecoration(
                            color: const Color(0xFF674AEF).withOpacity(0.1),
                            border: Border.all(
                              color: const Color(0xFF674AEF),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          todayHighlightColor: const Color(0xFF674AEF),
                          showNavigationArrow: true,
                          monthCellBuilder: (context, details) {
                            bool hasEvent = details.appointments.isNotEmpty;
                            final today = DateTime.now();
                            final cellDate = details.date;
                            final isToday = cellDate.year == today.year &&
                                cellDate.month == today.month &&
                                cellDate.day == today.day;

                            return Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: hasEvent
                                    ? const Color(0xFF674AEF).withOpacity(0.15)
                                    : details.date.weekday == DateTime.sunday
                                        ? const Color(0xFFFFF0F0)
                                        : Colors.transparent,
                                border: Border.all(
                                  color: hasEvent
                                      ? const Color(0xFF674AEF).withOpacity(0.3)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  details.date.day.toString(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: isToday
                                        ? Colors.white
                                        : hasEvent
                                            ? const Color(0xFF674AEF)
                                            : const Color(0xFF5A5A5A),
                                  ),
                                ),
                              ),
                            );
                          },
                          appointmentBuilder:
                              (context, calendarAppointmentDetails) {
                            final appointment =
                                calendarAppointmentDetails.appointments.first;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF674AEF)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.event_available,
                                    color: Color(0xFF674AEF),
                                    size: 20,
                                  ),
                                ),
                                title: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: appointment.subject
                                            .split('\n')
                                            .first,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF2D2D2D),
                                          fontSize: 14,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '\n${appointment.subject.split('\n').last}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xFF6B6B6B),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
