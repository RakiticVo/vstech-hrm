import 'package:vstech_hrm/features/announcements/domain/entities/announcement_entity.dart';

/// Data Transfer Object for internal announcements.
class AnnouncementModel {
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

  factory fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      authorName: json['authorName'] as String,
      authorRole: json['authorRole'] as String,
      scope: AnnouncementScope.fromString(json['scope'] as String?),
      isRead: json['isRead'] as bool? ?? false,
      summary: json['summary'] as String?,
    );
  }

  factory fromEntity(AnnouncementEntity entity) {
    return AnnouncementModel(
      id: entity.id,
      title: entity.title,
      content: entity.content,
      publishedAt: entity.publishedAt,
      authorName: entity.authorName,
      authorRole: entity.authorRole,
      scope: entity.scope,
      isRead: entity.isRead,
      summary: entity.summary,
    );
  }

  final String id;
  final String title;
  final String content;
  final DateTime publishedAt;
  final String authorName;
  final String authorRole;
  final AnnouncementScope scope;
  final bool isRead;
  final String? summary;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'publishedAt': publishedAt.toIso8601String(),
        'authorName': authorName,
        'authorRole': authorRole,
        'scope': scope.name,
        'isRead': isRead,
        if (summary != null) 'summary': summary,
      };

  AnnouncementEntity toEntity() => AnnouncementEntity(
        id: id,
        title: title,
        content: content,
        publishedAt: publishedAt,
        authorName: authorName,
        authorRole: authorRole,
        scope: scope,
        isRead: isRead,
        summary: summary,
      );
}
