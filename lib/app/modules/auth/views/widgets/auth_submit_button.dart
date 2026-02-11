import 'package:flutter/material.dart';

class AuthSubmitButton extends StatelessWidget {
  final String title;
   bool isEnabled;
   VoidCallback? onPressed;
   double height;
   AuthSubmitButton({super.key,required this.title,this.isEnabled=false,this.onPressed,this.height=56});

  @override
  Widget build(BuildContext context) {
   return Container(
      width: double.infinity,
      height: height,
     // margin: EdgeInsets.symmetric(horizontal: AppDimensions.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isEnabled
              ? const LinearGradient(
                  colors: [
                    Color(0xFFFFB84D),
                    Color(0xFFFF6B6B),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isEnabled ? null : const Color(0xFFCCCCCC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
 
  
  }
}