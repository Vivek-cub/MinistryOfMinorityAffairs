class DwfJson {
  static Map<String, dynamic> get dwfSection => {
    "pageHeading": "Drinking Water Facility",
    "section": "dwfSector",
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

      // Drinking Water Facility
      {
        "name": "waterSuppliedPerDay",
        "label": "4. Water supplied/day (litres)",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter water supplied per day.",
      },
      {
        "name": "householdsCovered",
        "label": "5. Households covered",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of households covered.",
      },
      {
        "name": "waterQualityTested",
        "label": "6. Water quality tested",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether water quality is tested.",
      },
      {
        "name": "pumpFunctional",
        "label": "7. Pump functional",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether the pump is functional.",
      },
      {
        "name": "waterElectricityAvailable",
        "label": "8. Electricity available",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether electricity is available.",
      },
      {
        "name": "inspectionRemarks",
        "label": "9. Inspection Remarks",
        "type": "textarea",
        "required": true,
        "maxLength": 500,
        "validationMsg": "Please enter remarks.",
      },
    ],
  };
}
