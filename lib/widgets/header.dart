import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

var dayOfTheWeek = [
  "",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday"
];

class Header extends StatefulWidget {
  final DateTime? selectedDate;
  final Function(DateTime) onDateChanged;

  const Header({super.key, this.selectedDate, required this.onDateChanged});

  @override
  State<Header> createState() => _HeaderState();
}

var months = [
  "",
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];

class _HeaderState extends State<Header> {
  void _selectDate(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    DateTime now = DateTime.now();
    DateTime selectedDate = widget.selectedDate ?? now;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.6,
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              SizedBox(height: screenWidth * 0.03),
              Container(
                width: screenWidth * 0.1,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey[700] : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Text(
                'Select Date',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Expanded(
                  child: Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: Color.fromRGBO(52, 119, 216, 1),
                      onPrimary: Colors.white,
                      surface: isDark ? Color(0xFF1E1E1E) : Colors.white,
                      onSurface: isDark ? Colors.white : Colors.black87,
                      onSurfaceVariant: isDark ? Colors.grey[600] : Colors.grey[400],
                    ),
                    disabledColor: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  child: CalendarDatePicker(
                    initialDate: selectedDate.isAfter(now) ? now : selectedDate,
                    firstDate: DateTime(now.year - 1, 1, 1),
                    lastDate: now,
                    onDateChanged: (date) {
                      // Prevent selecting future dates
                      if (date.isAfter(now)) {
                        return;
                      }
                      setModalState(() {
                        selectedDate = date;
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.06),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[800] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          widget.onDateChanged(selectedDate);
                          Navigator.pop(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(52, 119, 216, 1),
                                Color.fromRGBO(81, 218, 96, 1)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              'Select',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    DateTime displayDate = widget.selectedDate ?? DateTime.now();
    DateTime now = DateTime.now();
    bool isToday = displayDate.year == now.year && 
                   displayDate.month == now.month && 
                   displayDate.day == now.day;
    
    int day = displayDate.weekday;
    String dayName = dayOfTheWeek[day];
    String displayText = isToday ? 'Today is $dayName' : 'Viewing $dayName';

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                height: screenWidth / 10,
                width: screenWidth / 10,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset('assets/images/avatar.png'),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    displayText,
                    style: GoogleFonts.poppins(
                      color: isDark ? Color(0xFF81C784) : Color.fromRGBO(34, 139, 34, 1),
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "${months[displayDate.month]} ${displayDate.day}, ${displayDate.year}",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.normal,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () => _selectDate(context),
            icon: Icon(
              Icons.calendar_today_rounded,
              color: isDark ? Colors.white70 : Colors.black87,
              size: screenWidth * 0.06,
            ),
          ),
        ],
      ),
    );
  }
}
