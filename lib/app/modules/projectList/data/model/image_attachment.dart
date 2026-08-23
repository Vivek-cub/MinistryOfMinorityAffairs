class ImageAttachment {
  final DateTime? date;
  final String? images;
  final String? uploadedBy;
  final String? progress;
  final String? status;

  ImageAttachment({
    this.date,
    this.images,
    this.uploadedBy,
    this.progress,
    this.status,
    // this.userRole
  });

  factory ImageAttachment.fromJson(Map<String, dynamic> json) {
    return ImageAttachment(
      date: _parseDate(json['createdAt']),
      images: _stringValue(json['path']),
      uploadedBy: _stringValue(json['uploadedBy']),
      progress: _stringValue(json['progress']),
      status: _stringValue(json['status']),
      // userRole: json['userRole'],
      // images: (json['path'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }

  static String? _stringValue(dynamic value) {
    if (value == null) return null;
    return value.toString();
  }
}
