class ToiletJson {
  static Map<String, dynamic> get toiletSection => {
    "pageHeading": "Toilet Complex",
    "section": "toiletSector",
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

      // Toilet Complex
      {
        "name": "seatsAvailable",
        "label": "4. Seats available",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether seats are available.",
      },
      {
        "name": "toiletDailyUsers",
        "label": "5. Daily users (Approx)",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter approximate daily users.",
      },
      {
        "name": "runningWaterAvailable",
        "label": "6. Running Water available",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether running water is available.",
      },
      {
        "name": "cleaningFrequency",
        "label": "7. Cleaning frequency (Daily/Weekly)",
        "type": "text",
        "required": true,
        "validationMsg": "Please enter cleaning frequency.",
      },
      {
        "name": "separateFacilityForWomen",
        "label": "8. Separate facility for women",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg":
            "Please select whether a separate facility for women is available.",
      },
      {
        "name": "divyangAccessible",
        "label": "9. Divyang accessible",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg":
            "Please select whether the facility is Divyang accessible.",
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
