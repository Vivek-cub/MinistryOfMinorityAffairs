class UploadResponse {
  final String? statusCode;
  final String? statusMessage;
  final String? error;
  final UploadData? data;

  UploadResponse({this.statusCode, this.statusMessage, this.error, this.data});

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      statusCode: json['statusCode'],
      statusMessage: json['statusMessage'],
      error: json['error']?.toString(),
      data: json['data'] != null ? UploadData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusCode': statusCode,
      'statusMessage': statusMessage,
      'data': data?.toJson(),
      'error': error,
    };
  }
}

class UploadData {
  final String? message;
  final int? totalFiles;
  final List<UploadedFile>? data;

  UploadData({this.message, this.totalFiles, this.data});

  factory UploadData.fromJson(Map<String, dynamic> json) {
    return UploadData(
      message: json['message'],
      totalFiles: json['totalFiles'],
      data:
          json['data'] != null
              ? List<UploadedFile>.from(
                json['data'].map((x) => UploadedFile.fromJson(x)),
              )
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'totalFiles': totalFiles,
      'data': data?.map((x) => x.toJson()).toList(),
    };
  }
}

class UploadedFile {
  final String? id;
  final String? entityId;
  final String? path;
  final String? createdBy;
  final String? updatedBy;
  final String? remarks;
  final dynamic status;
  final String? progress;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? entityType;
  final String? attachmentType;
  final dynamic lat;
  final dynamic lng;
  final dynamic name;
  final dynamic sourceUrl;
  final Validation? validation;

  UploadedFile({
    this.id,
    this.entityId,
    this.path,
    this.createdBy,
    this.updatedBy,
    this.remarks,
    this.status,
    this.progress,
    this.createdAt,
    this.updatedAt,
    this.entityType,
    this.attachmentType,
    this.lat,
    this.lng,
    this.name,
    this.sourceUrl,
    this.validation,
  });

  factory UploadedFile.fromJson(Map<String, dynamic> json) {
    return UploadedFile(
      id: json['Id'],
      entityId: json['entityId'],
      path: json['path'],
      createdBy: json['createdBy'],
      updatedBy: json['updatedBy'],
      remarks: json['remarks'],
      status: json['status'],
      progress: json['progress'],
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
      entityType: json['entityType'],
      attachmentType: json['attachmentType'],
      lat: json['lat'],
      lng: json['lng'],
      name: json['name'],
      sourceUrl: json['sourceUrl'],
      validation:
          json['validation'] != null
              ? Validation.fromJson(json['validation'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'entityId': entityId,
      'path': path,
      'createdBy': createdBy,
      'updatedBy': updatedBy,
      'remarks': remarks,
      'status': status,
      'progress': progress,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'entityType': entityType,
      'attachmentType': attachmentType,
      'lat': lat,
      'lng': lng,
      'name': name,
      'sourceUrl': sourceUrl,
      'validation': validation?.toJson(),
    };
  }
}

class Validation {
  final String? attachmentId;
  final String? verdict;
  final bool? suspicious;
  final List<String>? reasonMessages;

  Validation({
    this.attachmentId,
    this.verdict,
    this.suspicious,
    this.reasonMessages,
  });

  factory Validation.fromJson(Map<String, dynamic> json) {
    return Validation(
      attachmentId: json['attachment_id'],
      verdict: json['verdict'],
      suspicious: json['suspicious'],
      reasonMessages:
          json['reason_messages'] != null
              ? List<String>.from(json['reason_messages'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'attachment_id': attachmentId,
      'verdict': verdict,
      'suspicious': suspicious,
      'reason_messages': reasonMessages,
    };
  }
}
