class IndoorSportsJson {
  static Map<String, dynamic> get indoorSportsection => {
    "pageHeading": "Sports Infrastructure - Indoor",
    "section": "indoorSportsSector",
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

      // Indoor Stadium / Sports Complex
      {
        "name": "seatingCapacity",
        "label": "4. Seating capacity",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter seating capacity.",
      },
      {
        "name": "sportsDisciplinesConducted",
        "label": "5. Sports disciplines conducted",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of sports disciplines conducted.",
      },
      {
        "name": "registeredDailyUsers",
        "label": "6. Registered daily users",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of registered daily users.",
      },
      {
        "name": "competitionsOrganised",
        "label": "7. Competitions organised",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of competitions organised.",
      },
      {
        "name": "indoorEquipmentAvailable",
        "label": "8. Equipment available",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether equipment is available.",
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
