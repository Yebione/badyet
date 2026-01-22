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
          height: MediaQuery.of(context).size.height * 0.65,
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
              Expanded(
                child: _CustomCalendar(
                  selectedDate: selectedDate.isAfter(now) ? now : selectedDate,
                  firstDate: DateTime(now.year - 1, 1, 1),
                  lastDate: now,
                  onDateChanged: (date) {
                    if (date.isAfter(now)) {
                      return;
                    }
                    setModalState(() {
                      selectedDate = date;
                    });
                  },
                  isDark: isDark,
                  screenWidth: screenWidth,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.06),
                child: GestureDetector(
                  onTap: () {
                    widget.onDateChanged(selectedDate);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
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

class _CustomCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime) onDateChanged;
  final bool isDark;
  final double screenWidth;

  const _CustomCalendar({
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    required this.isDark,
    required this.screenWidth,
  });

  @override
  State<_CustomCalendar> createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<_CustomCalendar> {
  late DateTime _displayedMonth;
  final List<String> _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(widget.selectedDate.year, widget.selectedDate.month, 1);
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = _displayedMonth;
    final lastDay = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0);
    final firstDayOfWeek = firstDay.weekday; // 1 = Monday, 7 = Sunday
    
    List<DateTime> days = [];
    
    // Add padding days from previous month
    int paddingDays = firstDayOfWeek - 1; // Convert to 0-based (Monday = 0)
    if (paddingDays > 0) {
      final prevMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 0);
      for (int i = prevMonth.day - paddingDays + 1; i <= prevMonth.day; i++) {
        days.add(DateTime(prevMonth.year, prevMonth.month, i));
      }
    }
    
    // Add days of current month
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(_displayedMonth.year, _displayedMonth.month, i));
    }
    
    // Add padding days from next month to complete the grid (5 rows = 35 days)
    int remainingDays = 35 - days.length; // 5 rows * 7 days = 35
    if (remainingDays > 0) {
      for (int i = 1; i <= remainingDays; i++) {
        days.add(DateTime(_displayedMonth.year, _displayedMonth.month + 1, i));
      }
    }
    
    return days;
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return _isSameDay(date, now);
  }

  bool _isSelected(DateTime date) {
    return _isSameDay(date, widget.selectedDate);
  }

  bool _isCurrentMonth(DateTime date) {
    return date.month == _displayedMonth.month && date.year == _displayedMonth.year;
  }

  void _previousMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth();
    final now = DateTime.now();

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.screenWidth * 0.04,
        vertical: widget.screenWidth * 0.01,
      ),
      child: Column(
        children: [
          // Month/Year header with navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: _previousMonth,
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: Color.fromRGBO(52, 119, 216, 1),
                  size: widget.screenWidth * 0.06,
                ),
              ),
              Text(
                '${months[_displayedMonth.month]} ${_displayedMonth.year}',
                style: GoogleFonts.poppins(
                  fontSize: widget.screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: widget.isDark ? Colors.white : Colors.black87,
                ),
              ),
              IconButton(
                onPressed: _displayedMonth.year == now.year && 
                          _displayedMonth.month == now.month
                    ? null
                    : _nextMonth,
                icon: Icon(
                  Icons.chevron_right_rounded,
                  color: (_displayedMonth.year == now.year && 
                          _displayedMonth.month == now.month)
                      ? Colors.grey
                      : Color.fromRGBO(52, 119, 216, 1),
                  size: widget.screenWidth * 0.06,
                ),
              ),
            ],
          ),
          SizedBox(height: widget.screenWidth * 0.03),
          // Weekday headers
          Row(
            children: _weekdays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: GoogleFonts.poppins(
                      fontSize: widget.screenWidth * 0.032,
                      fontWeight: FontWeight.w500,
                      color: widget.isDark ? Colors.grey[500] : Colors.grey[600],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: widget.screenWidth * 0.015),
          // Calendar grid - using Column with Rows for better control
          Expanded(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  for (int week = 0; week < 5; week++)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: widget.screenWidth * 0.01,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (int dayIndex = 0; dayIndex < 7; dayIndex++)
                            Builder(
                              builder: (context) {
                                final index = week * 7 + dayIndex;
                                if (index >= days.length) {
                                  return SizedBox(width: widget.screenWidth * 0.1);
                                }
                                final date = days[index];
                                final isCurrentMonth = _isCurrentMonth(date);
                                final isToday = _isToday(date);
                                final isSelected = _isSelected(date);
                                final isDisabled = date.isAfter(widget.lastDate);

                                return GestureDetector(
                                  onTap: isDisabled ? null : () => widget.onDateChanged(date),
                                  child: Container(
                                    width: widget.screenWidth * 0.1,
                                    height: widget.screenWidth * 0.1,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Color.fromRGBO(52, 119, 216, 1)
                                          : isToday && !isSelected
                                              ? Color.fromRGBO(52, 119, 216, 1).withOpacity(0.15)
                                              : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${date.day}',
                                        style: GoogleFonts.poppins(
                                          fontSize: widget.screenWidth * 0.035,
                                          fontWeight: isSelected || isToday
                                              ? FontWeight.w600
                                              : FontWeight.w400,
                                          color: isDisabled
                                              ? (widget.isDark ? Colors.grey[800] : Colors.grey[300])
                                              : isSelected
                                                  ? Colors.white
                                                  : isToday
                                                      ? Color.fromRGBO(52, 119, 216, 1)
                                                      : isCurrentMonth
                                                          ? (widget.isDark ? Colors.white : Colors.black87)
                                                          : (widget.isDark ? Colors.grey[700] : Colors.grey[400]),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
