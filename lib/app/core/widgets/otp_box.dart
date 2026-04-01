import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ministry_of_minority_affairs/app/core/theme/theme_constants.dart';

class OtpBox extends StatelessWidget {
  int index;
  List<TextEditingController> otpControllers;
  List<FocusNode> focusNodes;
  final Function(String value)? onChanged;
  VoidCallback? onTap;
  OtpBox({super.key,required this.index,required this.otpControllers, required this.focusNodes,this.onChanged,this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: KeyboardListener(
        focusNode: focusNodes[index],
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              otpControllers[index].text.isEmpty &&
              index > 0) {
            otpControllers[index - 1].clear();
            focusNodes[index - 1].requestFocus();
          }
        },
        child: TextField(
          controller: otpControllers[index],
          focusNode: FocusNode(),
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          obscureText: true,
          maxLength: 1,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            counterText: '',
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(1),
          ],
          onChanged: (value) { 
            if (value.isNotEmpty && index < otpControllers.length - 1) {
              focusNodes[index + 1].requestFocus();
            }
            onChanged?.call(value);
           
          },
          onTap: () {
            otpControllers[index].clear();
            onTap?.call();
          },
        ),
      ),
    );
  }

  
}