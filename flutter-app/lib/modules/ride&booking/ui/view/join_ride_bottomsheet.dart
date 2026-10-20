import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/reactive_buttons/r_icon.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/join_ride_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/enum/baggage_type_enum.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_gap.dart';

/// This screen/bottomsheet does not close or pop itself,
/// rather it uses the onJoinComplete callback and delegate that responsibility to the parent widget.
class JoinRideBottomsheet extends StatefulWidget {
  final int seatBooked;
  final JoinRideController joinRideController;
  const JoinRideBottomsheet({super.key, required this.joinRideController, required this.seatBooked});

  @override
  State<JoinRideBottomsheet> createState() => _JoinRideBottomsheetState();
}

class _JoinRideBottomsheetState extends State<JoinRideBottomsheet> {

  @override

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                        isSelected: widget.joinRideController.baggageType.value == baggageType,
                        label: baggageType.name.tr(),
                        onTap: () {
                          setState(() {
                            widget.joinRideController.baggageType.value = baggageType;
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
                      child: Text("Not Now".tr()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        widget.joinRideController.joinRide(seatBooked: widget.seatBooked, snackbarNotifier: SnackbarNotifier(context: context));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Row(
                        spacing: 4,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Join Ride".tr(),
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
                            processStatusNotifier: widget.joinRideController.stn,
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