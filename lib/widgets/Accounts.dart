import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Accounts extends StatefulWidget {
  final Function(Set<int> selectedIndices, List<Map<String, dynamic>> accounts)?
      onSelectionChanged;

  const Accounts({super.key, this.onSelectionChanged});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  Set<int> selectedAccounts = {};

  final nameController = TextEditingController();
  final accNoController = TextEditingController();
  final balanceController = TextEditingController();

  final box = Hive.box('Budget');

  List<Map<String, dynamic>> get accounts {
    List<dynamic> stored = box.get('accounts', defaultValue: [
      {'name': 'Cash', 'accNo': '', 'balance': 0.0}
    ]);
    return stored.map((e) => Map<String, dynamic>.from(e)).toList();
  }

  void saveAccounts(List<Map<String, dynamic>> newAccounts) {
    box.put('accounts', newAccounts);
  }

  void toggleAccountSelection(int index) {
    // If this is the only selected account, do nothing
    if (selectedAccounts.length == 1 && selectedAccounts.contains(index)) {
      return;
    }

    setState(() {
      // Select only this one
      selectedAccounts.clear();
      selectedAccounts.add(index);
    });
    widget.onSelectionChanged?.call(selectedAccounts, accounts);
  }

  void selectAllAccounts() {
    setState(() {
      selectedAccounts = Set.from(List.generate(accounts.length, (i) => i));
    });
    widget.onSelectionChanged?.call(selectedAccounts, accounts);
  }

  String? getSelectedAccountName() {
    if (selectedAccounts.length == 1) {
      return accounts[selectedAccounts.first]['name'];
    }
    return null;
  }

  void addAccount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Account",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
              TextField(
                controller: nameController,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  labelStyle: GoogleFonts.poppins(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(52, 119, 216, 1),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenWidth * 0.035,
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              TextField(
                controller: accNoController,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Acc No. (optional)',
                  labelStyle: GoogleFonts.poppins(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(52, 119, 216, 1),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenWidth * 0.035,
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              TextField(
                controller: balanceController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Balance',
                  labelStyle: GoogleFonts.poppins(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(52, 119, 216, 1),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
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
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color:
                                isDark ? Colors.grey[700]! : Colors.grey[300]!,
                          ),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(52, 119, 216, 1),
                            Color.fromRGBO(81, 218, 96, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          if (nameController.text.isNotEmpty) {
                            List<Map<String, dynamic>> currentAccounts =
                                accounts;
                            currentAccounts.add({
                              'name': nameController.text,
                              'accNo': accNoController.text,
                              'balance':
                                  double.tryParse(balanceController.text) ??
                                      0.0,
                            });
                            saveAccounts(currentAccounts);
                            setState(() {});
                          }
                          nameController.clear();
                          accNoController.clear();
                          balanceController.clear();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.035),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Add',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.035,
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
  }

  @override
  void dispose() {
    nameController.dispose();
    accNoController.dispose();
    balanceController.dispose();
    super.dispose();
  }

  void viewAccount(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final account = accounts[index];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    account['name'],
                    style: GoogleFonts.poppins(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      editAccount(context, index);
                    },
                    icon: Icon(
                      Icons.edit_rounded,
                      color: Color.fromRGBO(52, 119, 216, 1),
                      size: screenWidth * 0.055,
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenWidth * 0.04),
              if (account['accNo'] != null &&
                  account['accNo'].toString().isNotEmpty) ...[
                Text(
                  'Account Number',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    color: isDark ? Colors.grey[400] : Colors.grey[500],
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  account['accNo'],
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.038,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
              ],
              Text(
                'Balance',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.03,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
              ),
              SizedBox(height: screenWidth * 0.01),
              Text(
                'P ${(account['balance'] as num).toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.w600,
                  color: Color.fromRGBO(52, 119, 216, 1),
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding:
                        EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                      fontSize: screenWidth * 0.035,
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

  void editAccount(BuildContext context, int index) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final editNameController =
        TextEditingController(text: accounts[index]['name']);
    final editAccNoController =
        TextEditingController(text: accounts[index]['accNo'] ?? '');
    final editBalanceController = TextEditingController(
      text: (accounts[index]['balance'] as num).toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Account",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
              TextField(
                controller: editNameController,
                autofocus: true,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  labelStyle: GoogleFonts.poppins(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(52, 119, 216, 1),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenWidth * 0.035,
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              TextField(
                controller: editAccNoController,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Acc No. (optional)',
                  labelStyle: GoogleFonts.poppins(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(52, 119, 216, 1),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenWidth * 0.035,
                  ),
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              TextField(
                controller: editBalanceController,
                keyboardType: TextInputType.number,
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.035,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: 'Balance',
                  labelStyle: GoogleFonts.poppins(
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.grey[100],
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(52, 119, 216, 1),
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(
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
                      onPressed: () {
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
                              decoration: BoxDecoration(
                                color:
                                    isDark ? Color(0xFF1E1E1E) : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.all(screenWidth * 0.06),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Are you sure?",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                  SizedBox(height: screenWidth * 0.02),
                                  Text(
                                    "This will delete the account permanently.",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.032,
                                      color: isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: screenWidth * 0.05),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () =>
                                              Navigator.of(ctx).pop(),
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: screenWidth * 0.03),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                              fontSize: screenWidth * 0.033,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: screenWidth * 0.03),
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () {
                                            List<Map<String, dynamic>>
                                                currentAccounts = accounts;
                                            currentAccounts.removeAt(index);
                                            saveAccounts(currentAccounts);
                                            setState(() {});
                                            Navigator.of(ctx).pop();
                                            Navigator.of(context).pop();
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: screenWidth * 0.03),
                                            backgroundColor: Colors.red[400],
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Text(
                                            'Delete',
                                            style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: screenWidth * 0.033,
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
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isDark ? Colors.red[700]! : Colors.red[300]!,
                          ),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(
                          color: Colors.red[400],
                          fontWeight: FontWeight.w500,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Color.fromRGBO(52, 119, 216, 1),
                            Color.fromRGBO(81, 218, 96, 1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          List<Map<String, dynamic>> currentAccounts = accounts;
                          currentAccounts[index] = {
                            'name': editNameController.text,
                            'accNo': editAccNoController.text,
                            'balance':
                                double.tryParse(editBalanceController.text) ??
                                    0.0,
                          };
                          saveAccounts(currentAccounts);
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: screenWidth * 0.035),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: screenWidth * 0.035,
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
  }

  void showAccountSelectorModal(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? Color(0xFF1E1E1E) : Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: isDark ? Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(screenWidth * 0.06),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Manage Accounts",
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: screenWidth * 0.04),
              // List of accounts
              ...accounts.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> account = entry.value;
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                    editAccount(context, index);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: screenWidth * 0.035,
                      horizontal: screenWidth * 0.04,
                    ),
                    margin: EdgeInsets.only(bottom: screenWidth * 0.02),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey[800] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              account['name'],
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.038,
                                fontWeight: FontWeight.w500,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              'P ${(account['balance'] as num).toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontSize: screenWidth * 0.032,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: isDark ? Colors.grey[500] : Colors.grey[400],
                          size: screenWidth * 0.06,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: screenWidth * 0.02),
              // Add account button
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  addAccount(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: screenWidth * 0.035,
                    horizontal: screenWidth * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.grey[800]
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? Colors.grey[700]!
                          : Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                        size: screenWidth * 0.05,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        'Add Account',
                        style: GoogleFonts.poppins(
                          fontSize: screenWidth * 0.035,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard(
      Map<String, dynamic> account, int index, double screenWidth) {
    bool isSelected =
        selectedAccounts.isEmpty || selectedAccounts.contains(index);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => toggleAccountSelection(index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenWidth * 0.035,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.grey[800] : Colors.white)
              : (isDark ? Colors.grey[900] : Colors.grey[200]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account['name'],
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: screenWidth * 0.03,
                color: isSelected
                    ? (isDark ? Colors.grey[400] : Colors.grey[600])
                    : Colors.grey[500],
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              'P ${(account['balance'] as num).toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035,
                color: isSelected
                    ? (isDark ? Colors.white : Colors.black)
                    : Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(double screenWidth) {
    return GestureDetector(
      onTap: () => addAccount(context),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenWidth * 0.035,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              size: screenWidth * 0.05,
              color: Colors.grey[600],
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              'Add',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: screenWidth * 0.03,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildRows(double screenWidth) {
    List<Widget> rows = [];
    List<Widget> allItems = [
      ...accounts.asMap().entries.map(
          (entry) => _buildAccountCard(entry.value, entry.key, screenWidth)),
      _buildAddButton(screenWidth),
    ];

    for (int i = 0; i < allItems.length; i += 3) {
      int end = (i + 3 > allItems.length) ? allItems.length : i + 3;
      List<Widget> rowItems = allItems.sublist(i, end);

      List<Widget> rowChildren = [];
      for (int j = 0; j < rowItems.length; j++) {
        rowChildren.add(Expanded(child: rowItems[j]));
        if (j < rowItems.length - 1) {
          rowChildren.add(SizedBox(width: screenWidth * 0.025));
        }
      }

      // Add empty expanded widgets to fill remaining space if less than 3 items
      int remaining = 3 - rowItems.length;
      for (int k = 0; k < remaining; k++) {
        rowChildren.add(SizedBox(width: screenWidth * 0.025));
        rowChildren.add(Expanded(child: SizedBox()));
      }

      rows.add(Row(children: rowChildren));
      if (end < allItems.length) {
        rows.add(SizedBox(height: screenWidth * 0.025));
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder(
      valueListenable: box.listenable(keys: ['accounts']),
      builder: (context, Box box, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: screenWidth * 0.02),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Accounts',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: screenWidth * 0.045,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.02),
                    child: GestureDetector(
                      onTap: () => showAccountSelectorModal(context),
                      child: Icon(
                        Icons.edit_rounded,
                        size: screenWidth * 0.05,
                        color: Color.fromRGBO(52, 119, 216, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth * 0.03),
            ..._buildRows(screenWidth),
            SizedBox(height: screenWidth * 0.06),
            Center(
              child: GestureDetector(
                onTap: selectAllAccounts,
                child: Text(
                  'Select All',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(52, 119, 216, 1),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
