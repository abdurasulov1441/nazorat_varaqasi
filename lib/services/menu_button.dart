import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';

class AdminMenuButton extends StatelessWidget {
  const AdminMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.only(left: 5),
            backgroundColor: AppColors.foregroundColor,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.backgroundColor, width: 1),
                borderRadius: BorderRadius.circular(5))),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/user.png',
              width: 16,
              height: 16,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Menu',
              style: AppStyle.fontStyle,
            ),
          ],
        ));
  }
}
