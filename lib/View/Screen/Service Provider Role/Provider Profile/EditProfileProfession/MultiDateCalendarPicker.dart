import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../../Utils/AppColors/app_colors.dart';
import 'EditProfileProfessionController.dart';

class UnavailableDateField extends StatelessWidget {
  final Editprofileprofessioncontroller c;

  const UnavailableDateField({super.key, required this.c});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// TEXT FIELD LOOK
          GestureDetector(
            onTap: c.toggleCalendar,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.red601),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      c.unavailableDatesText, // ✅ RxString
                      style: const TextStyle(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.calendar_month, color: Colors.red),
                ],
              ),
            ),
          ),

          /// CALENDAR
          if (c.isCalendarOpen.value) // ✅ RxBool
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TableCalendar(
                  focusedDay: DateTime.now(),
                  firstDay: DateTime.now(),
                  lastDay: DateTime(2035),

                  selectedDayPredicate: (day) =>
                      c.isSelected(day), // bool function

                  onDaySelected: (selectedDay, focusedDay) {
                    c.toggleDate(selectedDay);
                  },

                  calendarStyle: CalendarStyle(
                    selectedDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                  ),

                  headerStyle: const HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
