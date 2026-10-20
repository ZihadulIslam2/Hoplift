import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/reactive_buttons/r_icon.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/change_baggage_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_gap.dart';

/// This screen/bottomsheet does not close or pop itself,
/// rather it uses the onJoinComplete callback and delegate that responsibility to the parent widget.
class ChangeBaggageBottomSheet extends StatefulWidget {
  final BaggageType initialBaggageType;
  final String riderId;
  final ChangeBaggageController changeBaggageController;
  const ChangeBaggageBottomSheet({super.key, required this.changeBaggageController, required this.riderId, required this.initialBaggageType});

  @override
  State<ChangeBaggageBottomSheet> createState() => _ChangeBaggageBottomSheetState();
}

class _ChangeBaggageBottomSheetState extends State<ChangeBaggageBottomSheet> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("selectedBaggageType: ${widget.changeBaggageController.baggageType.value}"); 
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Baggage Type".tr(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Gap.h16,
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ...BaggageType.values.map((baggageType) {
                      return _buildBaggageImageIcon(
                        imagePath: baggageType.assetImagePath(),
                        isSelected: widget.changeBaggageController.baggageType.value == baggageType,
                        label: baggageType.name.tr(),
                        onTap: () {
                          setState(() {
                            widget.changeBaggageController.baggageType.value = baggageType;
                          });
                        },
                      );
                    })
                  ],
                ),
              Gap.h24,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, null),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: AppColors.primarybutton,
                          width: 1.5,
                        ),
                      ),
                      child: Text("Cancel".tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.changeBaggageController.changeBaggage(
                          snackbarNotifier: SnackbarNotifier(context: context),
                          riderId: widget.riderId,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Change".tr(),
                            style: TextStyle(color: Colors.white),
                          ),
                          RIcon(
                            key: UniqueKey(),
                            iconWidget: Container(),
                            disableStateWidget: Container(),
                            loadingStateWidget: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                            processStatusNotifier: widget.changeBaggageController.stn,
                            onDone: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

   Widget _buildBaggageImageIcon({
    required String imagePath,
    required bool isSelected,
    required VoidCallback onTap,
    required String label,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            imagePath,
            width: 28,
            height: 28,
            color: isSelected ? AppColors.primarybutton : Colors.grey,
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? AppColors.primarybutton
                  : AppColors.primaryTextblack,
            ),
          ),
        ],
      ),
    );
  }

}