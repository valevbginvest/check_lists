import 'package:flutter/material.dart';

import 'admin_page.dart';
import 'create_table_record_page.dart';
import 'models1.dart';

void main() {
  runApp(TableApp());
}

class TableApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Table App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<TableModel> _tables = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Table Management System')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final newTable = await Navigator.push<TableModel>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminPage(),
                  ),
                );
                if (newTable != null) {
                  setState(() {
                    _tables.add(newTable);
                  });
                }
              },
              child: Text('Go to Admin Page (Create Table)'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_tables.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No tables created yet!')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TableManagementPage(tables: _tables),
                    ),
                  );
                }
              },
              child: Text('Go to Table Management (Create Record)'),
            ),
          ],
        ),
      ),
    );
  }
}
