import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nazorat_varaqasi/style/app_colors.dart';
import 'package:nazorat_varaqasi/style/app_style.dart';

class AdminSearch extends StatelessWidget {
  const AdminSearch({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: 1046,
      height: 260,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(top: 10, left: 15),
      decoration: BoxDecoration(
          color: AppColors.foregroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 200,
                height: 40,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Kiritng',
                    hintStyle: TextStyle(fontSize: 14),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.iconColor),
                    ),
                    suffixIcon: const Icon(
                      Icons.search,
                      size: 20,
                      color: AppColors.dividerColor,
                    ),
                  ),
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 160,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'dan',
                        hintStyle: AppStyle.fontStyle
                            .copyWith(color: AppColors.dividerColor),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: SvgPicture.asset(
                            'assets/images/calendar.svg',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 40,
                    width: 160,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'gacha',
                        hintStyle: AppStyle.fontStyle
                            .copyWith(color: AppColors.dividerColor),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: SvgPicture.asset(
                            'assets/images/calendar.svg',
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    height: 40,
                    width: 160,
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        hintText: 'Tanlang',
                        hintStyle: AppStyle.fontStyle
                            .copyWith(color: AppColors.dividerColor),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                      ),
                      items: <String>['Variant 1', 'Variant 2', 'Variant 3']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {},
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
              width: double.infinity, height: 205, child: AdminSearchTable())
        ],
      ),
    );
  }
}

class AdminSearchTable extends StatelessWidget {
  AdminSearchTable({super.key});

  final List<Map<String, dynamic>> tableData = [
    {
      "number": "1",
      "department": "Texnika",
      "employee": "Abdulaziz Abdurasulov",
      "startDate": "06.01.2025",
      "endDate": "14.05.2025",
      "content":
          "Tuman shaharlarida qo‘riqlovgan olingan obyekt va xonadonlarning hisobotini shakllantirish",
      "status": {"text": "Yangi", "color": Colors.blue},
    },
    {
      "number": "2",
      "department": "Shtab",
      "employee": "Abdulaziz Abdurasulov",
      "startDate": "06.01.2025",
      "endDate": "14.05.2025",
      "content":
          "Tuman shaharlarida qo‘riqlovgan olingan obyekt ва xonadonlarning hisobotini shakllantirish",
      "status": {"text": "Qabul qildi", "color": Colors.orange},
    },
    {
      "number": "3",
      "department": "Shtab",
      "employee": "Abdulaziz Abdurasulov",
      "startDate": "06.01.2025",
      "endDate": "14.05.2025",
      "content":
          "Tuman shaharlarida qo‘riqlovgan olingan obyekt ва xonadonlarning hisobotini shakllantirish",
      "status": {"text": "Bajarildi", "color": Colors.green},
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTableHeader(),
        Expanded(
          child: ListView.separated(
            itemCount: tableData.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 1, color: Colors.grey);
            },
            itemBuilder: (BuildContext context, int index) {
              return _buildTableRow(tableData[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          _buildHeaderCell("№", 50),
          _buildHeaderCell("Bo‘lim", 120),
          _buildHeaderCell("Biriktirilgan xodim", 200),
          _buildHeaderCell("Berilgan sana", 120),
          _buildHeaderCell("Yakuniy sana", 220),
          _buildHeaderCell("Mazmuni", 220),
          _buildHeaderCell("Holati", 70),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          _buildRowCell(data["number"], 50),
          _buildRowCell(data["department"], 120),
          _buildRowCell(data["employee"], 200),
          _buildRowCell(data["startDate"], 120),
          _buildRowCell(data["endDate"], 120),
          _buildRowCell(data["content"], 250),
          _buildStatusCell(
              data["status"]["text"], data["status"]["color"], 140),
        ],
      ),
    );
  }

  Widget _buildRowCell(String text, double width) {
    return Container(
      width: width,
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatusCell(String text, Color color, double width) {
    return Container(
      width: width,
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
