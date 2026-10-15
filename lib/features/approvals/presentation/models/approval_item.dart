/// Presentation model representing an item in the manager approval queue.
class ApprovalItem {
  const new({
    required this.initials,
    required this.name,
    required this.type,
    required this.dates,
    this.reason,
    this.id,
    this.category = 'leave',
    this.attendanceSnippet,
    this.swapBothSchedules,
    this.internalNote,
    this.worktime,
    this.employeeCode,
    this.department,
    this.status = 0,
    this.statusText = 'Chờ duyệt',
    this.isLock = false,
  });

  final String? id;
  final String initials;
  final String name;
  final String type;
  final String dates;
  final String? reason;
  final String category;
  final String? attendanceSnippet;
  final String? swapBothSchedules;
  final String? internalNote;
  final double? worktime;
  final String? employeeCode;
  final String? department;
  final int status;
  final String statusText;
  final bool isLock;

  bool get isPending => status == 0;
  bool get isApproved => status == 1;
  bool get isRejected => status == 2;

  ApprovalItem copyWith({
    String? id,
    String? initials,
    String? name,
    String? type,
    String? dates,
    String? reason,
    String? category,
    String? attendanceSnippet,
    String? swapBothSchedules,
    String? internalNote,
    double? worktime,
    String? employeeCode,
    String? department,
    int? status,
    String? statusText,
  }) {
    return ApprovalItem(
      id: id ?? this.id,
      initials: initials ?? this.initials,
      name: name ?? this.name,
      type: type ?? this.type,
      dates: dates ?? this.dates,
      reason: reason ?? this.reason,
      category: category ?? this.category,
      attendanceSnippet: attendanceSnippet ?? this.attendanceSnippet,
      swapBothSchedules: swapBothSchedules ?? this.swapBothSchedules,
      internalNote: internalNote ?? this.internalNote,
      worktime: worktime ?? this.worktime,
      employeeCode: employeeCode ?? this.employeeCode,
      department: department ?? this.department,
      status: status ?? this.status,
      statusText: statusText ?? this.statusText,
    );
  }
}
