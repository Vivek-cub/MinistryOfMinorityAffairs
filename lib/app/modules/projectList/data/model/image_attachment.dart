class ImageAttachment {
  final DateTime? date;
  final String? images;

  ImageAttachment({this.date, this.images});

  factory ImageAttachment.fromJson(Map<String, dynamic> json) {
    return ImageAttachment(
      date: _parseDate(json['createdAt']),
      images: json['path'],
      // images: (json['path'] as List?)?.map((e) => e.toString()).toList(),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    return DateTime.tryParse(value.toString());
  }
}
