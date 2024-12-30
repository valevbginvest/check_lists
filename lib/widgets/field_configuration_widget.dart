import 'package:flutter/material.dart';
import '../main.dart';
import '../models.dart';

class FieldConfigurationWidget extends StatelessWidget {
  final TableField field;
  final Function(TableField) setField;
  final Function(TableField) removeField;

  const FieldConfigurationWidget({super.key,
    this.field = const TableField(),
    required this.setField,
    required this.removeField,
  });

  void onAddPredefinedValue(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        var text = '';
        return StatefulBuilder(
            builder: (context, StateSetter setState) {
              return AlertDialog(
                title: Text('Add Predefined Value'),
                content: TextField(
                  decoration: InputDecoration(labelText: 'Value'),
                  onChanged: (value) {
                    setState(() => text = value);
                  },
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
                      setField(field.copyWith(
                        predefinedValuesWithProbabilities: {
                          ...field.predefinedValuesWithProbabilities ?? {},
                          text: 0,
                        },
                      ));
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Flexible(
                child: TextFormField(
                  initialValue: field.name,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(3, 5.5, 4, 10),
                    label: Text('Field Name', style: TextStyle(height: -0.01),),
                  ),
                  onChanged: (value) {
                    setField(field.copyWith(name: value));
                  },
                ),
              ),
              const SizedBox(width: 24),
              DropdownMenu<TableFieldType>(
                // inputDecorationTheme: const InputDecorationTheme(
                //   filled: true,
                //   isDense: true,
                //   // contentPadding: EdgeInsets.all(2),
                // ),
                initialSelection: field.type,
                requestFocusOnTap: true,
                label: const Text('Type'),
                onSelected: (newType) {
                  setField(field.copyWith(type: newType));
                },
                dropdownMenuEntries: TableFieldType.values.map((type) {
                  return DropdownMenuEntry(
                    value: type,
                    label: type.toString().split('.').last,
                  );
                }).toList(),
              ),
              const SizedBox(width: 4),
            ],
          ),


          CheckboxListTile(
            title: Text('!Auto Generate for each'),
            value: field.autoGenerationType == AutoGenerationType.forEach,
            onChanged: (value) {
              setField(field.copyWith(
                  autoGenerationType: (value == true)
                      ? AutoGenerationType.forEach
                      : AutoGenerationType.singleValue
              ));
            },
            dense: true,
            contentPadding: EdgeInsets.fromLTRB(2,0,0,0),
          ),

          // SwitchListTile(
          //   title: Text('Enable Auto Generation'),
          //   value: field.autoGenerationType == AutoGenerationType.forEach,
          //   onChanged: (value) {
          //     setField(field.copyWith(
          //         autoGenerationType: (value == true)
          //             ? AutoGenerationType.forEach
          //             : AutoGenerationType.singleValue
          //     ));
          //   },
          // ),

          ElevatedButton(
            onPressed: () => onAddPredefinedValue(context),
            child: Text('Add Predefined Value'),
          ),

          // Column(
          //   children: [
          //     ...field.predefinedValues.map((value) {
          //       return Row(
          //         children: [
          //           Expanded(
          //             child: Text(value.toString()),
          //           ),
          //           if (field.autoGenerationType == AutoGenerationType.singleValue)
          //             SizedBox(
          //               width: 100,
          //               child: TextFormField(
          //                 initialValue: field.predefinedValuesWithProbabilities?[value].toString(),
          //                 decoration: InputDecoration(labelText: 'Probability'),
          //                 keyboardType: TextInputType.number,
          //                 onChanged: (probability) {
          //                   field.predefinedValuesWithProbabilities?[value]
          //                       = int.tryParse(probability) ?? 0;
          //                   setField(field.copyWith(
          //                     predefinedValuesWithProbabilities: {
          //                       ...?field.predefinedValuesWithProbabilities,
          //                     },
          //                   ));
          //                 },
          //               ),
          //             ),
          //           IconButton(
          //             icon: const Icon(Icons.delete),
          //             onPressed: () {
          //               setField(field.copyWith(
          //                   predefinedValuesWithProbabilities: Map.unmodifiable({
          //                     ...?field.predefinedValuesWithProbabilities?..remove(value),
          //                   },)
          //               ));
          //             },
          //           ),
          //         ],
          //       );
          //     }),
          //   ],
          // ),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: field.predefinedValues.length,
            itemBuilder: (context, index) {
              final value = field.predefinedValues[index];
              return Row(
                children: [
                  Expanded(
                    child: Text(value.toString()),
                  ),
                  if (field.autoGenerationType == AutoGenerationType.singleValue)
                    SizedBox(
                      width: 100,
                      child: TextFormField(
                        initialValue: field.predefinedValuesWithProbabilities?[value].toString(),
                        decoration: InputDecoration(labelText: 'Probability'),
                        keyboardType: TextInputType.number,
                        onChanged: (probability) {
                          field.predefinedValuesWithProbabilities?[value]
                              = int.tryParse(probability) ?? 0;
                          setField(field.copyWith(
                            predefinedValuesWithProbabilities: {
                              ...?field.predefinedValuesWithProbabilities,
                            },
                          ));
                        },
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setField(field.copyWith(
                          predefinedValuesWithProbabilities: Map.unmodifiable({
                            ...?field.predefinedValuesWithProbabilities?..remove(value),
                          },)
                      ));
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}