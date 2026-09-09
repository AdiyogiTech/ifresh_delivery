import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ifresh_delivery/colors/colors.dart';
import 'package:ifresh_delivery/constant/SizeBox.dart';
import 'package:ifresh_delivery/helper_widget/bottombar.dart';
import 'package:ifresh_delivery/screens/order_list/orderList_controller.dart';
class OrderDelivered extends StatefulWidget {
  const OrderDelivered({super.key});

  @override
  State<OrderDelivered> createState() => _OrderDeliveredState();
}

class _OrderDeliveredState extends State<OrderDelivered> {
  OrderListController orderListController = Get.put(OrderListController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //callApi();
  }

  // callApi() async {
  //   var statusUrl = Uri.parse(order_delivered_url);
  //   var statusBody = {
  //     'id': widget.id.toString(),
  //   };
  //   await orderListController.OrderDelivered(statusUrl, statusBody);
  //
  // }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primary,
        leading: IconButton(
          onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(bottomindex : 1)));
          },
          icon: Icon(Icons.arrow_back,color: textcolor1,),
        ),
        leadingWidth: 45,
        titleSpacing: 0,
        title: Text("Order Delivered",style: TextStyle(color: textcolor1),),
      ),
      body: RefreshIndicator(
        displacement: 50,
        backgroundColor: Colors.white,
        color: primary,
        strokeWidth: 3,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 1500));
         // callApi();
        },
        child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child:GetBuilder<OrderListController>(
                builder: (orderListController) {
                  if(orderListController.DeliverLoader.value){
                    return Container(
                        height: MediaQuery.of(context).size.height * 0.85,child: Center(child: CircularProgressIndicator(),));
                  }
                  else{
                    var data = orderListController.DeliverData;
                    String formattedDate;
                    String formattedTime;
                    String amPmIndicator;
                    //if(data["delivered_at"].toString() != "null" ){
                      // String timestamp = data["delivered_at"].toString();
                      String timestamp = "2023-06-11T14:30:00Z";
                      DateTime dateTime = DateTime.parse(timestamp);
                      formattedDate = "${dateTime.day.toString().padLeft(2, '0')}-${dateTime.month}-${dateTime.year}";
                      formattedTime = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
                      amPmIndicator = DateFormat('a').format(dateTime);
                  //  }else{
                      formattedDate = "--/--/----";
                      formattedTime = "--:--";
                      amPmIndicator = "";
                   // }
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: Center(
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 60,),
                            Container(
                              height: 250,
                              width: 300,
                              decoration:BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                borderRadius: BorderRadius.all(Radius.circular(15),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Center(child: Image.asset('assets/images/deliver.png',height: 125,width: 115,)),
                                  sizebox_height_10,
                                  Text("Order Delivered",
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color:textcolor1,
                                    ),),
                                  sizebox_height_15,
                                  // Text("Order No. : ${data["order_no"].toString() !="null" ?data["order_no"].toString() : "" }",
                                  Text("Order No. : 12345",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                      color: textcolor1,
                                    ),),
                                  sizebox_height_5,
                                  Text("${formattedDate.toString()}   ${formattedTime.toString()} ${amPmIndicator.toString()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: textcolor1,
                                    ),),
                                ],
                              ),
                            ),
                            sizebox_height_50,
                            // GestureDetector(
                            //   onTap: (){
                            //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomBar(bottomindex : 1)));
                            //   },
                            //   child: Container(
                            //     padding: EdgeInsets.all(10),
                            //     decoration: BoxDecoration(
                            //       color: primary,
                            //       borderRadius: BorderRadius.circular(8),
                            //     ),
                            //     child: Icon(
                            //       Icons.home,size: 30, color: Colors.white,
                            //     ),
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    );
                  }
                }
            )
        ),
      ),
    );
  }
}
