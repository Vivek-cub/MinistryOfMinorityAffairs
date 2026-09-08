class CommunityJson {
  static Map<String, dynamic> get communitySection => {
    "pageHeading": "Community Infrastructure - Community Hall/Sadbhav Mandap",
    "section": "communitySector",
    "apiPaths": {"post": "v1/candidate/education"},
    "fields": [
      // {
      //   "name": "dateOfCompletion",
      //   "label": "9. Date of Completion",
      //   "type": "text",
      //   "required": true,
      //   "disable": true,
      //   "validationMsg": "Date of Completion is required.",
      // },
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
        "name": "eventsConductedPerYear",
        "label": "4. Events conducted/year",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of events conducted per year.",
      },
      {
        "name": "beneficiariesServed",
        "label": "5. Beneficiaries served",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of beneficiaries served.",
      },
      {
        "name": "averageMonthlyUtilisation",
        "label": "6. Average monthly utilisation",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter average monthly utilisation.",
      },
      {
        "name": "sportsElectricityAvailable",
        "label": "7. Electricity available",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter electricity availability.",
      },
      {
        "name": "sportsWaterAvailable",
        "label": "8. Water available",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter water availability.",
      },
      {
        "name": "toiletsFunctional",
        "label": "9. Toilets functional",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether toilets are functional.",
      },
      {
        "name": "maintenanceFundAvailable",
        "label": "10. Maintenance fund available",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether maintenance fund is available.",
      },
      {
        "name": "bookingRegisterMaintained",
        "label": "11. Booking register maintained",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg":
            "Please select whether booking register is maintained.",
      },
      {
        "name": "barrierFreeAccess",
        "label": "12. Barrier-free access",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg":
            "Please select whether barrier-free access is available.",
      },

      {
        "name": "inspectionRemarks",
        "label": "13. Inspection Remarks",
        "type": "textarea",
        "required": true,
        "maxLength": 500,
        "validationMsg": "Please enter remarks.",
      },
    ],
  };
}
