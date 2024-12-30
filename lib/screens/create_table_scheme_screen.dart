import 'package:flutter/material.dart';
import '../models.dart';
import '../widgets/field_configuration_widget.dart';

class CreateTableSchemeScreen extends StatefulWidget {
  final TableScheme? tableScheme;

  const CreateTableSchemeScreen({super.key,
    this.tableScheme,
  });

  @override
  State<CreateTableSchemeScreen> createState() => _CreateTableSchemeScreenState();
}

class _CreateTableSchemeScreenState extends State<CreateTableSchemeScreen> {
  late final TextEditingController _tableNameController = TextEditingController(
    text: widget.tableScheme?.name ?? '',
  );
  late final List<TableField> _fields = List.from(widget.tableScheme?.fields ?? []);

  void _addField() {
    setState(() {
      _fields.add(const TableField());
    });
  }

  void _saveTable() {
    if (_tableNameController.text.isNotEmpty && _fields.isNotEmpty) {
      final newTable = TableScheme(
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
  void dispose() {
    _tableNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((widget.tableScheme == null)
            ? 'Create table' : 'Edit table'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveTable,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _tableNameController,
              decoration: InputDecoration(labelText: 'Table Name'),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _fields.length,
                itemBuilder: (context, index) {
                  final field = _fields[index];
                  return FieldConfigurationWidget(
                    field: field,
                    setField: (newField) {
                      setState(() {
                        _fields[index] = newField;
                      });
                    },
                    removeField: (field) {
                      setState(() {
                        _fields.removeAt(index);
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addField,
        child: Icon(Icons.add),
      ),
    );
  }
}