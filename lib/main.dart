import 'package:flutter/material.dart';
import 'package:sale_helper/screens/create_table_scheme_screen.dart';
import 'package:sale_helper/screens/table_screen.dart';
import 'models.dart';

class TableRepository {
  List<TableScheme> tables = [
    TableScheme(
      name: 'Users test',
      records: [
        ['John Doe', 25, DateTime(1996, 1, 1), 'Full Time', 'Remote', 'Morning'],
        ['Jane Doe', 30, DateTime(1991, 1, 1), 'Part Time', 'Office', 'Lunch'],
      ],
      fields: [
        TableField(name: 'Name', type: TableFieldType.freeText),
        TableField(name: 'Age', type: TableFieldType.number),
        TableField(name: 'Date of Birth', type: TableFieldType.dateTime),
        TableField(name: 'Job Type', type: TableFieldType.freeText,
          predefinedValuesWithProbabilities: {
            'Full Time': 25,
            'Part Time': 25,
            'Freelancer': 50,
          },
        ),
        TableField(name: 'Onsite', type: TableFieldType.freeText,
          autoGenerationType: AutoGenerationType.forEach,
          predefinedValuesWithProbabilities: {
            'Remote': 25,
            'Office': 50,
          },
        ),
        TableField(name: 'Task', type: TableFieldType.freeText,
          autoGenerationType: AutoGenerationType.forEach,
          predefinedValuesWithProbabilities: {
            'Morning': 25,
            'Lunch': 25,
          },
        ),
      ],
    ),
  ];
}

void main() {
  runApp(MyApp());
  // runApp(TableManagerApp());
  // runApp(TableApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic Table App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(
        tableRepository: TableRepository(),
      ),
      // home: const CreateTableSchemeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final TableRepository tableRepository;

  const HomeScreen({super.key,
    required this.tableRepository,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Tables')),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...widget.tableRepository.tables.map((table) {
              return Card(
                clipBehavior: Clip.antiAlias,
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16,0,0,0),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateTableSchemeScreen(
                            tableScheme: table,
                          ),
                        ),
                      ).then((newTable) {
                        if (newTable != null) {
                          setState(() {
                            widget.tableRepository.tables[widget.tableRepository.tables.indexOf(table)] = newTable;
                          });
                        }
                      });
                    },
                  ),
                  title: Text(table.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TableScreen(
                          tableScheme: table,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateTableSchemeScreen(),
            ),
          ).then((newTable) {
            if (newTable != null) {
              setState(() {
                widget.tableRepository.tables.add(newTable);
              });
            }
          });
        },
      ),
    );
  }
}