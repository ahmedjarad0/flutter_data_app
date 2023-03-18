import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.hintText,
    required this.prefixIcon,
     this.suffixIcon,
    this.focusedBorder = Colors.grey,
    required this.controller ,
    this.obscure = false ,
  required  this.textInputType ,
    Key? key,
  }) : super(key: key);
  final String hintText;

  final IconData prefixIcon;

  final Widget? suffixIcon;
 final bool obscure ;
  final Color focusedBorder;
  final TextEditingController controller ;
  final TextInputType textInputType ;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText:obscure ,
      keyboardType: textInputType,
      style: GoogleFonts.cairo(fontSize: 14.sp),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: hintText,
          suffixIcon: suffixIcon,
          hintStyle: GoogleFonts.cairo(),
          prefixIcon: Icon(prefixIcon),
          enabledBorder: buildOutlineInputBorder(),
          focusedBorder: buildOutlineInputBorder(color: focusedBorder)),
    );
  }

  OutlineInputBorder buildOutlineInputBorder({Color color = Colors.grey}) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 1.3,
        color: color,
      ),
      borderRadius: BorderRadius.circular(10.r),
    );
  }
}
