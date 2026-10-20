// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import '../../../../core/theme/app_colors.dart';
// import '../../../../core/theme/app_gap.dart';
// import '../widget/custom_thumb_shap.dart';

// class DepartureFlexibilityScreen extends StatefulWidget {
//   const DepartureFlexibilityScreen({super.key});

//   @override
//   State<DepartureFlexibilityScreen> createState() => _DepartureFlexibilityScreenState();
// }

// class _DepartureFlexibilityScreenState extends State<DepartureFlexibilityScreen> {
//   double departureSliderValue = 0.2;

//   final List<double> allowedDistances = [
//     0.1, 0.2, 0.3, 0.5, 1, 2, 3, 5, 10
//   ];

//   double _sliderToDistance(double value) {
//     int index = (value * (allowedDistances.length - 1)).round();
//     return allowedDistances[index];
//   }

//   double _snapSlider(double value) {
//     int index = (value * (allowedDistances.length - 1)).round();
//     return index / (allowedDistances.length - 1);
//   }

//   String _formatDistance(double km) {
//     if (km < 1) return "${(km * 1000).round()} m";
//     return "${km.toStringAsFixed(0)} km";
//   }

//   @override
//   Widget build(BuildContext context) {
//     double currentKm = _sliderToDistance(departureSliderValue);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Departure Flexibility".tr()),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 trackHeight: 8,
//                 activeTrackColor: AppColors.primarybutton,
//                 inactiveTrackColor: AppColors.progressBg,
//                 thumbColor: Colors.white,
//                 thumbShape: CustomThumbShape(),
//               ),
//               child: Slider(
//                 value: departureSliderValue,
//                 min: 0,
//                 max: 1,
//                 onChanged: (v) {
//                   setState(() {
//                     departureSliderValue = _snapSlider(v);
//                   });
//                 },
//               ),
//             ),
//             Gap.h16,
//             Text(
//               _formatDistance(currentKm),
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primarybutton,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.pop(context, currentKm);
//               },
//               child: Text("Apply".tr()),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


// class ArrivalFlexibilityScreen extends StatefulWidget {
//   const ArrivalFlexibilityScreen({super.key});

//   @override
//   State<ArrivalFlexibilityScreen> createState() => _ArrivalFlexibilityScreenState();
// }

// class _ArrivalFlexibilityScreenState extends State<ArrivalFlexibilityScreen> {
//   double arrivalFlex = 30;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Arrival Flexibility".tr()),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           children: [
//             SliderTheme(
//               data: SliderTheme.of(context).copyWith(
//                 trackHeight: 8,
//                 activeTrackColor: AppColors.primarybutton,
//                 inactiveTrackColor: AppColors.progressBg,
//                 thumbColor: Colors.white,
//                 thumbShape: CustomThumbShape(),
//               ),
//               child: Slider(
//                 value: arrivalFlex,
//                 min: 0,
//                 max: 60,
//                 divisions: 60,
//                 label: "${arrivalFlex.round()} min",
//                 onChanged: (value) {
//                   setState(() => arrivalFlex = value);
//                 },
//               ),
//             ),
//             Gap.h16,
//             Text(
//               "${arrivalFlex.round()} min",
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//             ),
//             const Spacer(),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primarybutton,
//                 foregroundColor: Colors.white,
//                 minimumSize: const Size(double.infinity, 50),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//               ),
//               onPressed: () {
//                 Navigator.pop(context, arrivalFlex);
//               },
//               child: Text("Apply".tr()),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
