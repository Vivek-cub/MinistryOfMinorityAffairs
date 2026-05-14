class ImageAttachment {
  final String? date;
  final List<String>? images;

  ImageAttachment({this.date, this.images});

  factory ImageAttachment.fromJson(Map<String, dynamic> json) {
    return ImageAttachment(
      date: json['date'],
      images: (json['images'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
