import 'package:easy_localization/easy_localization.dart';

extension RideTimeStamp on DateTime {
  /// ex: 23 Feb 2025 at 10:00 AM
  String get dmyAth24 => "${DateFormat.yMMMd().format(this )} at ${DateFormat.Hm().format(this)}";
  String get dmyAthm => "${DateFormat.yMMMd().format(this )} at ${DateFormat.jm().format(this)}";
}