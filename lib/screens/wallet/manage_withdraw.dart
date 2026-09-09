import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ifresh_delivery/constant/validations.dart';

import '../../Colors/colors.dart';
import '../../constant/strings.dart';
import '../../helper_widget/custom_withdraw_textField.dart';
import 'manage_withdraw_controller.dart';

class ManageWithdraw extends StatefulWidget {
  const ManageWithdraw({Key? key}) : super(key: key);

  @override
  State<ManageWithdraw> createState() => _ManageWithdrawState();
}

class _ManageWithdrawState extends State<ManageWithdraw> {
  WithDrawController withdrawController = Get.put(WithDrawController());
  RxString paidStatus = "All".obs; // Using RxString for reactive updates
  int current = 0; // Track current selected index

  @override
  void initState() {
    super.initState();
    getRequestdata();
  }

  getRequestdata() async {
    withdrawController.withdrawrequestPage = 1;
    withdrawController.withdrawrequestlimit = 10;
    await withdrawController.getWithDrawRequest(
        '',
        '',
        withdrawController.withdrawrequestPage,
        withdrawController.withdrawrequestlimit);
    log('RequestData==>' + withdrawController.withdrawList.toString());
  }

  void fetchDataBasedOnStatus(int selectedIndex) {
    switch (selectedIndex) {
      case 0:
        paidStatus.value = 'All';
        break;
      case 1:
        paidStatus.value = 'Approved';
        break;
      case 2:
        paidStatus.value = 'Rejected';
        break;
      default:
        paidStatus.value = 'All';
        break;
    }
    //withdrawController.getWithDrawRequest('',paidStatus.value); // Fetch data based on selected status
  }

  void openAddRequestDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String amount = '';
        String message = '';

        return AlertDialog(
          title: Text('Add Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => amount = value,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) => message = value,
                decoration: InputDecoration(labelText: 'Message'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add request logic here
                if (amount.isNotEmpty && message.isNotEmpty) {
                  // Call method to add request
                  //  withdrawController.addWithdrawRequest(amount, message);
                  //  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show error or handle empty fields
                  // Example: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields')));
                }
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Map<String, dynamic>> headingList = [
      {"name": "All", "value": ""},
      {"name": "Approved", "value": "1"},
      {"name": "Rejected", "value": "2"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        title: Text(
          "Manage Withdraw",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        titleSpacing: 0.0,
        backgroundColor: primarylogin,
        elevation: 0,
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 22,
                ),
                onPressed: () {
                  // openAddRequestDialog(); // Open dialog to add request
                  _showAddWithdrawDialog(context);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 40,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Filter Chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              itemCount: headingList.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      current = index;
                    });
                    // FIX: Pass the actual status value instead of index
                    await withdrawController.getWithDrawRequest(
                        '',
                        headingList[index]['value'], // Pass the correct status value
                        1,
                        10);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: current == index ? primarylogin : Colors.white,
                      border: Border.all(
                        width: 1,
                        color: current == index ? Colors.transparent : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      headingList[index]['name'],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: current == index ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          const Divider(height: 1, thickness: 1),

          GetBuilder<WithDrawController>(builder: (withdrawController) {
            if (withdrawController.requestLoading.value) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.3),
                  child: CircularProgressIndicator(
                    color: primarylogin,
                    strokeWidth: 2,
                  ),
                ),
              );
            } else if (withdrawController.withdrawList.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(top: Get.height * 0.3),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 50,
                          color: Colors.grey[400],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No withdraw requests',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                        ),
                      ),

                    ],
                  ),
                ),
              );
            } else {
              return Expanded(
                child: RefreshIndicator(
                  color: primarylogin,
                  onRefresh: () async {
                    await withdrawController.getWithDrawRequest(
                        '',
                        headingList[current]['value'], // Pass correct status on refresh
                        1,
                        10);
                  },
                  child: ListView.builder(
                    controller: withdrawController.RequestscrollCtrl,
                    itemCount: withdrawController.withdrawList.length,
                    padding: const EdgeInsets.all(16),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var withdrawItem = withdrawController.withdrawList[index];

                      // Determine status color and text
                      String statusText = '';
                      Color statusColor = Colors.grey;

                      if (withdrawItem['paid_status'] == 0) {
                        statusText = "Pending";
                        statusColor = Colors.orange;
                      } else if (withdrawItem['paid_status'] == 1) {
                        statusText = "Approved";
                        statusColor = Colors.green;
                      } else if (withdrawItem['paid_status'] == 2) {
                        statusText = "Rejected";
                        statusColor = Colors.red;
                      }

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Message and Status Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    withdrawItem['message'] ?? 'No message',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Colors.grey[900],
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    statusText,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: statusColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // Date
                            Text(
                              withdrawItem['date'] ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Amount
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Requested Amount',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                Text(
                                  "+₹${withdrawItem['amount'].toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: primarylogin,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          }),
        ],
      ),
    );
  }

  void _showAddWithdrawDialog(BuildContext context) {
    // print('inside show product id $product_id');
    // print('inside  show productcontriller $productDetailController');
    TextEditingController amountController = TextEditingController();
    TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primarylogin.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.account_balance_wallet_outlined,
                    color: primarylogin,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Withdraw Request',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Enter amount and reason',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 24),

                // Amount Field
                AddWithdrawInputField(
                  hintText: 'Enter amount',
                  validator: Validations.validateAmount,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: amountController,
                ),

                const SizedBox(height: 16),

                // Message Field
                AddWithdrawInputField(
                  hintText: 'Enter reason',
                  validator: Validations.validateMessage,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z ]"))
                  ],
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  controller: messageController,
                ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Perform your save operation here, e.g., send data to API
                          String amount = amountController.text;
                          String message = messageController.text;

                          if (amount.isNotEmpty && message.isNotEmpty) {
                            withdrawController.addWithDrawRequest(amount, message);
                            Navigator.of(context).pop();
                          } else {
                            // Show validation message
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primarylogin,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          elevation: 0,
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}