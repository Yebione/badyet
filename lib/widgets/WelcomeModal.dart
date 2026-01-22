import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeModal {
  static void showWelcomeModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Welcome to Badyet!',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenWidth * 0.04),
                    _buildSection(
                      context,
                      screenWidth,
                      isDark,
                      Icons.account_balance_wallet_rounded,
                      'Set Your Budgets',
                      'Start by setting your Month Budget. This is your total spending limit for the entire month.',
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    _buildSection(
                      context,
                      screenWidth,
                      isDark,
                      Icons.star_rounded,
                      'Luxury Budget',
                      'The Luxury Budget is separate from your Month Budget. It\'s your exclusive allowance for "the good stuff" - things you want to treat yourself with this month. This budget resets at the end of each month, not daily.',
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    _buildSection(
                      context,
                      screenWidth,
                      isDark,
                      Icons.category_rounded,
                      'Categories & Luxury Categories',
                      'Organize your expenses with custom categories. Mark certain categories as "Luxury" in Settings, and expenses in those categories will deduct from your Luxury Budget instead of your regular Month Budget.',
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    _buildSection(
                      context,
                      screenWidth,
                      isDark,
                      Icons.calculate_rounded,
                      'Daily Budget',
                      'Your Daily Budget is automatically calculated based on your remaining Month Budget divided by the days left in the month. It updates dynamically as you spend.',
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    _buildSection(
                      context,
                      screenWidth,
                      isDark,
                      Icons.swap_horiz_rounded,
                      'Transfers',
                      'Track money transfers between your accounts. Transfers don\'t affect your budgets - they just move money from one account to another.',
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    _buildSection(
                      context,
                      screenWidth,
                      isDark,
                      Icons.calendar_month_rounded,
                      'View Past Entries',
                      'Tap the calendar icon next to the date to view or add entries for past days. This helps you track your spending history and add missed transactions.',
                    ),
                    SizedBox(height: screenWidth * 0.04),
                    _buildSection(
                      context,
                      screenWidth,
                      isDark,
                      Icons.edit_rounded,
                      'Edit Transactions',
                      'Tap any expense in your home page or analytics to edit its description, amount, category, or account.',
                    ),
                    SizedBox(height: screenWidth * 0.06),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(52, 119, 216, 1),
                      Color.fromRGBO(81, 218, 96, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Got it!',
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildSection(
    BuildContext context,
    double screenWidth,
    bool isDark,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(screenWidth * 0.025),
          decoration: BoxDecoration(
            color: Color.fromRGBO(52, 119, 216, 1).withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Color.fromRGBO(52, 119, 216, 1),
            size: screenWidth * 0.06,
          ),
        ),
        SizedBox(width: screenWidth * 0.04),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: screenWidth * 0.015),
              Text(
                description,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
