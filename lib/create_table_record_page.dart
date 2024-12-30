import 'package:flutter/material.dart';
import 'package:sale_helper/models1.dart';

class TableManagementPage extends StatefulWidget {
  final List<TableModel> tables;

  const TableManagementPage({required this.tables});

  @override
  _TableManagementPageState createState() => _TableManagementPageState();
}

class _TableManagementPageState extends State<TableManagementPage> {
  TableModel? _selectedTable;
  final Map<String, dynamic> _fieldValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Table Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<TableModel>(
              value: _selectedTable,
              hint: Text('Select Table'),
              items: widget.tables.map((table) {
                return DropdownMenuItem(
                  value: table,
                  child: Text(table.name),
                );
              }).toList(),
              onChanged: (newTable) {
                setState(() {
                  _selectedTable = newTable;
                  _fieldValues.clear();
                });
              },
            ),
            if (_selectedTable != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _selectedTable!.fields.length,
                  itemBuilder: (context, index) {
                    final field = _selectedTable!.fields[index];
                    return ListTile(
                      title: Text(field.name),
                      subtitle: _buildFieldInput(field),
                    );
                  },
                ),
              ),
            if (_selectedTable != null)
              ElevatedButton(
                onPressed: () {
                  // Save the record logic
                  print('Saved values: $_fieldValues');
                },
                child: Text('Save Record'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldInput(TableField field) {
    switch (field.type) {
      case TableFieldType.freeText:
        return TextField(
          onChanged: (value) => _fieldValues[field.name] = value,
          decoration: InputDecoration(labelText: 'Enter text'),
        );
      case TableFieldType.numberWithUnit:
        return TextField(
          keyboardType: TextInputType.number,
          onChanged: (value) => _fieldValues[field.name] = double.tryParse(value),
          decoration: InputDecoration(labelText: 'Enter number (${field.unit})'),
        );
      case TableFieldType.singleSelectableText:
      case TableFieldType.singleSelectableNumber:
        return DropdownButton<dynamic>(
          value: _fieldValues[field.name],
          items: field.predefinedValues!
              .map((value) => DropdownMenuItem(value: value, child: Text(value.toString())))
              .toList(),
          onChanged: (value) {
            setState(() {
              _fieldValues[field.name] = value;
            });
          },
        );
      case TableFieldType.dateTime:
        return ElevatedButton(
          onPressed: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (date != null) {
              setState(() {
                _fieldValues[field.name] = date.toIso8601String();
              });
            }
          },
          child: Text(_fieldValues[field.name] ?? 'Select Date'),
        );
      default:
        return SizedBox();
    }
  }
}
