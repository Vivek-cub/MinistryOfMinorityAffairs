class ImageAttachment {
  final DateTime? date;
  final String? images;
  // final String? userRole;

  ImageAttachment({
    this.date,
    this.images,
    // this.userRole
  });

  factory ImageAttachment.fromJson(Map<String, dynamic> json) {
    return ImageAttachment(
      date: _parseDate(json['createdAt']),
      images: json['path'],
      // userRole: json['userRole'],
      // images: (json['path'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
