import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:findatherapistapp/models/therapist_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../providers/providers_all.dart';
import '../../../utils/admin/to_capital_case.dart';
import '../../../widgets/AppScaffold/app_scaffold.dart';

class BookAMeetingScreen extends ConsumerStatefulWidget {
  const BookAMeetingScreen({super.key});

  @override
  ConsumerState<BookAMeetingScreen> createState() => _BookAMeetingScreenState();
}

class _BookAMeetingScreenState extends ConsumerState<BookAMeetingScreen> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  List<String> _timeSlots = [
    "12:00 pm",
    "1:30 pm",
    "1:00 pm",
    "1:30 pm",
    "2:00 pm",
    "2:30 pm",
    "3:30 pm",
  ];

  @override
  Widget build(BuildContext context) {
    final Map props = GoRouterState.of(context).extra! as Map;
    TherapistInfo therapistInfo = props['therapistInfo'];
    final _themeProvider = ref.watch(themeProvider);

    return AppScaffold(
      useTopAppBar: true,
      ignoreGlobalPadding: true,
      showScreenTitleInAppBar: true,
      backButton: () {
        context.pop();
      },
      appBarTitle: 'Book a 30\' minute meeting',
      isProtected: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0, vertical: 0.0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${therapistInfo.firstName} ${therapistInfo.lastName}',
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (therapistInfo.userInfoIsVerified)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Image.asset(
                                  'lib/assets/icons/verified-badge.png',
                                  width: 15,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          therapistInfo.specializations
                              .map((specialization) =>
                                  toCapitalCase(specialization))
                              .join(', '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 15,
                              color: _themeProvider.themeMode == ThemeMode.dark
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Row(
                              children: [
                                Text(
                                  '${therapistInfo.location.city}, ${CountryLocalizations.of(context)?.countryName(countryCode: therapistInfo.location.country)}',
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(2),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundImage: CachedNetworkImageProvider(
                            therapistInfo.profilePictureUrl.large,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TableCalendar(
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                firstDay: DateTime.now().toUtc(),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                enabledDayPredicate: (day) {
                  if (day.toUtc() == DateTime.utc(2024, 08, 27)) return false;
                  if (day.toUtc() == DateTime.utc(2024, 08, 28)) return false;
                  return true;
                },
                calendarBuilders: CalendarBuilders(
                  disabledBuilder: (context, day, focusedDay) {
                    return Container(
                        margin: const EdgeInsets.all(4.0),
                        alignment: Alignment.center,
                        child: Text(
                          day.day.toString(),
                          style: const TextStyle(color: Colors.grey),
                        ));
                  },
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                  // selectedDecoration: BoxDecoration(
                  //   color: Colors.orange,
                  //   shape: BoxShape.circle,
                  // ),
                ),
              ),
              const SizedBox(height: 16),

              /// day in "Thursday, Sept. 15" format
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${DateFormat('EEEE, MMM. d').format(_selectedDay.toLocal())}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _timeSlots.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        color: Colors.grey[300],
                        surfaceTintColor: Colors.transparent,
                        // shape: RoundedRectangleBorder(
                        //   borderRadius: BorderRadius.circular(5.0),
                        //   side: const BorderSide(color: Colors.black, width: 0.5),
                        // ),
                        elevation: .4,
                        child: ListTile(
                          title: Center(
                              child: Text(
                            _timeSlots[index],
                            style: TextStyle(fontWeight: FontWeight.w900),
                          )),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Selected ${_timeSlots[index]} on ${_selectedDay.toLocal()}')),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
