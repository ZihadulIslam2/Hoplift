
import 'package:get/get.dart';
import 'package:ttrueno_fo827e642a0c4/modules/notification/controller/notification_controller.dart';

import '../../../../core/utils/extensions/textstyle_ext.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../screen/notification_screen.dart';

class NotificationBellWidget extends StatefulWidget {
  const NotificationBellWidget({
    super.key,
  });

  @override
  State<NotificationBellWidget> createState() => _NotificationBellWidgetState();
}

class _NotificationBellWidgetState extends State<NotificationBellWidget> {

  final notificationController = Get.find<NotificationController>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ObxValue(
          (countString) {
            return SizedBox(
              height: 50,
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> NotificationScreen()));
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.notifications_none,
                          size: 30.0,
                          color: AppColors.buttontext,
                        ),
                      ),
                      if(countString.value != null) Positioned(
                        left: 26,
                        top: 5,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            //border: Border.all(color: Colors.white)
                          ),
                          child: Text(
                            countString.value!,
                            style: TextStyle(
                              color: Colors.white
                            ).w600.small,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          notificationController.unreadCountString,
        );
      }
    );
  }
}