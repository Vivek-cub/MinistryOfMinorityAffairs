import 'package:flutter_test/flutter_test.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/controller/functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/mixin/condition_evaluator.dart';

import '../../../helpers/functional_test_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConditionEvaluator', () {
    late FunctionalController controller;

    setUp(() {
      controller = buildFunctionalController();
    });

    test('normalizes common yes/no and boolean values', () {
      expect(ConditionEvaluator.normalize(' YES '), isTrue);
      expect(ConditionEvaluator.normalize('no'), isFalse);
      expect(ConditionEvaluator.normalize(' True '), isTrue);
      expect(ConditionEvaluator.normalize('false'), isFalse);
      expect(ConditionEvaluator.normalize('  Mixed Case  '), 'mixed case');
      expect(ConditionEvaluator.normalize(12), 12);
      expect(ConditionEvaluator.normalize(null), isNull);
    });

    test('shows questions without visibleWhen rules', () {
      final question = FunctionalQuestion(
        questionId: 'q1',
        questionType: 'TEXT',
      );

      expect(ConditionEvaluator.isVisible(question, controller), isTrue);
    });

    test('matches string conditions after normalization', () {
      controller.dynamicFormValue['q1'] = ' yes ';
      final question = FunctionalQuestion(
        questionId: 'q2',
        questionType: 'TEXT',
        visibleWhen: [VisibleWhen(key: 'q1', value: true)],
      );

      expect(ConditionEvaluator.isVisible(question, controller), isTrue);
    });

    test('supports list based expected values', () {
      controller.dynamicFormValue['status'] = 'completed';
      final question = FunctionalQuestion(
        questionId: 'remarks',
        questionType: 'TEXT',
        visibleWhen: [
          VisibleWhen(key: 'status', value: ['pending', 'completed']),
        ],
      );

      expect(ConditionEvaluator.isVisible(question, controller), isTrue);
    });

    test('hides a child when its parent condition no longer matches', () {
      final parent = FunctionalQuestion(
        questionId: 'parent',
        questionType: 'YES_NO',
        visibleWhen: [VisibleWhen(key: 'root', value: 'YES')],
      );
      final child = FunctionalQuestion(
        questionId: 'child',
        questionType: 'TEXT',
        visibleWhen: [VisibleWhen(key: 'parent', value: 'YES')],
      );

      controller.dynamicFormConfig
        ..clear()
        ..addAll([parent, child]);
      controller.dynamicFormValue['root'] = 'NO';
      controller.dynamicFormValue['parent'] = 'YES';

      expect(ConditionEvaluator.isVisible(child, controller), isFalse);
    });
  });

  group('FunctionalController questionnaire helpers', () {
    late FunctionalController controller;

    setUp(() {
      controller = buildFunctionalController();
    });

    test('prepareAssessment maps visible answers to API payload shape', () {
      controller.dynamicFormValue['q1'] = true;
      controller.dynamicFormValue['show_child'] = 'YES';
      controller.dynamicFormConfig
        ..clear()
        ..addAll([
          FunctionalQuestion(
            questionId: 'heading',
            questionType: 'HEADING',
            answer: 'Section title',
          ),
          FunctionalQuestion(
            questionId: 'q1',
            questionType: 'YES_NO',
            answer: true,
          ),
          FunctionalQuestion(
            questionId: 'q2',
            questionType: 'INTEGER',
            answer: '42',
          ),
          FunctionalQuestion(
            questionId: 'q3',
            questionType: 'DATE',
            answer: DateTime(2026, 10, 14),
            dateFormat: 'dd-MM-yyyy',
          ),
          FunctionalQuestion(
            questionId: 'q4',
            questionType: 'IMAGE',
            answer: 'https://example.com/photo.jpg',
          ),
          FunctionalQuestion(
            questionId: 'q5',
            questionType: 'VIDEO',
            answer: '/tmp/capture.mp4',
          ),
          FunctionalQuestion(
            questionId: 'q6',
            questionType: 'TEXT',
            answer: 'Visible child',
            visibleWhen: [VisibleWhen(key: 'show_child', value: 'YES')],
          ),
        ]);

      expect(controller.prepareAssessment(), [
        {'questionId': 'q1', 'answer': 'YES'},
        {'questionId': 'q2', 'answer': 42},
        {'questionId': 'q3', 'answer': '14-10-2026'},
        {'questionId': 'q4', 'answer': 'https://example.com/photo.jpg'},
        {'questionId': 'q5', 'answer': '__FILE__'},
        {'questionId': 'q6', 'answer': 'Visible child'},
      ]);
    });

    test('prepareAssessment skips hidden, null, and blank answers', () {
      controller.dynamicFormValue['toggle'] = 'NO';
      controller.dynamicFormConfig
        ..clear()
        ..addAll([
          FunctionalQuestion(
            questionId: 'visible_blank',
            questionType: 'TEXT',
            answer: '   ',
          ),
          FunctionalQuestion(questionId: 'visible_null', questionType: 'TEXT'),
          FunctionalQuestion(
            questionId: 'hidden',
            questionType: 'TEXT',
            answer: 'Should not be submitted',
            visibleWhen: [VisibleWhen(key: 'toggle', value: 'YES')],
          ),
        ]);

      expect(controller.prepareAssessment(), isEmpty);
    });

    test(
      'selectFunctionalProject(false) clears form values and video path',
      () {
        controller.dynamicFormValue['q1'] = 'answer';
        controller.initialValue['question_q1'] = 'answer';
        controller.videoPath.value = '/tmp/video.mp4';

        controller.selectFunctionalProject(false);

        expect(controller.isFunctionalProject.value, isFalse);
        expect(controller.dynamicFormValue, isEmpty);
        expect(controller.initialValue, isEmpty);
        expect(controller.displayedVideoPath, isNull);
      },
    );
  });
}
