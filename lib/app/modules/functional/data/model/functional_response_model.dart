class FunctionalResponseModel {
  final bool? success;
  final String? message;
  final String? error;
  final List<FunctionalQuestion>? data;

  FunctionalResponseModel({this.success, this.message, this.error, this.data});

  factory FunctionalResponseModel.fromJson(Map<String, dynamic> json) {
    return FunctionalResponseModel(
      success: json['success'],
      message: json['message'],
      error: json['error'],
      data:
          json['data'] != null
              ? List<FunctionalQuestion>.from(
                (json['data'] as List).map(
                  (x) => FunctionalQuestion.fromJson(x),
                ),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'error': error,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class FunctionalQuestion {
  final String? questionId;
  final String? questionText;
  final String? questionType;
  final bool? isMandatory;
  final List<String>? applicableRole;
  final dynamic answer;
  final int? displayOrder;
  final int? maxLength;

  // Changed from VisibleWhen? to List<VisibleWhen>?
  final List<VisibleWhen>? visibleWhen;

  final String? dateFormat;
  final List<FunctionalOption>? option;

  FunctionalQuestion({
    this.questionId,
    this.questionText,
    this.questionType,
    this.isMandatory,
    this.applicableRole,
    this.answer,
    this.displayOrder,
    this.maxLength,
    this.visibleWhen,
    this.dateFormat,
    this.option,
  });

  factory FunctionalQuestion.fromJson(Map<String, dynamic> json) {
    return FunctionalQuestion(
      questionId: json['questionId'],
      questionText: json['questionText'],
      questionType: json['questionType'],
      isMandatory: json['isMandatory'],
      applicableRole:
          (json['applicableRole'] as List?)?.map((e) => e.toString()).toList(),
      answer: json['answer'],
      displayOrder: json['displayOrder'],
      maxLength: json['maxLength'],

      visibleWhen:
          json['visibleWhen'] != null
              ? List<VisibleWhen>.from(
                (json['visibleWhen'] as List).map(
                  (x) => VisibleWhen.fromJson(x),
                ),
              )
              : [],

      dateFormat: json['dateFormat'],

      option:
          json['option'] != null
              ? List<FunctionalOption>.from(
                (json['option'] as List).map(
                  (x) => FunctionalOption.fromJson(x),
                ),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'questionText': questionText,
      'questionType': questionType,
      'isMandatory': isMandatory,
      'applicableRole': applicableRole,
      'answer': answer,
      'displayOrder': displayOrder,
      'maxLength': maxLength,
      'visibleWhen': visibleWhen?.map((x) => x.toJson()).toList(),
      'dateFormat': dateFormat,
      'option': option?.map((x) => x.toJson()).toList(),
    };
  }
}

class FunctionalOption {
  final String? optionId;
  final String? optionValue;
  final int? displayOrder;

  FunctionalOption({this.optionId, this.optionValue, this.displayOrder});

  factory FunctionalOption.fromJson(Map<String, dynamic> json) {
    return FunctionalOption(
      optionId: json['optionId'],
      optionValue: json['optionValue'],
      displayOrder: json['displayOrder'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'optionId': optionId,
      'optionValue': optionValue,
      'displayOrder': displayOrder,
    };
  }
}

class VisibleWhen {
  final String? key;
  final dynamic value;

  VisibleWhen({this.key, this.value});

  factory VisibleWhen.fromJson(Map<String, dynamic> json) {
    return VisibleWhen(key: json['key'], value: json['value']);
  }

  Map<String, dynamic> toJson() {
    return {'key': key, 'value': value};
  }
}
