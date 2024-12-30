enum TableFieldType {
  freeText,
  numberWithUnit,
  singleSelectableText,
  singleSelectableNumber,
  dateTime,
}

class TableField {
  final String name;
  final TableFieldType type;
  final List<dynamic>? predefinedValues; // For `singleSelectable` types
  final String? unit; // For `numberWithUnit` type

  TableField({
    required this.name,
    required this.type,
    this.predefinedValues,
    this.unit,
  });
}

class TableModel {
  final String name;
  final List<TableField> fields;

  TableModel({
    required this.name,
    required this.fields,
  });
}
