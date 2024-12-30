import 'package:flutter/material.dart';
import 'package:sale_helper/models.dart';

class TableScreen extends StatefulWidget {
  final TableScheme tableScheme;

  const TableScreen({super.key,
    required this.tableScheme,
  });

  @override
  State<TableScreen> createState() => _TableScreenState();
}

class _TableScreenState extends State<TableScreen> {
  late TableScheme tableScheme = widget.tableScheme.copyWith();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tableScheme.name),),
      body: Container(
        child: Column(
          children: [
            // Text('Current record data: ${tableScheme.toString() ?? ''}'),
            // SizedBox(height: 16,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ...tableScheme.fields.map((field) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 1),
                      child: SizedBox(
                        width: 65,
                        child: Column(
                          children: [
                            Text(field.name ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8,),
                            ...tableScheme.records.map((record) {
                              return Text(record[tableScheme.fields.indexOf(field)].toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tableScheme.fields.length,
              itemBuilder: (context, index) {
                final field = tableScheme.fields[index];
                // return ListTile(
                //   title: Text(field.name ?? ''),
                //   subtitle: Text(field.type.toString()),
                // );
                return TableInputField(
                  field: field,
                  onChanged: (value) {
                    var res = (value.isNotEmpty == true) ? value : null;
                    setState(() {
                      print(field.copyWith(value: res));
                      tableScheme.fields[index] = field.copyWith(value: res);
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {tableScheme.generateRecord(true);});
        },
      ),
    );
  }
}

class TableInputField extends StatefulWidget {
  final TableField field;
  final Function(dynamic) onChanged;

  const TableInputField({super.key,
    required this.field,
    required this.onChanged,
  });

  @override
  State<TableInputField> createState() => _TableInputFieldState();
}

class _TableInputFieldState extends State<TableInputField> {
  late final _controller = TextEditingController(
    text: (widget.field.value ?? '').toString(),
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.addListener(() {
        widget.onChanged(_controller.text);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 30,
            child: Text("${widget.field.name ?? ''} :",),
          ),
          Expanded(
            flex: 70,
            // child: TextField(),
            child: _buildInputField(widget.field),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(TableField field) {
  //   switch (widget.field.type) {
  //     case TableFieldType.freeText:
  //       return TextField();
  //     default:
  //       return TextField();
  //   }

  //   return ElevatedButton(
  //     onPressed: () async {
  //       final date = await showDatePicker(
  //         context: context,
  //         initialDate: DateTime.now(),
  //         firstDate: DateTime(2000),
  //         lastDate: DateTime(2100),
  //       );
  //       if (date != null) {
  //         setState(() {
  //           _fieldValues[field.name] = date.toIso8601String();
  //         });
  //       }
  //     },
  //     child: Text(_fieldValues[field.name] ?? 'Select Date'),
  //   );

    if (field.type == TableFieldType.dateTime) {
      return TextField(
        controller: _controller,
        readOnly: true, // Prevents manual typing
        onTap: () async {
          var date = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          final selectedTime = await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          );

          if (date != null) {
            date = DateTime(
              date.year,
              date.month,
              date.day,
              selectedTime?.hour ?? 0,
              selectedTime?.minute ?? 0,
            );

            setState(() {
              _controller.text = date!.toIso8601String();
            });
          }
        },
        decoration: InputDecoration(
          labelText: 'Select Date and Time',
          suffixIcon: Icon(Icons.calendar_today),
        ),
      );
    }
    else if (field.hasPredefinedValues) {
      return DropdownMenu(
        width: 270,
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          // contentPadding: EdgeInsets.all(2),
        ),
        controller: _controller,
        initialSelection: field.value,
        requestFocusOnTap: true,
        onSelected: (newType) {
          // setField(field.copyWith(type: newType));
        },
        dropdownMenuEntries: field.predefinedValues.map((value) {
          return DropdownMenuEntry(
            value: value,
            label: value.toString().split('.').last,
          );
        }).toList(),
      );
    }
    else {
      return TextField(
        controller: _controller,
        keyboardType: (field.type == TableFieldType.number)
            ? TextInputType.number : null,
      );
    }
  }
}

