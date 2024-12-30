import 'package:flutter/material.dart';
import 'package:sale_helper/models1.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final TextEditingController _tableNameController = TextEditingController();
  final List<TableField> _fields = [];

  void _addField() {
    setState(() {
      _fields.add(TableField(
        name: '',
        type: TableFieldType.freeText,
      ));
    });
  }

  void _saveTable() {
    if (_tableNameController.text.isNotEmpty && _fields.isNotEmpty) {
      final newTable = TableModel(
        name: _tableNameController.text,
        fields: List.from(_fields),
      );
      Navigator.pop(context, newTable);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Table name and fields are required!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tableNameController,
              decoration: InputDecoration(labelText: 'Table Name'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  final field = _fields[index];
                  return ListTile(
                    title: TextField(
                      onChanged: (value) => _fields[index] = TableField(
                        name: value,
                        type: field.type,
                        predefinedValues: field.predefinedValues,
                        unit: field.unit,
                      ),
                      decoration: InputDecoration(labelText: 'Field Name'),
                    ),
                    subtitle: DropdownButton<TableFieldType>(
                      value: field.type,
                      items: TableFieldType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        );
                      }).toList(),
                      onChanged: (newType) {
                        setState(() {
                          _fields[index] = TableField(
                            name: field.name,
                            type: newType!,
                            predefinedValues: newType == TableFieldType.singleSelectableText || newType == TableFieldType.singleSelectableNumber
                                ? []
                                : null,
                            unit: newType == TableFieldType.numberWithUnit ? '' : null,
                          );
                        });
                      },
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _fields.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _addField,
              child: Text('Add Field'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveTable,
              child: Text('Save Table'),
            ),
          ],
        ),
      ),
    );
  }
}
