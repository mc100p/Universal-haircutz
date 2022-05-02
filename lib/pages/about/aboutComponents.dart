import 'package:flutter/material.dart';

DataTable createDataTable() {
  return DataTable(columns: _createColumns(), rows: _createRows());
}

List<DataColumn> _createColumns() {
  return [
    DataColumn(label: Text('Day')),
    DataColumn(label: Text('Start')),
    DataColumn(label: Text('End')),
  ];
}

List<DataRow> _createRows() {
  return [
    DataRow(cells: [
      DataCell(Text('Monday - Friday')),
      DataCell(Text('8 am')),
      DataCell(Text('8 pm'))
    ]),
    DataRow(cells: [
      DataCell(Text('Saturday')),
      DataCell(Text('8 am')),
      DataCell(Text('5 pm'))
    ]),
    DataRow(cells: [
      DataCell(Text('Sunday')),
      DataCell(Text('10 am')),
      DataCell(Text('5 pm'))
    ])
  ];
}

Column subHeader(String text) {
  return Column(
    // mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14.0),
      ),
      Divider(thickness: 1),
    ],
  );
}

class AboutDetails extends StatelessWidget {
  const AboutDetails({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
            'The business has become the meeting place of the community who are looking to relax, kick back and share stories, watch a sporting event. In some cases, play a game of pool or cards. Most importantly, get their haircut and maybe a shave.'),
        SizedBox(height: size.height * 0.05),
        Text(
            'The barbershop of yesteryear is still around, but the simple shop with a few old-style barber chairs has evolved into more of a hip, men’s grooming spot.')
      ],
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Universal Haircutz",
          style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.w200),
        ),
      ],
    );
  }
}
