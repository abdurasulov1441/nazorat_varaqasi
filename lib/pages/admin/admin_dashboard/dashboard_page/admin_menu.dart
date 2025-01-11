import 'package:flutter/material.dart';
import 'package:nazorat_varaqasi/services/menu_button.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 10),
      width: 249,
      height: 630,
      decoration: BoxDecoration(
          color: AppColors.foregroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          AdminMenuButton(
            name: 'Dashboard',
            svgname: 'dashboard',
          ),
          EmployeeAccordionPage(),
          SizedBox(
            height: 5,
          ),
          AdminMenuButton(
            name: 'Foydalanuvchilar',
            svgname: 'users',
          ),
          Spacer(),
          AdminMenuButton(
            name: 'Chiqish',
            svgname: 'exit',
          ),
        ],
      ),
    );
  }
}

class EmployeeAccordionPage extends StatelessWidget {
  static const headerStyle = TextStyle(
      color: Color(0xffffffff), fontSize: 18, fontWeight: FontWeight.bold);
  static const contentStyle = TextStyle(
      color: Color(0xff444444), fontSize: 16, fontWeight: FontWeight.normal);

  const EmployeeAccordionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Accordion(
      initialOpeningSequenceDelay: 1,
      maxOpenSections: 1,
      headerBorderRadius: 5,
      headerBackgroundColor: Colors.white,
      // headerBackgroundColorOpened: Colors.red[900],
      headerBorderColor: Colors.grey[300],
      headerBorderWidth: 1,
      // headerBorderColorOpened: AppColors.iconColor,
      rightIcon: SvgPicture.asset(
        'assets/images/acordion_icon.svg',
        width: 22,
        height: 22,
      ),
      flipRightIconIfOpen: true,
      contentBackgroundColor: Colors.white,
      contentBorderColor: AppColors.backgroundColor,
      paddingListBottom: 5,
      children: [
        AccordionSection(
          isOpen: false,
          leftIcon: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: SvgPicture.asset(
              'assets/images/bolimlar.svg',
              width: 22,
              height: 22,
            ),
          ),
          header: SizedBox(
              height: 35,
              child: Row(
                children: [
                  Text('Bo\'limlar', style: AppStyle.fontStyle),
                ],
              )),
          content: SizedBox(
            width: double.infinity,
            height: 200,
            child: Expanded(
              child: ListView.separated(
                itemCount: 7,
                itemBuilder: (BuildContext context, int index) {
                  return ButtonForAcordion(
                    name: 'Texnika',
                    svgname: 'bolimlar_item',
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 4,
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ButtonForAcordion extends StatelessWidget {
  const ButtonForAcordion(
      {super.key, required this.name, required this.svgname});
  final String name;
  final String svgname;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: EdgeInsets.only(left: 5),
            backgroundColor: AppColors.foregroundColor,
            shape: RoundedRectangleBorder(
                side: BorderSide(color: AppColors.headerColor, width: 0),
                borderRadius: BorderRadius.circular(5))),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SvgPicture.asset(
              'assets/images/$svgname.svg',
              width: 16,
              height: 16,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              name,
              style: AppStyle.fontStyle,
            ),
          ],
        ));
  }
}
