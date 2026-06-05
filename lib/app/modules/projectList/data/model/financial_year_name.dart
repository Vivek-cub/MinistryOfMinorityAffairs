class FinancialYearName {
  final String? id;
  final String? value;
  final int? startYear;
  final int? endYear;
  final bool? isActive;
  final dynamic sortOrder;
  final String? createdAt;
  final String? updatedAt;

  FinancialYearName({
    this.id,
    this.value,
    this.startYear,
    this.endYear,
    this.isActive,
    this.sortOrder,
    this.createdAt,
    this.updatedAt,
  });

  factory FinancialYearName.fromJson(Map<String, dynamic> json) {
    return FinancialYearName(
      id: json['Id'],
      value: json['value'],
      startYear: json['startYear'],
      endYear: json['endYear'],
      isActive: json['isActive'],
      sortOrder: json['sortOrder'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'value': value,
      'startYear': startYear,
      'endYear': endYear,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
