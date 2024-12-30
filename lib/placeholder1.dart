import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(TableManagerApp());
}

class TableManagerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Table Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AvailableTablesPage(),
    );
  }
}

class TableModel {
  String name;
  List<FieldModel> fields;

  TableModel({required this.name, required this.fields});
}

class FieldModel {
  String name;
  FieldType type;
  bool enableAutoGeneration;
  List<dynamic>? predefinedValues;
  Map<dynamic, double>? probabilities;
  double? minValue;
  double? maxValue;

  FieldModel({
    required this.name,
    required this.type,
    this.enableAutoGeneration = false,
    this.predefinedValues,
    this.probabilities,
    this.minValue,
    this.maxValue,
  });
}

enum FieldType { freeText, number, singleSelect, dateTime }

class AvailableTablesPage extends StatefulWidget {
  @override
  _AvailableTablesPageState createState() => _AvailableTablesPageState();
}

class _AvailableTablesPageState extends State<AvailableTablesPage> {
  List<TableModel> tables = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Available Tables')),
      body: ListView.builder(
        itemCount: tables.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tables[index].name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TableRecordsPage(table: tables[index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTable = await Navigator.push<TableModel?> (
            context,
            MaterialPageRoute(
              builder: (context) => CreateTablePage(),
            ),
          );
          if (newTable != null) {
            setState(() {
              tables.add(newTable);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TableRecordsPage extends StatelessWidget {
  final TableModel table;

  TableRecordsPage({required this.table});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(table.name)),
      body: Center(
        child: Text('Record creation and auto-generation coming soon.'),
      ),
    );
  }
}

class CreateTablePage extends StatefulWidget {
  @override
  _CreateTablePageState createState() => _CreateTablePageState();
}

class _CreateTablePageState extends State<CreateTablePage> {
  final TextEditingController tableNameController = TextEditingController();
  final List<FieldModel> fields = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Table')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: tableNameController,
              decoration: InputDecoration(labelText: 'Table Name'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: fields.length,
                itemBuilder: (context, index) {
                  final field = fields[index];
                  return ListTile(
                    title: Text(field.name),
                    subtitle: Text(field.type.toString().split('.').last),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final newField = await Navigator.push<FieldModel?> (
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateFieldPage(),
                  ),
                );
                if (newField != null) {
                  setState(() {
                    fields.add(newField);
                  });
                }
              },
              child: Text('Add Field'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (tableNameController.text.isNotEmpty) {
            final newTable = TableModel(
              name: tableNameController.text,
              fields: fields,
            );
            Navigator.pop(context, newTable);
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}

class CreateFieldPage extends StatefulWidget {
  @override
  _CreateFieldPageState createState() => _CreateFieldPageState();
}

class _CreateFieldPageState extends State<CreateFieldPage> {
  final TextEditingController fieldNameController = TextEditingController();
  FieldType? selectedType;
  final List<dynamic> predefinedValues = [];
  final Map<dynamic, TextEditingController> probabilityControllers = {};
  bool enableAutoGeneration = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Field')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: TextField(
                    controller: fieldNameController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(1, 5.5, 4, 10),
                      label: Text('Field Name', style: TextStyle(height: -0.01),),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                DropdownMenu<FieldType>(
                  // inputDecorationTheme: const InputDecorationTheme(
                  //   filled: true,
                  //   isDense: true,
                  //   // contentPadding: EdgeInsets.all(2),
                  // ),
                  requestFocusOnTap: true,
                  label: const Text('Type'),
                  onSelected: (FieldType? type) {
                    setState(() {
                      selectedType = type;
                    });
                  },
                  dropdownMenuEntries: FieldType.values.map((type) {
                    return DropdownMenuEntry(
                      value: type,
                      label: type.toString().split('.').last,
                    );
                  }).toList(),
                ),
              ],
            ),
            CheckboxListTile(
              title: Text('Enable Auto Generation'),
              value: enableAutoGeneration,
              onChanged: (value) {
                setState(() {
                  enableAutoGeneration = value ?? false;
                });
              },
              dense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedType != null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      final controller = TextEditingController();
                      return AlertDialog(
                        title: Text('Add Predefined Value'),
                        content: TextField(
                          controller: controller,
                          decoration: InputDecoration(labelText: 'Value'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                predefinedValues.add(controller.text);
                                if (enableAutoGeneration) {
                                  probabilityControllers[controller.text] =
                                      TextEditingController();
                                }
                              });
                              Navigator.pop(context);
                            },
                            child: Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: Text('Add Predefined Value'),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: predefinedValues.length,
                itemBuilder: (context, index) {
                  final value = predefinedValues[index];
                  return Row(
                    children: [
                      Expanded(
                        child: Text(value.toString()),
                      ),
                      if (enableAutoGeneration)
                        SizedBox(
                          width: 100,
                          child: TextField(
                            controller: probabilityControllers[value],
                            decoration:
                            InputDecoration(labelText: 'Probability'),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            predefinedValues.removeAt(index);
                            probabilityControllers.remove(value);
                          });
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (fieldNameController.text.isNotEmpty && selectedType != null) {
            final probabilities = enableAutoGeneration
                ? {
              for (var value in predefinedValues)
                value: double.tryParse(
                    probabilityControllers[value]?.text ?? '') ??
                    0.0
            }
                : null;
            final newField = FieldModel(
              name: fieldNameController.text,
              type: selectedType!,
              enableAutoGeneration: enableAutoGeneration,
              predefinedValues: predefinedValues.isNotEmpty
                  ? predefinedValues
                  : null,
              probabilities: probabilities,
            );
            Navigator.pop(context, newField);
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
