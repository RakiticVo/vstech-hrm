import 'package:equatable/equatable.dart';

/// Target distribution scope for internal announcements.
enum AnnouncementScope {
  all,
  company,
  office,
  factory,
  department;

  static AnnouncementScope fromString(String? val) {
    if (val == null) return AnnouncementScope.company;
    return switch (val.toLowerCase().trim()) {
      'all' => AnnouncementScope.all,
      'company' => AnnouncementScope.company,
      'office' => AnnouncementScope.office,
      'factory' => AnnouncementScope.factory,
      'department' => AnnouncementScope.department,
      _ => AnnouncementScope.company,
    };
  }
}

/// Domain entity representing an official announcement sent by HR/Admin.
class AnnouncementEntity extends Equatable {
  const new({
    required this.id,
    required this.title,
    required this.content,
    required this.publishedAt,
    required this.authorName,
    required this.authorRole,
    required this.scope,
    this.isRead = false,
    this.summary,
  });

  final String id;
  final String title;
  final String content;
  final DateTime publishedAt;
  final String authorName;
  final String authorRole;
  final AnnouncementScope scope;
  final bool isRead;
  final String? summary;

  AnnouncementEntity copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? publishedAt,
    String? authorName,
    String? authorRole,
    AnnouncementScope? scope,
    bool? isRead,
    String? summary,
  }) {
    return AnnouncementEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      publishedAt: publishedAt ?? this.publishedAt,
      authorName: authorName ?? this.authorName,
      authorRole: authorRole ?? this.authorRole,
      scope: scope ?? this.scope,
      isRead: isRead ?? this.isRead,
      summary: summary ?? this.summary,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        publishedAt,
        authorName,
        authorRole,
        scope,
        isRead,
        summary,
      ];
}
