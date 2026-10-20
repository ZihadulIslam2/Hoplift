// // file: reusable_text_field.dart
// import 'package:flutter/material.dart';

// class ReusableTextField extends StatelessWidget {
//   final String hintText;
//   final IconData prefixIcon;
//   final TextEditingController controller;
//   final bool obscureText;
//   final Widget? suffixIcon;
//   final String? Function(String?)? validator;

//   const ReusableTextField({
//     super.key,
//     required this.hintText,
//     required this.prefixIcon,
//     required this.controller,
//     this.obscureText = false,
//     this.suffixIcon,
//     this.validator,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: controller,
//       obscureText: obscureText,
//       validator: validator,
//       decoration: InputDecoration(
//         hintText: hintText,
//         prefixIcon: Icon(prefixIcon),
//         suffixIcon: suffixIcon,
//         border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';

// class ReusableTextField extends StatelessWidget {
//   final String hintText;
//   final IconData prefix;
//   final TextEditingController controller;
//   final bool obscureText;
//   final Widget? suffixIcon;
//   final String? Function(String?)? validator;

//   const ReusableTextField({
//     super.key,
//     required this.hintText,
//     required this.prefix,
//     required this.controller,
//     this.obscureText = false,
//     this.suffixIcon,
//     this.validator,
//   });
class ReusableTextField extends StatelessWidget {
  final String hintText;
  final IconData prefix;
  final bool obscureText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged; // ✅ Add this line

  const ReusableTextField({
    super.key,
    required this.hintText,
    required this.prefix,
    required this.obscureText,
    required this.controller,
    this.validator,
    this.suffixIcon,
    this.onChanged, // ✅ Include in constructor
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 53),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        onChanged: (value) {
          if (onChanged != null) {
            onChanged!(value);
          }
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: AppColors.secondaryText, fontSize: 14),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 16, right: 8),
            child: Icon(prefix, color: AppColors.secondaryText),
          ),
          // prefixIconConstraints: const BoxConstraints(
          //   minWidth: 0,
          //   minHeight: 0,
          // ),
          suffixIcon: suffixIcon,
          contentPadding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 0,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          errorStyle: TextStyle(
            color: AppColors.primarybutton,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
