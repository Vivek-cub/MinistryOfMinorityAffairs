import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/controller/functional_controller.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/data/model/functional_response_model.dart';
import 'package:ministry_of_minority_affairs/app/modules/functional/view/functional_screen.dart';
import 'package:ministry_of_minority_affairs/app/modules/functionalProjects/widget/switch_form_field_widgets.dart';

import '../../../helpers/functional_test_fakes.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('SwitchFormFieldWidgets', () {
    testWidgets('validates required text question and stores user input', (
      tester,
    ) async {
      final controller = buildFunctionalController();
      final formKey = GlobalKey<FormBuilderState>();

      await tester.pumpWidget(
        _wrapWithApp(
          FormBuilder(
            key: formKey,
            child: SwitchFormFieldWidgets(
              question: FunctionalQuestion(
                questionId: 'remarks',
                questionText: 'Inspection remarks',
                questionType: 'TEXT',
                isMandatory: true,
              ),
              controller: controller,
            ),
          ),
        ),
      );

      expect(
        find.textContaining('Inspection remarks', findRichText: true),
        findsOneWidget,
      );

      expect(formKey.currentState!.saveAndValidate(), isFalse);
      await tester.pump();
      expect(find.text('This field is required'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'Work is complete');
      await tester.pump();

      expect(controller.dynamicFormValue['remarks'], 'Work is complete');
      expect(formKey.currentState!.saveAndValidate(), isTrue);
    });

    testWidgets('validates integer question accepts numbers only', (
      tester,
    ) async {
      final controller = buildFunctionalController();
      final formKey = GlobalKey<FormBuilderState>();

      await tester.pumpWidget(
        _wrapWithApp(
          FormBuilder(
            key: formKey,
            child: SwitchFormFieldWidgets(
              question: FunctionalQuestion(
                questionId: 'count',
                questionText: 'Beneficiary count',
                questionType: 'INTEGER',
                isMandatory: true,
              ),
              controller: controller,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'ten');
      expect(formKey.currentState!.saveAndValidate(), isFalse);
      await tester.pump();
      expect(find.text('Please enter a valid number'), findsOneWidget);

      await tester.enterText(find.byType(TextField), '10');
      await tester.pump();

      expect(controller.dynamicFormValue['count'], '10');
      expect(formKey.currentState!.saveAndValidate(), isTrue);
    });

    testWidgets('updates visibility when parent answer changes', (
      tester,
    ) async {
      final controller = buildFunctionalController();
      final formKey = GlobalKey<FormBuilderState>();
      final parent = FunctionalQuestion(
        questionId: 'functional',
        questionText: 'Functional?',
        questionType: 'YES_NO',
        isMandatory: true,
      );
      final child = FunctionalQuestion(
        questionId: 'remarks',
        questionText: 'Functional remarks',
        questionType: 'TEXT',
        visibleWhen: [VisibleWhen(key: 'functional', value: true)],
      );

      await tester.pumpWidget(
        _wrapWithApp(
          FormBuilder(
            key: formKey,
            child: Column(
              children: [
                SwitchFormFieldWidgets(
                  question: parent,
                  controller: controller,
                ),
                SwitchFormFieldWidgets(question: child, controller: controller),
              ],
            ),
          ),
        ),
      );

      expect(
        find.textContaining('Functional remarks', findRichText: true),
        findsNothing,
      );

      await tester.tap(find.text('Yes'));
      await tester.pump();

      expect(controller.dynamicFormValue['functional'], isTrue);
      expect(
        find.textContaining('Functional remarks', findRichText: true),
        findsOneWidget,
      );

      await tester.tap(find.text('No'));
      await tester.pump();

      expect(controller.dynamicFormValue['functional'], isFalse);
      expect(
        find.textContaining('Functional remarks', findRichText: true),
        findsNothing,
      );
    });
  });

  group('FunctionalScreen', () {
    testWidgets(
      'shows questionnaire loader for functional project while loading',
      (tester) async {
        final controller = _registerFunctionalController();
        controller.isFunctionalProject.value = true;
        controller.isFormLoading.value = true;

        await tester.pumpWidget(_wrapWithApp(const FunctionalScreen()));

        expect(find.text('Is this Project Functional?'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Submit'), findsOneWidget);
      },
    );

    testWidgets('renders loaded questionnaire field and capture prompt', (
      tester,
    ) async {
      final controller = _registerFunctionalController();
      controller.isFunctionalProject.value = true;
      controller.isFormLoading.value = false;
      controller.dynamicFormConfig.add(
        FunctionalQuestion(
          questionId: 'remarks',
          questionText: 'Inspection remarks',
          questionType: 'TEXT',
        ),
      );

      await tester.pumpWidget(_wrapWithApp(const FunctionalScreen()));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        find.textContaining('Inspection remarks', findRichText: true),
        findsOneWidget,
      );
      expect(find.text('Project Completion Video'), findsOneWidget);
      expect(find.text('Tap to capture video'), findsOneWidget);
    });
  });
}

Widget _wrapWithApp(Widget child) {
  return GetMaterialApp(home: Scaffold(body: child));
}

FunctionalController _registerFunctionalController() {
  final controller = buildFunctionalController();
  Get.put<FunctionalController>(controller);
  return controller;
}
