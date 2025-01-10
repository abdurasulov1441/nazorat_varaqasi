import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';

class AdminMenuButton extends StatelessWidget {
  const AdminMenuButton({super.key, required this.name, required this.svgname});
  final String name;
  final String svgname;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.only(left: 5),
              backgroundColor: AppColors.foregroundColor,
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: const Color.fromARGB(255, 228, 228, 228),
                      width: 1),
                  borderRadius: BorderRadius.circular(5))),
          onPressed: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 35,
              ),
              SvgPicture.asset(
                'assets/images/$svgname.svg',
                width: 22,
                height: 22,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                name,
                style: AppStyle.fontStyle,
              ),
            ],
          )),
    );
  }
}
