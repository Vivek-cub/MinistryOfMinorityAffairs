class ProposalListData {
  final String? id;
  final String? projectUniqueId;
  final String? districtId;
  final String? sectorId;
  final String? projectTypeId;
  ProposalListData({
    this.id,
    this.projectUniqueId,
    this.districtId,
    this.sectorId,
    this.projectTypeId,
  });

  factory ProposalListData.fromJson(Map<String, dynamic> json) {
    return ProposalListData(
      id: json['Id'],
      projectUniqueId: json['projectUniqueId'],
      districtId: json['districtId'],
      sectorId: json['sectorId'],
      projectTypeId: json['projectTypeId'],
    );
  }
}
