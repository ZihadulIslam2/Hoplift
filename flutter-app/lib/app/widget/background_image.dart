
// import 'package:flutter/material.dart';

// class BackgroundWidget extends StatelessWidget {
//   final Widget child;
//   final String? customImage; // Optional image override
//   final Color? backgroundColor;

//   static Color primaryColor = Color(0xFF1269c7);

//   const BackgroundWidget({
//     super.key,
//     required this.child,
//     this.customImage,
//     this.backgroundColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     Widget background;

//     if (customImage != null) {
//       background = Image.asset(
//         customImage!,
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: double.infinity,
//       );
//     } else if (backgroundColor != null) {
//       background = Container(color: backgroundColor!);
//     } else {
//       // Default global image
//       // background = Image.asset(
//       //   'assets/images/mainbackground.png',
//       //   fit: BoxFit.cover,
//       //   width: double.infinity,
//       //   height: double.infinity,
//       // );
//       background = Image.asset(
//         'assets/images/background.jpg',
//         fit: BoxFit.cover,
//         width: double.infinity,
//         height: double.infinity,
//       );
//     }

//     return Stack(
//       children: [
//         Positioned.fill(child: background),
//         Positioned.fill(
//           child: Container(
//             color: Colors.black.withOpacity(0.2),
//           ), // Optional dark overlay
//         ),
//         child,
//       ],
//     );
//   }
// }


import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;
  final String? customImage; // Optional image override
  final Color? backgroundColor;

  static Color primaryColor = Color(0xFF1269c7);

  const BackgroundWidget({
    super.key,
    required this.child,
    this.customImage,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    Widget background;

    if (customImage != null) {
      background = Image.asset(
        customImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else if (backgroundColor != null) {
      background = Container(color: backgroundColor!);
    } else {
      background = Image.asset(
        'assets/images/background.jpg',
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Stack(
      children: [
        Positioned.fill(child: background),

        // ✅ Dark overlay
        if (customImage != null || backgroundColor == null)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        child,
      ],
    );
  }
}
