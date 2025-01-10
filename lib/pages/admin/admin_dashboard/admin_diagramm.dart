import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';
import 'package:progress_bar_chart/progress_bar_chart.dart';

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
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 140,
              child: ListView.builder(
                itemCount: 8,
                itemBuilder: (BuildContext context, int index) {
                  return Admindiagramelements(
                    name: 'Texnika',
                    totalcards: 1000,
                    newcard: 600,
                    aceptedcard: 300,
                    finishedcard: 100,
                  );
                },
              ),
            ),
            Spacer(),
            AdminDiagramExplanations()
          ],
        ));
  }
}

class Admindiagramelements extends StatelessWidget {
  const Admindiagramelements(
      {super.key,
      required this.name,
      required this.totalcards,
      required this.newcard,
      required this.aceptedcard,
      required this.finishedcard});
  final String name;
  final double totalcards;
  final double newcard;
  final double aceptedcard;
  final double finishedcard;
  @override
  Widget build(BuildContext context) {
    final List<StatisticsItem> stats = [
      StatisticsItem(Color(0xFF007AFF), newcard, title: 'Yangi'),
      StatisticsItem(Color(0xFF34C759), aceptedcard, title: 'Qabul qilingan'),
      StatisticsItem(Color(0xFFFF9500), finishedcard, title: 'Bajarilgan'),
    ];
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 5,
          ),
          Text(
            name,
            style: AppStyle.fontStyle,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: ProgressBarChart(
              values: stats,
              height: 22,
              borderRadius: 10,
              totalPercentage: totalcards,
              unitLabel: '',
            ),
          ),
        ],
      ),
    );
  }
}

class AdminDiagramExplanations extends StatelessWidget {
  const AdminDiagramExplanations({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AdminDiagramExplanationsContainer(
            name: 'Yangi',
            colorsquare: 'blue',
          ),
          AdminDiagramExplanationsContainer(
            name: 'Qabul qilingan',
            colorsquare: 'orange',
          ),
          AdminDiagramExplanationsContainer(
            name: 'Bajarilgan',
            colorsquare: 'green',
          )
        ],
      ),
    );
  }
}

class AdminDiagramExplanationsContainer extends StatelessWidget {
  const AdminDiagramExplanationsContainer(
      {super.key, required this.name, required this.colorsquare});
  final String name;
  final String colorsquare;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset('assets/images/$colorsquare.svg'),
        SizedBox(
          width: 5,
        ),
        Text(
          name,
          style: AppStyle.fontStyle,
        ),
        SizedBox(
          width: 15,
        )
      ],
    );
  }
}
