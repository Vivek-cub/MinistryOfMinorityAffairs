class DetailedProject {
  final String id;
  final String? projectUniqueId;
  final String? districtId;
  final String? blockId;
  final String? stateId;
  final String? sectorId;
  final String? projectTypeId;
  final String? projectSchemeId;
  final List<dynamic>? majorInitiativeTypeIds;
  final String? sharingRatioId;
  final String? projectTenureFromFYID;
  final String? projectTenureTillFY;
  final String? pqProjectTypeId;
  final String? projectSubTypeId;
  final String? contractorId;
  final String? status;
  final String? infrastructureType;
  final String? projectClassification;
  final dynamic howManyLocations;
  final String? projectName;
  final dynamic lat;
  final dynamic lng;
  final String? stateName;
  final String? districtName;
  final String? blockTownName;
  final String? address;
  final dynamic pincode;
  final dynamic unitCount;
  final String? nUnits;
  final dynamic unitCost;
  final String? projectStartDate;
  final String? projectEndDate;
  final String? expectedCompletionDate;
  final dynamic hasActiveTenders;
  final bool? isProposal;
  final dynamic year;
  final String? yearApproval;
  final int? visitCount;
  final String? proposingDeptName;
  final String? projectDescription;
  final String? beneficiaryDetail;
  final dynamic likelyNumberOfBeneficaries;
  final dynamic likelyNumberOfEmployeementGenerated;
  final int? msdpItemsId;
  final int? refSubItemsId;
  final dynamic whetherNewProject;
  final dynamic blockUrban;
  final dynamic whetherLandAvailable;
  final int? refStatusId;
  final dynamic refStatusIdState;
  final dynamic refStatusIdAdmin;
  final dynamic monthlyProgressJson;
  final dynamic otherInfoJson;
  final String? ecNumber;
  final String? ecMeetingDate;
  final dynamic numberOfUnits;
  final int? completedNotFunctionalUnits;
  final int? completedFunctionalUnits;
  final int? unitDropped;
  final String? tempId;
  final dynamic unitNo;
  final String? projectRefNo;
  final String? asDate;
  final String? scNumber;
  final String? fileComputerNumber;
  final String? ecMeetingFirstDate;
  final String? ecMeetingSecondDate;
  final dynamic sameAllUnits;
  final String? msdpItemsName;
  final String? refSubItemsName;
  final String? msdpSectorName;
  final String? whetherGirlsCentric;
  final int? droppedUnitsNumber;
  final dynamic unitSanctioned;
  final int? unitsCompleted;
  final int? workInProgressUnits;
  final int? unitsNotStarted;
  final int? unitsFunctional;
  final String? remarks;
  final String? checkerRemarks;
  final String? approverRemarks;
  final String? returnRemarks;
  final String? ministryRecommendation;
  final String? approvalDate;
  final dynamic refStatusIdProject;
  final dynamic priority;
  final String? stateRemarks;
  final String? stateDeptRemarks;
  final String? momaRemarks;
  final String? pmuRemarks;
  final String? lineMinistryRemarks;
  final String? scRemarks;
  final String? technicalRemarks;
  final String? quarter1Status;
  final String? quarter2Status;
  final String? quarter3Status;
  final String? quarter4Status;
  final String? deletedAt;
  final int? isDeleted;
  final dynamic submittedByProject;
  final String? principalType;
  final String? principalDate;
  final String? principalRemarks;
  final String? majorInitiativeType;
  final String? majorInitiativeDate;
  final String? majorInitiativeRemarks2;
  final String? typeString;
  final String? projectTypeString;
  final dynamic annualVersion;
  final dynamic finalSubmit;
  final String? finalSubmitDate;
  final int? legacyId;
  final String? createdBy;
  final String? updatedBy;
  final String? createdByRole;
  final String? createdByDistrict;
  final String? createdByState;
  final dynamic approvalPipeline;
  final dynamic currentLevelIndex;
  final dynamic currentLevelStatus;
  final String? priorityString;
  final String? batchId;
  final String? lastRemark;
  final bool? financialPlanningEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DetailedProject({
    required this.id,
    this.projectUniqueId,
    this.districtId,
    this.blockId,
    this.stateId,
    this.sectorId,
    this.projectTypeId,
    this.projectSchemeId,
    this.majorInitiativeTypeIds,
    this.sharingRatioId,
    this.projectTenureFromFYID,
    this.projectTenureTillFY,
    this.pqProjectTypeId,
    this.projectSubTypeId,
    this.contractorId,
    this.status,
    this.infrastructureType,
    this.projectClassification,
    this.howManyLocations,
    this.projectName,
    this.lat,
    this.lng,
    this.stateName,
    this.districtName,
    this.blockTownName,
    this.address,
    this.pincode,
    this.unitCount,
    this.nUnits,
    this.unitCost,
    this.projectStartDate,
    this.projectEndDate,
    this.expectedCompletionDate,
    this.hasActiveTenders,
    this.isProposal,
    this.year,
    this.yearApproval,
    this.visitCount,
    this.proposingDeptName,
    this.projectDescription,
    this.beneficiaryDetail,
    this.likelyNumberOfBeneficaries,
    this.likelyNumberOfEmployeementGenerated,
    this.msdpItemsId,
    this.refSubItemsId,
    this.whetherNewProject,
    this.blockUrban,
    this.whetherLandAvailable,
    this.refStatusId,
    this.refStatusIdState,
    this.refStatusIdAdmin,
    this.monthlyProgressJson,
    this.otherInfoJson,
    this.ecNumber,
    this.ecMeetingDate,
    this.numberOfUnits,
    this.completedNotFunctionalUnits,
    this.completedFunctionalUnits,
    this.unitDropped,
    this.tempId,
    this.unitNo,
    this.projectRefNo,
    this.asDate,
    this.scNumber,
    this.fileComputerNumber,
    this.ecMeetingFirstDate,
    this.ecMeetingSecondDate,
    this.sameAllUnits,
    this.msdpItemsName,
    this.refSubItemsName,
    this.msdpSectorName,
    this.whetherGirlsCentric,
    this.droppedUnitsNumber,
    this.unitSanctioned,
    this.unitsCompleted,
    this.workInProgressUnits,
    this.unitsNotStarted,
    this.unitsFunctional,
    this.remarks,
    this.checkerRemarks,
    this.approverRemarks,
    this.returnRemarks,
    this.ministryRecommendation,
    this.approvalDate,
    this.refStatusIdProject,
    this.priority,
    this.stateRemarks,
    this.stateDeptRemarks,
    this.momaRemarks,
    this.pmuRemarks,
    this.lineMinistryRemarks,
    this.scRemarks,
    this.technicalRemarks,
    this.quarter1Status,
    this.quarter2Status,
    this.quarter3Status,
    this.quarter4Status,
    this.deletedAt,
    this.isDeleted,
    this.submittedByProject,
    this.principalType,
    this.principalDate,
    this.principalRemarks,
    this.majorInitiativeType,
    this.majorInitiativeDate,
    this.majorInitiativeRemarks2,
    this.typeString,
    this.projectTypeString,
    this.annualVersion,
    this.finalSubmit,
    this.finalSubmitDate,
    this.legacyId,
    this.createdBy,
    this.updatedBy,
    this.createdByRole,
    this.createdByDistrict,
    this.createdByState,
    this.approvalPipeline,
    this.currentLevelIndex,
    this.currentLevelStatus,
    this.priorityString,
    this.batchId,
    this.lastRemark,
    this.financialPlanningEnabled,
    this.createdAt,
    this.updatedAt,
  });

  factory DetailedProject.fromJson(Map<String, dynamic> json) {
    return DetailedProject(
      id: json['Id']?.toString() ?? '',
      projectUniqueId: json['projectUniqueId']?.toString(),
      districtId: json['districtId']?.toString(),
      blockId: json['blockId']?.toString(),
      stateId: json['stateId']?.toString(),
      sectorId: json['sectorId']?.toString(),
      projectTypeId: json['projectTypeId']?.toString(),
      projectSchemeId: json['projectSchemeId']?.toString(),
      majorInitiativeTypeIds: json['majorInitiativeTypeIds'],
      sharingRatioId: json['sharingRatioId']?.toString(),
      pqProjectTypeId: json['pqProjectTypeId']?.toString(),
      status: json['status']?.toString(),
      infrastructureType: json['infrastructureType']?.toString(),
      projectName: json['projectName']?.toString(),
      stateName: json['stateName']?.toString(),
      districtName: json['districtName']?.toString(),
      blockTownName: json['blockTownName']?.toString(),
      address: json['address']?.toString(),
      nUnits: json['nUnits']?.toString(),
      unitCost: json['unit_cost'],
      isProposal: json['isProposal'],
      yearApproval: json['yearApproval']?.toString(),
      visitCount: json['visitCount'],
      msdpItemsId: json['msdpItemsId'],
      refSubItemsId: json['refSubItemsId'],
      refStatusId: json['refStatusId'],
      ecNumber: json['ecNumber']?.toString() ?? json['ec_number']?.toString(),
      ecMeetingDate:
          json['ecMeetingDate']?.toString() ??
          json['ec_meeting_date']?.toString(),
      unitsCompleted: json['unitsCompleted'],
      workInProgressUnits: json['workInProgressUnits'],
      unitsNotStarted: json['unitsNotStarted'],
      typeString: json['typeString']?.toString(),
      annualVersion: json['annualVersion'],
      legacyId: json['legacyId'],
      financialPlanningEnabled: json['financialPlanningEnabled'],
      createdBy: json['createdBy']?.toString(),
      updatedBy: json['updatedBy']?.toString(),
      createdAt:
          json['createdAt'] != null
              ? DateTime.tryParse(json['createdAt'])
              : null,
      updatedAt:
          json['updatedAt'] != null
              ? DateTime.tryParse(json['updatedAt'])
              : null,
    );
  }
}
