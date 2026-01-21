import 'package:badyet/main.dart';
import 'package:badyet/ExpenseItemClass.dart';
import 'package:badyet/ExpensesTodayBox.dart';
import 'package:badyet/ExpenseTodayHistoryBox.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();

  static const Set<String> defaultLuxuryCategories = {
    'Luxury - Shopping',
    'Luxury - Social',
  };

  // Static helper method to check if a category is luxury (can be used from anywhere)
  static bool isLuxuryCategory(String category) {
    final box = Hive.box('Budget');
    List<dynamic> stored = box.get('luxuryCategories',
        defaultValue: defaultLuxuryCategories.toList());
    Set<String> luxuryCats = stored.cast<String>().toSet();
    return luxuryCats.contains(category);
  }
}

class _SettingsPageState extends State<SettingsPage> {
  late bool isDarkModeEnabled;
  final box = Hive.box('Budget');
  final categoryController = TextEditingController();

  static const List<String> defaultCategories = [
    'Income',
    'Food & Drinks',
    'Bills & Subscription',
    'Vehicle',
    'Luxury - Shopping',
    'Luxury - Social',
    'Others'
  ];

  List<String> get categories {
    List<dynamic> stored =
        box.get('categories', defaultValue: defaultCategories);
    return stored.cast<String>();
  }

  void saveCategories(List<String> cats) {
    box.put('categories', cats);
  }

  Set<String> get luxuryCategories {
    List<dynamic> stored = box.get('luxuryCategories',
        defaultValue: SettingsPage.defaultLuxuryCategories.toList());
    return stored.cast<String>().toSet();
  }

  void saveLuxuryCategories(Set<String> luxuryCats) {
    box.put('luxuryCategories', luxuryCats.toList());
  }

  bool isLuxuryCategory(String category) {
    return luxuryCategories.contains(category);
  }

  // Instance method that uses the static helper
  bool checkIsLuxuryCategory(String category) {
    return SettingsPage.isLuxuryCategory(category);
  }

  void toggleLuxuryCategory(String category, bool isLuxury) {
    Set<String> updated = Set.from(luxuryCategories);
    if (isLuxury) {
      updated.add(category);
    } else {
      updated.remove(category);
    }
    saveLuxuryCategories(updated);
  }

