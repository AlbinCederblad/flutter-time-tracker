import 'package:time_tracker_app/models/custom_data_table.dart' as dataTable;
import 'package:time_tracker_app/database/database_helper.dart';
import 'package:time_tracker_app/models/entry.dart';
import 'package:flutter/material.dart';

class LogPage extends StatefulWidget {
  @override
  LogPageState createState() => LogPageState();
}

class LogPageState extends State<LogPage> {
  List<Entry> list = new List();
  List<dataTable.DataRow> dataRows = new List();
  var db = DatabaseHelper();
  List<Map<String, dynamic>> entryList = [];

  @override
  void initState() {
    super.initState();
    db.getAllEntries().then((entries) {
      setState(() {
        entries.forEach((entry) {
          list.add(Entry.fromMap(entry));
        });
        list.sort((a, b) => a.endDateTime.compareTo(b.endDateTime));
      });
    });
  }

  Widget dataBody() => dataTable.DataTable(
        sortColumnIndex: 1,
        sortAscending: false,
        columns: <dataTable.DataColumn>[
          dataTable.DataColumn(
            label: Text(
              "Weekday",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            numeric: false,
            onSort: (i, b) => {},
          ),
          dataTable.DataColumn(
            label: Text(
              "Date",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            numeric: false,
            onSort: (i, b) => () {
                  setState(() {
                    list.sort((a, b) => a.endDateTime.compareTo(b.endDateTime));
                  });
                },
          ),
          dataTable.DataColumn(
            label: Text(
              "Time",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            numeric: false,
            onSort: (i, b) => () {
                  setState(() {
                    list.sort((a, b) =>
                        a.durationInMinutes.compareTo(b.durationInMinutes));
                  });
                },
          ),
        ],
        rows: list
            .map(
              (entry) => dataTable.DataRow(
                    cells: <dataTable.DataCell>[
                      dataTable.DataCell(
                        Text(entry.getDay().toString()),
                        showEditIcon: false,
                      ),
                      dataTable.DataCell(
                        Text(entry.getDate()),
                        showEditIcon: false,
                      ),
                      dataTable.DataCell(
                        Text(entry.hourMinutes()),
                        showEditIcon: false,
                      ),
                    ],
                  ),
            )
            .toList(),
      );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: dataBody());
  }
}
