import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:ttrueno_fo827e642a0c4/core/theme/app_colors.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/ui/view/filter_rides_view.dart';

class FilterChipWidget extends StatelessWidget {
  FilterChipWidget({super.key, required this.label, required this.toolTip});

  final String label;
  final String toolTip;
  final Debouncer _debouncer = Debouncer(delay: Duration(milliseconds: 500));
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            _debouncer.call(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FilterRidesView()));
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              //border: Border.all(color: AppColors.primarybutton),
              color: Colors.grey.shade300,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                spacing: 4,
                children: [
                  Text(
                    label,
                    style: TextStyle(color: AppColors.secondaryText, fontSize: 14),
                  ),
                  Tooltip(
                    message: toolTip,
                    margin: EdgeInsets.all(8),
                    child: Icon(
                      Icons.info,
                      color: AppColors.secondaryText,
                      size: 16,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}