  void renameCategory(String oldCategory, String newCategory) {
    // Update category list
    List<String> updated =
        categories.map((c) => c == oldCategory ? newCategory : c).toList();
    saveCategories(updated);

    // Update luxury categories if the old category was luxury
    if (isLuxuryCategory(oldCategory)) {
      Set<String> updatedLuxury = Set.from(luxuryCategories);
      updatedLuxury.remove(oldCategory);
      updatedLuxury.add(newCategory);
      saveLuxuryCategories(updatedLuxury);
    }

    // Update all expenses in expenseTodayBox
    for (var key in expenseTodayBox.keys) {
      ExpenseItemClass? item = expenseTodayBox.get(key);
      if (item != null && item.category == oldCategory) {
        ExpenseItemClass updatedItem = ExpenseItemClass(
          item.date,
          newCategory,
          item.type,
          item.price,
          item.account,
        );
        expenseTodayBox.put(key, updatedItem);
      }
    }

    // Update all expenses in expenseTodayHistoryBox
    for (var key in expenseTodayHistoryBox.keys) {
      ExpenseItemClass? item = expenseTodayHistoryBox.get(key);
      if (item != null && item.category == oldCategory) {
        ExpenseItemClass updatedItem = ExpenseItemClass(
          item.date,
          newCategory,
          item.type,
          item.price,
          item.account,
        );
        expenseTodayHistoryBox.put(key, updatedItem);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    isDarkModeEnabled =
        Hive.box('Budget').get('isDarkMode', defaultValue: false);
  }

  @override
  void dispose() {
    categoryController.dispose();
    super.dispose();
  }

  void showSetLuxuryCategoriesModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
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
                'Set Luxury Categories',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Divider(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                height: 1,
              ),
              // Categories list with checkmarks
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    bool isLuxury = isLuxuryCategory(category);
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenWidth * 0.035,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              toggleLuxuryCategory(category, !isLuxury);
                              setModalState(() {});
                              setState(() {});
                            },
                            child: Icon(
                              isLuxury
                                  ? Icons.check_circle
                                  : Icons.check_circle_outline,
                              color: isLuxury
                                  ? Color.fromRGBO(52, 119, 216, 1)
                                  : (isDark
                                      ? Colors.grey[600]
                                      : Colors.grey[400]),
                              size: screenWidth * 0.055,
                            ),
                          ),
                        ],
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

  void showEditCategoriesModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
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
                'Edit Categories',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              // Add new category
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: categoryController,
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'New category name',
                          hintStyle: GoogleFonts.poppins(
                            color: isDark ? Colors.grey[500] : Colors.grey[400],
                            fontSize: screenWidth * 0.035,
                          ),
                          filled: true,
                          fillColor:
                              isDark ? Colors.grey[800] : Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.04,
                            vertical: screenWidth * 0.03,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    GestureDetector(
                      onTap: () {
                        String newCategory = categoryController.text.trim();
                        if (newCategory.isNotEmpty &&
                            !categories.contains(newCategory)) {
                          List<String> updated = [...categories, newCategory];
                          saveCategories(updated);
                          categoryController.clear();
                          setModalState(() {});
                          setState(() {});
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(screenWidth * 0.03),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(52, 119, 216, 1),
                              Color.fromRGBO(81, 218, 96, 1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: screenWidth * 0.06,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              Divider(
                color: isDark ? Colors.grey[700] : Colors.grey[300],
                height: 1,
              ),
              // Categories list
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.06,
                        vertical: screenWidth * 0.035,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              category,
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.04,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Show rename dialog
                              final renameController =
                                  TextEditingController(text: category);
                              showDialog(
                                context: context,
                                builder: (ctx) => Dialog(
                                  backgroundColor:
                                      isDark ? Color(0xFF1E1E1E) : Colors.white,
                                  surfaceTintColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(screenWidth * 0.06),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Rename Category',
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.045,
                                            fontWeight: FontWeight.w600,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ),
                                        SizedBox(height: screenWidth * 0.04),
                                        TextField(
                                          controller: renameController,
                                          autofocus: true,
                                          style: GoogleFonts.poppins(
                                            fontSize: screenWidth * 0.035,
                                            color: isDark
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                          decoration: InputDecoration(
                                            labelText: 'Category Name',
                                            labelStyle: GoogleFonts.poppins(
                                              color: isDark
                                                  ? Colors.grey[400]
                                                  : Colors.grey[600],
                                              fontSize: screenWidth * 0.035,
                                            ),
                                            filled: true,
                                            fillColor: isDark
                                                ? Colors.grey[800]
                                                : Colors.grey[100],
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: BorderSide(
                                                color: isDark
                                                    ? Colors.grey[700]!
                                                    : Colors.grey[300]!,
                                              ),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                color: Color.fromRGBO(
                                                    52, 119, 216, 1),
                                              ),
                                            ),
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.04,
                                              vertical: screenWidth * 0.035,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: screenWidth * 0.06),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx),
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical:
                                                          screenWidth * 0.035),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                    side: BorderSide(
                                                      color: isDark
                                                          ? Colors.grey[700]!
                                                          : Colors.grey[300]!,
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'Cancel',
                                                  style: GoogleFonts.poppins(
                                                    color: isDark
                                                        ? Colors.grey[400]
                                                        : Colors.grey[600],
                                                    fontWeight: FontWeight.w500,
                                                    fontSize:
                                                        screenWidth * 0.035,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: screenWidth * 0.03),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    begin: Alignment.centerLeft,
                                                    end: Alignment.centerRight,
                                                    colors: [
                                                      Color.fromRGBO(
                                                          52, 119, 216, 1),
                                                      Color.fromRGBO(
                                                          81, 218, 96, 1),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    String newName =
                                                        renameController.text
                                                            .trim();
                                                    if (newName.isNotEmpty &&
                                                        newName != category &&
                                                        !categories.contains(
                                                            newName)) {
                                                      renameCategory(
                                                          category, newName);
                                                      Navigator.pop(ctx);
                                                      setModalState(() {});
                                                      setState(() {});
                                                    }
                                                  },
                                                  style: TextButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical:
                                                                screenWidth *
                                                                    0.035),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Rename',
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize:
                                                          screenWidth * 0.035,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.edit_rounded,
                              color: Color.fromRGBO(52, 119, 216, 1),
                              size: screenWidth * 0.055,
                            ),
                          ),
                          SizedBox(width: screenWidth * 0.05),
                          GestureDetector(
                            onTap: () {
                              // Confirm delete
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor:
                                      isDark ? Color(0xFF1E1E1E) : Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  title: Text(
                                    'Delete Category',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  content: Text(
                                    'Are you sure you want to delete "$category"?',
                                    style: GoogleFonts.poppins(
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx),
                                      child: Text(
                                        'Cancel',
                                        style: GoogleFonts.poppins(
                                          color: isDark
                                              ? Colors.grey[400]
                                              : Colors.grey[600],
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        bool wasLuxury =
                                            isLuxuryCategory(category);
                                        List<String> updated = categories
                                            .where((c) => c != category)
                                            .toList();
                                        saveCategories(updated);
                                        // Also remove from luxury categories if it was luxury
                                        if (wasLuxury) {
                                          Set<String> updatedLuxury =
                                              Set.from(luxuryCategories);
                                          updatedLuxury.remove(category);
                                          saveLuxuryCategories(updatedLuxury);
                                        }
                                        Navigator.pop(ctx);
                                        setModalState(() {});
                                        setState(() {});
                                      },
                                      child: Text(
                                        'Delete',
                                        style: GoogleFonts.poppins(
                                          color: Colors.red[400],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(
                              Icons.delete_outline_rounded,
                              color: Colors.red[400],
                              size: screenWidth * 0.055,
                            ),
                          ),
                        ],
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

  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          left: screenWidth * 0.07,
          right: screenWidth * 0.07,
          top: 55,
        ),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Settings",
                  style: GoogleFonts.poppins(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none),
                ),
              ],
            ),
            SizedBox(height: screenWidth * 0.18),
            Center(
              child: Container(
                height: screenWidth * 0.25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/badyet.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: screenWidth * 0.05),
            Center(
              child: Text(
                "Version 3.0.0",
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.05),
              ),
            ),
            SizedBox(height: screenWidth * 0.15),
            Expanded(
              child: ListView(
                children: [
                  buildSettingItem(
                    icon: Icons.brightness_4,
                    name: 'Dark Mode',
                    isDark: isDark,
                    button: Switch(
                      value: isDarkModeEnabled,
                      activeColor: Color.fromRGBO(52, 119, 216, 1),
                      onChanged: (value) {
                        setState(() {
                          isDarkModeEnabled = value;
                        });
                        MyApp.of(context)?.toggleDarkMode(value);
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.category_rounded,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    title: Text(
                      'Edit Categories',
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    onTap: () => showEditCategoriesModal(context),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.star_rounded,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                    title: Text(
                      'Set Luxury Categories',
                      style: TextStyle(
                          color: isDark ? Colors.white : Colors.black),
                    ),
                    trailing: Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                    onTap: () => showSetLuxuryCategoriesModal(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildSettingItem(
    {required IconData icon,
    required String name,
    required Widget button,
    required bool isDark}) {
  return ListTile(
    leading: Icon(icon, color: isDark ? Colors.white70 : Colors.black87),
    title: Text(
      name,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
    ),
    trailing: button,
  );
}
