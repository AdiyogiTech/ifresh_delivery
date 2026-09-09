import 'package:flutter/material.dart';
import 'package:ifresh_delivery/constant/SizeBox.dart';
import 'package:ifresh_delivery/colors/colors.dart';
class AuthBackground extends StatelessWidget {
  final String labelname;

  final Widget childs;

  AuthBackground({
    super.key,
    required this.labelname,
    required this.childs
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/loginbg.png'),
            fit: BoxFit.fill
        ),
      ),
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 50),
                  height: 200,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16)),
                    image: DecorationImage(
                        image: AssetImage('assets/images/loginimg.png'),
                        fit: BoxFit.fill
                    ),
                  ),
                ),
                Positioned(
                  top: 270,
                  left: 15,
                  right: 15,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: primarylogin,
                    ),
                    padding: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        labelname.toUpperCase(),
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            sizebox_height_40,
            childs,
          ],
        ),
      ),
    );
  }
}