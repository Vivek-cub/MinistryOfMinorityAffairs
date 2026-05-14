class AudioAttachment {
  final String? date;
  final List<String>? audios;

  AudioAttachment({this.date, this.audios});

  factory AudioAttachment.fromJson(Map<String, dynamic> json) {
    return AudioAttachment(
      date: json['date'],
      audios: (json['audios'] as List?)?.map((e) => e.toString()).toList(),
    );
  }
}
