class ImageAttachment {
  final DateTime? date;
  final String? images;
  final String? uploadedBy;

  ImageAttachment({
    this.date,
    this.images,
    this.uploadedBy,
    // this.userRole
  });

  factory ImageAttachment.fromJson(Map<String, dynamic> json) {
    return ImageAttachment(
      date: _parseDate(json['createdAt']),
      images: json['path'],
      uploadedBy: json['uploadedBy'],
      // userRole: json['userRole'],
      // images: (json['path'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
