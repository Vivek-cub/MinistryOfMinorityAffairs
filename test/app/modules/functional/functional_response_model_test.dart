import 'package:flutter_test/flutter_test.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';

void main() {
  group('FunctionalResponseModel', () {
    test('parses questionnaire response with options and visibility rules', () {
      final model = FunctionalResponseModel.fromJson({
        'success': true,
        'message': 'Loaded',
        'error': null,
        'data': [
          {
            'questionId': 'q1',
            'questionText': 'Is the project functional?',
            'questionType': 'YES_NO',
            'isMandatory': true,
            'applicableRole': 'fieldOfficer',
            'answer': 'YES',
            'displayOrder': 1,
            'maxLength': null,
            'visibleWhen': [],
            'dateFormat': null,
            'option': [
              {'optionId': 'yes', 'optionValue': 'YES', 'displayOrder': 1},
              {'optionId': 'no', 'optionValue': 'NO', 'displayOrder': 2},
            ],
          },
          {
            'questionId': 'q2',
            'questionText': 'Remarks',
            'questionType': 'TEXT',
            'isMandatory': false,
            'applicableRole': 'fieldOfficer',
            'answer': 'Ready',
            'displayOrder': 2,
            'maxLength': 120,
            'visibleWhen': [
              {'key': 'q1', 'value': 'YES'},
            ],
            'dateFormat': null,
            'option': [],
          },
        ],
      });

      expect(model.success, isTrue);
      expect(model.message, 'Loaded');
      expect(model.data, hasLength(2));

      final first = model.data!.first;
      expect(first.questionId, 'q1');
      expect(first.option, hasLength(2));
      expect(first.option!.last.optionValue, 'NO');

      final second = model.data!.last;
      expect(second.visibleWhen, hasLength(1));
      expect(second.visibleWhen!.single.key, 'q1');
      expect(second.visibleWhen!.single.value, 'YES');
      expect(second.maxLength, 120);
    });

    test('serializes model back to json without dropping nested data', () {
      final model = FunctionalResponseModel(
        success: true,
        message: 'Saved',
        data: [
          FunctionalQuestion(
            questionId: '10',
            questionText: 'Upload image',
            questionType: 'IMAGE',
            isMandatory: true,
            answer: 'https://example.com/image.jpg',
            visibleWhen: [VisibleWhen(key: '9', value: true)],
            option: [
              FunctionalOption(
                optionId: '1',
                optionValue: 'Option A',
                displayOrder: 1,
              ),
            ],
          ),
        ],
      );

      final json = model.toJson();

      expect(json['success'], isTrue);
      expect(json['message'], 'Saved');
      expect(json['data'], isA<List>());
      expect(json['data'].single['questionId'], '10');
      expect(json['data'].single['visibleWhen'].single['key'], '9');
      expect(json['data'].single['option'].single['optionValue'], 'Option A');
    });

    test('uses empty lists when optional nested arrays are missing', () {
      final model = FunctionalResponseModel.fromJson({
        'success': true,
        'data': [
          {'questionId': 'q1', 'questionType': 'TEXT'},
        ],
      });

      expect(model.data, hasLength(1));
      expect(model.data!.single.visibleWhen, isEmpty);
      expect(model.data!.single.option, isEmpty);
    });
  });
}
