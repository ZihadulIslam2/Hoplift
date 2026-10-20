class GetMyBookingsReqParam {
  GetMyBookingsReqParam._({required this.bookingsType});
  
  final String bookingsType; // "completed" or "active"

  factory GetMyBookingsReqParam.active() {
    return GetMyBookingsReqParam._(bookingsType: "active");
  }

  factory GetMyBookingsReqParam.completed() {
    return GetMyBookingsReqParam._(bookingsType: "completed");
  }

  Map<String, dynamic> toJson() {
    return {
      "status": bookingsType,
    };
  }

}