class OperationJson {
  static Map<String, dynamic> get operationSection => {
    "pageHeading": "Operations & Maintenance",
    "section": "operationSector",
    "apiPaths": {"post": "v1/candidate/education"},
    "fields": [
      {
        "name": "dateOfFunctionalityCheck",
        "label": "1. Date of Functionality Check/Assessment",
        "type": "date",
        "required": true,
        "validationMsg": "Please select the date of functionality check.",
      },

      {
        "name": "openingDate",
        "label": "2. Date of Opening/Inaugration",
        "type": "date",
        "required": true,
        "validationMsg": "Please select the opening date.",
      },
      {
        "name": "assetOptional",
        "label": "3. Is the asset operational?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select asset is operational or not.",
      },
      {
        "name": "nonOperationalRemarks",
        "label": "3.1. If non-operational, reason thereof",
        "type": "text",
        "required": true,
        "validationMsg": "Please Enter reason of non-operational.",
        "visibleWhen": [
          {"key": "assetOptional", "value": false},
        ],
      },
      {
        "name": "responsibleDepartment",
        "label": "4. Responsible Department",
        "type": "text",
        "required": true,
        "validationMsg": "Please enter/select the responsible department.",
      },
      {
        "name": "maintenanceAgencyName",
        "label": "18. Maintenance agency Name",
        "type": "text",
        "required": true,
        "validationMsg": "Please enter maintenance agency name.",
      },
      {
        "name": "lastRepairDate",
        "label": "5. Last repair date",
        "type": "date",
        "required": true,
        "validationMsg": "Please select the last repair date.",
      },
      {
        "name": "majorRepairsRequiredPending",
        "label": "6. Major repairs required/pending (as on date of inspection)",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg":
            "Please select whether major repairs are required/pending.",
      },
      {
        "name": "estimatedRepairCost",
        "label": "7. Estimated repair cost (if calculated already)",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter the estimated repair cost.",
      },
      {
        "name": "structuralDamage",
        "label": "8. Any structural damage",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg":
            "Please select whether there is any structural damage.",
      },
      {
        "name": "buildingSafetyCertified",
        "label": "9. Building safety certified (PWD inspection report)",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg":
            "Please select whether the building safety is certified.",
      },
      {
        "name": "inspectionRemarks",
        "label": "10. Inspection Remarks",
        "type": "textarea",
        "required": true,
        "maxLength": 500,
        "validationMsg": "Please enter remarks.",
      },
    ],
  };
}
