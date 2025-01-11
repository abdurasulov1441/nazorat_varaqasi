import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';

class AceptedCards extends StatelessWidget {
  const AceptedCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      height: 243,
      padding: EdgeInsets.only(
        left: 10,
      ),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: AppColors.foregroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    '№ ',
                    style: AppStyle.fontStyle
                        .copyWith(fontSize: 12, color: AppColors.textGrayColor),
                  ),
                  Text('25 B')
                ],
              ),
              Container(
                decoration: BoxDecoration(
                    color: Color(0xFF34C759),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10))),
                width: 54,
                height: 34,
                child: Text('25'),
              )
            ],
          )
        ],
      ),
    );
  }
}
