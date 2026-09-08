class MarketShedJson {
  static Map<String, dynamic> get marketShedSection => {
    "pageHeading": "Market Shed",
    "section": "marketShedSector",
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
        "name": "vendorsUsingFacility",
        "label": "4. Vendors using facility",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of vendors using the facility.",
      },
      {
        "name": "weeklyMarketDays",
        "label": "5. Weekly market days",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of weekly market days.",
      },
      {
        "name": "averageVisitors",
        "label": "6. Average visitors",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter average number of visitors.",
      },
      {
        "name": "marketElectricity",
        "label": "7. Electricity",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether electricity is available.",
      },
      {
        "name": "marketWater",
        "label": "8. Water",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether water is available.",
      },
      {
        "name": "wasteManagement",
        "label": "9. Waste management",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether waste management is available.",
      },
      {
        "name": "inspectionRemarks",
        "label": "7. Inspection Remarks",
        "type": "textarea",
        "required": true,
        "maxLength": 500,
        "validationMsg": "Please enter remarks.",
      },
    ],
  };
}
