import 'dart:math';

class TableScheme {
  String name;
  List<List<dynamic>> records;
  List<TableField> fields;

  TableScheme({required this.name, required this.fields, this.records = const []});

  TableScheme copyWith({
    String? name,
    List<TableField>? fields,
    List<List<dynamic>>? records,
  }) {
    return TableScheme(
      name: name ?? this.name,
      fields: List.from(fields ?? this.fields),
      records: List.from(records ?? this.records),
    );
  }

  List<TableScheme> multiplyRecordsForEach(TableScheme initialRecord) {
    bool needsToMultiple = initialRecord.fields.any(
        (field) => field.autoGenerationType == AutoGenerationType.forEach
            && field.hasPredefinedValues && field.value == null
    );

    if (!needsToMultiple) {
      return [initialRecord];
    }
    else {
      var copies = <TableScheme>[];
      var field = initialRecord.fields.firstWhere(
          (field) => field.autoGenerationType == AutoGenerationType.forEach
              && field.hasPredefinedValues && field.value == null
      );
      for (var predefinedValue in field.predefinedValues) {
        var copy = initialRecord.copyWith(
          fields: initialRecord.fields,
        );
        copy.fields[copy.fields.indexOf(field)] = field.copyWith(value: predefinedValue);
        copies.addAll(multiplyRecordsForEach(copy));
      }
      return copies;
    }
  }

  void generateRecord([bool addThem = false]) {
    print(this);
    List<TableScheme> list = multiplyRecordsForEach(this);
    for (var record in list) {
      for (var field in record.fields) {
        if (field.hasPredefinedValues && field.value == null) {
          var dice = Random().nextInt(field.predefinedValues.length);
          print('nextInt --> $dice');
          record.fields[record.fields.indexOf(field)] = field.copyWith(
            value: field.predefinedValues[dice],
          );
        }
      }
    }
    print(list.map((e) => e.generateDebugPrint()));
    if (addThem) {
      records.addAll(list.map((e) => e.fields.map((e) => e.value).toList()));
    }
  }

  @override
  String toString() {
    return 'TableScheme(name: $name, fields: ${fields.map((f) => f.toString()).join(', ')})';
  }

  String debugPrint() {
    return 'TableScheme(name: $name, fields: ${fields.map((f) => f.debugPrint()).join(', ')})';
  }

  String generateDebugPrint() {
    return 'Table_${name}(\n${fields.map((f) => f.value.toString()).join('  --  ')})';
  }
}

enum TableFieldType {freeText, number, dateTime}

enum AutoGenerationType {none, singleValue, forEach}

class TableField<T> {
  final String? name;
  final dynamic value;
  final TableFieldType? type;
  final AutoGenerationType autoGenerationType;
  final Map<T, int>? predefinedValuesWithProbabilities;
  final String? unit;
  final double? minValue;
  final double? maxValue;

  List<T> get predefinedValues => predefinedValuesWithProbabilities?.keys.toList() ?? [];
  bool get hasPredefinedValues => predefinedValues.isNotEmpty;

  const TableField({
    this.name,
    this.value,
    this.type,
    this.autoGenerationType = AutoGenerationType.singleValue,
    this.predefinedValuesWithProbabilities,
    this.unit,
    this.minValue,
    this.maxValue,
  });

  TableField copyWith({
    String? name,
    dynamic value,
    TableFieldType? type,
    AutoGenerationType? autoGenerationType,
    Map<T, int>? predefinedValuesWithProbabilities,
    String? unit,
    double? minValue,
    double? maxValue,
  }) {
    return TableField(
      name: name ?? this.name,
      value: value ?? this.value,
      type: type ?? this.type,
      autoGenerationType: autoGenerationType ?? this.autoGenerationType,
      predefinedValuesWithProbabilities: (predefinedValuesWithProbabilities != null)
          ? Map.from(predefinedValuesWithProbabilities)
          : Map.from(this.predefinedValuesWithProbabilities ?? {}),
      unit: unit ?? this.unit,
      minValue: minValue ?? this.minValue,
      maxValue: maxValue ?? this.maxValue,
    );
  }

  @override
  String toString() {
    return '\n[ --    $name    --    $value    --    ${type?.name}    -- '
        '${autoGenerationType == AutoGenerationType.forEach} -- '
        '${hasPredefinedValues ? '\n ==> ' : ''} '
        '${predefinedValuesWithProbabilitiesAsString()}]';
    return 'TableField('
        'name: $name, '
        'name: $value, '
        'type: ${type?.name}, '
        'autoGenerationType: ${autoGenerationType.name}, '
        'predefinedValuesWithProbabilities: ${predefinedValuesWithProbabilitiesAsString()}, '
        // 'unit: $unit, '
        // 'minValue: $minValue, '
        // 'maxValue: $maxValue'
        ')\n';
  }

  String debugPrint() {
    return 'TableField('
        'name: $name, '
        'name: $value, '
        'type: ${type?.name}, '
        'autoGenerationType: ${autoGenerationType.name}, '
        'predefinedValuesWithProbabilities: ${predefinedValuesWithProbabilitiesAsString()}, '
        ')\n';
  }

  String predefinedValuesWithProbabilitiesAsString() {
    return predefinedValuesWithProbabilities?.entries.map((entry) {
      return '${entry.key} (${entry.value})';
    }).join(', ') ?? '';
  }
}