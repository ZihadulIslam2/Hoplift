
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/common/widgets/textfields/location_textfield.dart';
import '../../../../core/common/widgets/textfields/location_textfield_type2.dart';
import '../../../../core/theme/app_gap.dart';
import '../../../location/model/location_address.dart';

class LocationInputs extends StatelessWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final Function(LocationAdress locationAddress) onSelectingFromLocation;
  final Function(LocationAdress locationAddress) onSelectingToLocation;
  const LocationInputs({
    super.key,
    required this.fromController,
    required this.toController,
    required this.onSelectingFromLocation,
    required this.onSelectingToLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Gap.h12,
            _buildCircleIcon(
              Image.asset('assets/images/down.png', width: 32, height: 32),
            ),
            _buildDashedLine(height: 40),
            _buildCircleIcon(
              Image.asset('assets/images/location.png', width: 32, height: 32),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            children: [
              LocationTextfieldType2(
                label: 'From'.tr(),
                hint: 'Enter your departure location'.tr(),
                onselect: (locationAddress)=> onSelectingFromLocation(locationAddress),
                controller: fromController,
              ),
              const SizedBox(height: 15),
              LocationTextfieldType2(
                label: 'To'.tr(),
                hint: 'Enter your arrival location'.tr(),
                onselect: (locationAddress)=> onSelectingToLocation(locationAddress),
                controller: toController,
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildCircleIcon(Image image) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F5),
        shape: BoxShape.circle,
      ),
      child: image,
    );
  }

  static Widget _buildDashedLine({required double height}) {
    return SizedBox(
      height: height,
      width: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final boxHeight = constraints.constrainHeight();
          const dashHeight = 4.0;
          final dashCount = (boxHeight / (2 * dashHeight)).floor();
          return Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                height: dashHeight,
                width: 1,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.grey),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  // static Widget _buildLocationField({
  //   required TextEditingController controller,
  //   required String label,
  //   required String hint,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(16),
  //       border: Border.all(color: Colors.grey.shade300),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           label,
  //           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
  //         ),
  //         const SizedBox(height: 4),
  //         TextField(
  //           controller: controller,
  //           decoration: InputDecoration(
  //             hintText: hint,
  //             hintStyle: TextStyle(color: Colors.grey.shade500),
  //             border: InputBorder.none,
  //             isDense: true,
  //             contentPadding: EdgeInsets.zero,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}
