import 'package:ttrueno_fo827e642a0c4/core/base/success.dart';
import 'package:ttrueno_fo827e642a0c4/core/base/base_repository.dart';
import 'package:ttrueno_fo827e642a0c4/core/utils/helpers/typedefs.dart';
import 'package:ttrueno_fo827e642a0c4/modules/ride&booking/model/booking.dart';

import '../model/get_my_bookings_req_param.dart';

abstract base class BookingInterface extends BaseRepository{
  FutureRequest<Success<List<Booking>>> getMyBookings(GetMyBookingsReqParam params);

  FutureRequest<Success<List<Booking>>> getAllBookingsForARide(String rideId);
}

