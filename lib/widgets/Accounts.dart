import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Accounts extends StatefulWidget {
  const Accounts({super.key});

  @override
  State<Accounts> createState() => _AccountsState();
}

class _AccountsState extends State<Accounts> {
  List<Map<String, dynamic>> accounts = [
    {'name': 'Cash', 'accNo': '', 'balance': 5000.0},
    {'name': 'GCash', 'accNo': '0917-XXX-XXXX', 'balance': 2500.0},
  ];

  final nameController = TextEditingController();
  final accNoController = TextEditingController();
  final balanceController = TextEditingController();

  void addAccount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
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
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
              TextField(
                controller: nameController,
                autofocus: true,
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
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
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                decoration: InputDecoration(
                  labelText: 'Acc No. (optional)',
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
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
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                decoration: InputDecoration(
                  labelText: 'Balance',
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
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
                        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
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
                          setState(() {
                            accounts.add({
                              'name': nameController.text,
                              'accNo': accNoController.text,
                              'balance': double.tryParse(balanceController.text) ?? 0.0,
                            });
                          });
                          nameController.clear();
                          accNoController.clear();
                          balanceController.clear();
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
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
    final account = accounts[index];

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
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
              if (account['accNo'] != null && account['accNo'].toString().isNotEmpty) ...[
                Text(
                  'Account Number',
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.03,
                    color: Colors.grey[500],
                  ),
                ),
                SizedBox(height: screenWidth * 0.01),
                Text(
                  account['accNo'],
                  style: GoogleFonts.poppins(
                    fontSize: screenWidth * 0.038,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: screenWidth * 0.04),
              ],
              Text(
                'Balance',
                style: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.03,
                  color: Colors.grey[500],
                ),
              ),
              SizedBox(height: screenWidth * 0.01),
              Text(
                'P ${account['balance'].toStringAsFixed(2)}',
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
                    padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[600],
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
    final editNameController = TextEditingController(text: accounts[index]['name']);
    final editAccNoController = TextEditingController(text: accounts[index]['accNo'] ?? '');
    final editBalanceController = TextEditingController(
      text: accounts[index]['balance'].toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
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
                ),
              ),
              SizedBox(height: screenWidth * 0.05),
              TextField(
                controller: editNameController,
                autofocus: true,
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                decoration: InputDecoration(
                  labelText: 'Account Name',
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
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
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                decoration: InputDecoration(
                  labelText: 'Acc No. (optional)',
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
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
                style: GoogleFonts.poppins(fontSize: screenWidth * 0.035),
                decoration: InputDecoration(
                  labelText: 'Balance',
                  labelStyle: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: screenWidth * 0.035,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(screenWidth * 0.06),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Are you sure?",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.045,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: screenWidth * 0.02),
                                  Text(
                                    "This will delete the account permanently.",
                                    style: GoogleFonts.poppins(
                                      fontSize: screenWidth * 0.032,
                                      color: Colors.grey[600],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: screenWidth * 0.05),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton(
                                          onPressed: () => Navigator.of(ctx).pop(),
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                              side: BorderSide(color: Colors.grey[300]!),
                                            ),
                                          ),
                                          child: Text(
                                            'Cancel',
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey[600],
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
                                            setState(() {
                                              accounts.removeAt(index);
                                            });
                                            Navigator.of(ctx).pop();
                                            Navigator.of(context).pop();
                                          },
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
                                            backgroundColor: Colors.red[400],
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
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
                        padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.red[300]!),
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
                          setState(() {
                            accounts[index] = {
                              'name': editNameController.text,
                              'accNo': editAccNoController.text,
                              'balance': double.tryParse(editBalanceController.text) ?? 0.0,
                            };
                          });
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.035),
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

  Widget _buildAccountCard(Map<String, dynamic> account, int index, double screenWidth) {
    return GestureDetector(
      onTap: () => viewAccount(context, index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.03,
          vertical: screenWidth * 0.035,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              account['name'],
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: screenWidth * 0.03,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: screenWidth * 0.01),
            Text(
              'P ${account['balance'].toStringAsFixed(0)}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.035,
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
      ...accounts.asMap().entries.map((entry) => _buildAccountCard(entry.value, entry.key, screenWidth)),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: screenWidth * 0.02),
          child: Text(
            'Accounts',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: screenWidth * 0.045,
            ),
          ),
        ),
        SizedBox(height: screenWidth * 0.03),
        ..._buildRows(screenWidth),
      ],
    );
  }
}
