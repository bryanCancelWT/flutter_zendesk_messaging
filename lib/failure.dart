import 'dart:convert';

class Failure<T> {
  Object data;
  StackTrace? stacktrace;
  Type get dataType => data.runtimeType;

  /// [data] needs a [toString] method for this to work properly
  Map<String, dynamic> toJson() {
    return {
      'dataType': '$dataType',
      'data': '$data',
      'stacktrace': '$stacktrace',
    };
  }

  /// for debugging
  @override
  String toString() => jsonEncode(toJson());

  factory Failure.fromJson(Map<String, dynamic> json) {
    return Failure(json['data'], json['stacktrace']);
  }

  /// ez constructor
  Failure(this.data, [this.stacktrace]);
}
