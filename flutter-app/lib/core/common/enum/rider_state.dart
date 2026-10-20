enum RiderState {
  joined,
  left,
  kicked;

  static RiderState fromString(String value) {
    switch (value) {
      case "joined":
        return RiderState.joined;
      case "left":
        return RiderState.left;
      case "kicked":
        return RiderState.kicked;
      default:
        return RiderState.joined;
    }
  }
}