import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpSection extends StatelessWidget {
  final int length;
  final double boxWidth;
  final double boxHeight;
  final double borderRadius;
  
  final TextStyle? textStyle;
  final Duration maskDuration;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const OtpSection({
    super.key,
    this.length = 4,
    this.boxWidth = 55,
    this.boxHeight = 60,
    this.borderRadius = 12,
    
    this.textStyle,
    this.maskDuration = const Duration(seconds: 1),
    this.onCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _MaskedOtpInternal(
      length: length,
      boxWidth: boxWidth,
      boxHeight: boxHeight,
      borderRadius: borderRadius,
      
      textStyle: textStyle,
      maskDuration: maskDuration,
      onCompleted: onCompleted,
      onChanged: onChanged,
    );
  }
}

class _MaskedOtpInternal extends StatefulWidget {
  final int length;
  final double boxWidth;
  final double boxHeight;
  final double borderRadius;
  
  final TextStyle? textStyle;
  final Duration maskDuration;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;

  const _MaskedOtpInternal({
    required this.length,
    required this.boxWidth,
    required this.boxHeight,
    required this.borderRadius,
    
    this.textStyle,
    required this.maskDuration,
    this.onCompleted,
    this.onChanged,
  });

  @override
  State<_MaskedOtpInternal> createState() =>
      __MaskedOtpInternalState();
}

class __MaskedOtpInternalState
    extends State<_MaskedOtpInternal> {
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;
  late List<bool> obscureFlags;
  Timer? _maskTimer;

  @override
  void initState() {
    super.initState();
    controllers =
        List.generate(widget.length, (_) => TextEditingController());
    focusNodes =
        List.generate(widget.length, (_) => FocusNode());
    obscureFlags =
        List.generate(widget.length, (_) => true);
  }

  String get otp =>
      controllers.map((e) => e.text).join();

  KeyEventResult _handleKeyEvent(
    KeyEvent event,
    int index,
  ) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        controllers[index].text.isEmpty &&
        index > 0) {
      controllers[index - 1].clear();
      focusNodes[index - 1].requestFocus();
      widget.onChanged?.call(otp);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  void _handleChange(String value, int index) {
    if (value.length > 1) {
      final digits = value.split('');
      for (int i = 0; i < widget.length; i++) {
        if (i < digits.length) {
          controllers[i].text = digits[i];
        }
      }
      focusNodes.last.unfocus();
      widget.onCompleted?.call(otp);
      widget.onChanged?.call(otp);
      return;
    }

    if (value.isEmpty) {
      if (index > 0) {
        controllers[index - 1].clear();
        focusNodes[index - 1].requestFocus();
      }
      widget.onChanged?.call(otp);
      return;
    }

    HapticFeedback.lightImpact();

    setState(() => obscureFlags[index] = false);

    _maskTimer?.cancel();
    _maskTimer = Timer(widget.maskDuration, () {
      setState(() => obscureFlags[index] = true);
    });

    if (index < widget.length - 1) {
      focusNodes[index + 1].requestFocus();
    } else {
      focusNodes[index].unfocus();
      widget.onCompleted?.call(otp);
    }

    widget.onChanged?.call(otp);
  }

  @override
  void dispose() {
    _maskTimer?.cancel();
    for (var c in controllers) {
      c.dispose();
    }
    for (var f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AutofillGroup(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.length,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Container(
              width: widget.boxWidth,
              height: widget.boxHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(widget.borderRadius),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Focus(
                onKeyEvent: (node, event) =>
                    _handleKeyEvent(event, index),
                child: TextField(
                  controller: controllers[index],
                  focusNode: focusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  obscureText: true,
                  style: widget.textStyle ??
                      const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  autofillHints: const [
                    AutofillHints.oneTimeCode
                  ],
                  inputFormatters:  [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: (value) =>
                      _handleChange(value, index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
