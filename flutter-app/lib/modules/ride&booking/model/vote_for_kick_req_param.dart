class VoteForKickReqParam {
  final String rideId;
  final String targetUserid;
  VoteForKickReqParam(this.rideId, this.targetUserid);

  Map<String, dynamic> toJson() {
    return {
      'rideId': rideId,
      'targetUserId': targetUserid,
    };
  }
}