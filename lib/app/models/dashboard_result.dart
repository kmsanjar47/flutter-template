class DashboardResult {
  final int totalPending;
  final int totalArchived;
  final int totalDeclined;
  final int totalSubmitted;
  final int totalApplication;

  DashboardResult({
    this.totalPending = 0,
    this.totalArchived = 0,
    this.totalDeclined = 0,
    this.totalSubmitted = 0,
    this.totalApplication = 0,
  });

  factory DashboardResult.fromJson(Map<String, dynamic> json) {
    return DashboardResult(
      totalPending: json['total_pending'] ?? 0,
      totalArchived: json['total_archived'] ?? 0,
      totalDeclined: json['total_declined'] ?? 0,
      totalSubmitted: json['total_submitted'] ?? 0,
      totalApplication: json['total_application'] ?? 0,
    );
  }
}
