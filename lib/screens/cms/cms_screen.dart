

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ifresh_delivery/Colors/colors.dart';
import 'package:ifresh_delivery/constant/api.dart';
import 'package:ifresh_delivery/screens/cms/cmsController.dart';
import 'package:get/get.dart';

class CmsPages extends StatefulWidget {
  var title;
  var id;
  var slug;


   CmsPages(
   {super.key, this.title, this.id,this.slug});

  @override
  State<CmsPages> createState() => _CmsPagesState();
}

class _CmsPagesState extends State<CmsPages> {
  CMSController cmsController = Get.put(CMSController());
  @override
  void initState() {
    super.initState();
    var cmsUrl = Uri.parse('https://ifresh.technolite.in/api/customer/cms/${widget.slug}');
    // var cmsUrl = Uri.parse('https://garu.co.in/api/customer/cms/${widget.slug}');
    // var cmsUrl = Uri.parse('https://garu.technolite.in/api/customer/cms/${widget.slug}');
    cmsController.cmsAPICalling(cmsUrl);
  }
  String cleanHtml(String html) {
    return html
    // Remove font-feature-settings
        .replaceAll(RegExp(r'font-feature-settings:[^;"]*;?'), '')
    // Remove problematic inline styles completely (safe option)
        .replaceAll(RegExp(r'style="[^"]*"'), '');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        titleSpacing: 0,
        elevation: 2,
        automaticallyImplyLeading: false,
        backgroundColor: primary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Icon(Icons.arrow_back,
                color: Colors.white
            ),
          ),
        ),
        title: Text('${widget.title}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 18,color: Colors.white),),
      ),
      body: GetBuilder<CMSController>(
          builder: (cmsController) {
            if(cmsController.cmsload.value){
              return Center(child: CircularProgressIndicator());
            }
            else {
              return SingleChildScrollView(
                child: Padding(
                  padding:  EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Image.network(cmsController.cmsdata['image'].toString(),
                        height: 180,
                        width: 180,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(child: Image.asset('assets/images/iFresh.png',scale: 5,));
                        },),
                      Padding(
                        padding:  EdgeInsets.only(left: 10,right: 10),
                        child: Html(
                          data: cleanHtml(
                              cmsController.cmsdata['description'].toString()
                          ),
                        )
                      ),
                    ],
                  ),
                ),
              );
            }
          }
      ),
    );
  }
}


