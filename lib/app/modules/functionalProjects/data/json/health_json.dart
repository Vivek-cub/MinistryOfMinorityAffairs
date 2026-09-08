class HealthJson {
  static Map<String, dynamic> get healthSection => {
    "pageHeading": "Health Sector",
    "section": "healthSector",
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
        "name": "doctorsPosted",
        "label": "4. Doctors posted as on date",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of doctors posted.",
      },
      {
        "name": "nursesPosted",
        "label": "5. Nurses posted as on date",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of nurses posted.",
      },
      {
        "name": "bedsAvailable",
        "label": "6. Beds available as on date",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of beds available.",
      },
      {
        "name": "bedOccupancy",
        "label": "7. Bed occupancy (%)",
        "type": "text",
        "disable": true,
        "required": false,
        "calculation": {"formula": "(occupiedBeds / bedsAvailable) * 100"},
      },
      {
        "name": "averageOpdPerMonth",
        "label": "8. Average OPD/month",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter average OPD per month.",
      },
      {
        "name": "deliveriesPerMonth",
        "label": "9. Deliveries/month",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter deliveries per month.",
      },
      {
        "name": "diagnosticServicesAvailable",
        "label": "10. Diagnostic services available?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg":
            "Please select whether diagnostic services are available.",
      },
      {
        "name": "medicineAvailability",
        "label": "11. Medicine availability",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether medicines are available.",
      },
      {
        "name": "ambulanceAvailable",
        "label": "12. Ambulance available?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether an ambulance is available.",
      },
      {
        "name": "electricityAvailable",
        "label": "13. Electricity available?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether electricity is available.",
      },
      {
        "name": "waterAvailable",
        "label": "14. Water available?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether water is available.",
      },
      {
        "name": "equipmentFunctional",
        "label": "15. Equipment functional?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether the equipment is functional.",
      },

      {
        "name": "inspectionRemarks",
        "label": "16. Inspection Remarks",
        "type": "textarea",
        "required": true,
        "maxLength": 500,
        "validationMsg": "Please enter remarks.",
      },
    ],
  };
}
