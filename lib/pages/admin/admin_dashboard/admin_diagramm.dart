import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';

class AdminDiagramm extends StatelessWidget {
  const AdminDiagramm({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 515,
      height: 200,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.only(top: 20, left: 15),
      decoration: BoxDecoration(
          color: AppColors.foregroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Text('data'),
    );
  }
}
