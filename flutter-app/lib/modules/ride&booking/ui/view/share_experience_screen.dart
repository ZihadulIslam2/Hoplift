import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/cache/smart_network_image.dart';
import 'package:ttrueno_fo827e642a0c4/core/common/widgets/car_divider_widget.dart';
import 'package:ttrueno_fo827e642a0c4/core/notifiers/snackbar_notifier.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/text_style.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/extensions/datetime_ext.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/controller/rate_ride_controller.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/ride_model.dart';

import '../../../../core/theme/app_gap.dart';

class ShareExperienceScreen extends StatefulWidget {
  final RideModel ride;
  const ShareExperienceScreen({super.key, required this.ride});

  @override
  State<ShareExperienceScreen> createState() => _ShareExperienceScreenState();
}

class _ShareExperienceScreenState extends State<ShareExperienceScreen> {

  late final RateRideController rateRideController;

  void handleSubmit() {
    rateRideController.submitRatings(snackbarNotifier: SnackbarNotifier(context: context));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    rateRideController = RateRideController(ride: widget.ride);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: Text("Share Experience".tr()),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            rideInfoCard(),
            Gap.h20,
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Share your experience with your follow passengers".tr(),
                style: AppText.lgMedium_18_400.copyWith(
                  color: AppColors.primaryTextblack,
                ),
              ),
            ),
            Gap.h16,
            Expanded(
              child: ListView.separated(
                itemCount: rateRideController.riders.length,
                separatorBuilder: (_, __) => Gap.h12,
                itemBuilder: (context, index) {
                  final rider = rateRideController.riders[index];
                  final name = rider.name;
                  final ratingValue = rider.avgRating;
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          SmartNetworkImage.circle(
                            diameter: 24 * 2,
                            imageUrl: rider.profileImage,
                          ),
                          // CircleAvatar(
                          //   radius: 24,
                          //   backgroundImage: AssetImage(rider.profileImage),
                          // ),
                          Gap.h4,
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Gap.h4,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.amber,
                              ),
                              Gap.w4,
                              Text(
                                ratingValue.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Gap.h4,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                rider.baggageType.assetImagePath(),
                                width: 14,
                                height: 14,
                                color: AppColors.primaryTextblack,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: RatingBar.builder(
                          initialRating: rider.avgRating.toDouble(),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: false,
                          itemCount: 5,
                          itemSize: 24,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: Colors.amber),
                          onRatingUpdate: (rating) {
                            /// TODO::
                            setState(() {
                              rateRideController.rateRider(rider.userId, rating);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Gap.h16,
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primarybutton,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: handleSubmit,
                child: Text(
                  "Submit".tr(),
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rideInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primarybutton,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.ride.departureTime.dmyAth24,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Gap.h12,
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "From\n".tr(),
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextSpan(
                        text: widget.ride.startLocation.address ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "To\n".tr(),
                          style: TextStyle(color: Colors.grey),
                        ),
                        TextSpan(
                          text: widget.ride.endLocation.address ?? "",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
          CarDivider(),
        ],
      ),
    );
  }
}
