enum Status {
  pending,
  active,
  completed,
  cancelled;

  factory Status.fromString(String value) {
    value = value.toLowerCase();
    switch (value) {
      case 'pending':
        return Status.pending;
      case 'active':
        return Status.active;
      case 'completed':
        return Status.completed;
      case 'cancelled':
        return Status.cancelled;
      default:
        throw ArgumentError('Invalid status string: $value');
    }
  }
}