class GirlsHostelJson {
  static Map<String, dynamic> get girlsHostelSection => {
    "pageHeading": "Girls Hostel",
    "section": "girlsHostelSector",
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
        "name": "hostelBedCapacity",
        "label": "4. Hostel bed capacity",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter hostel bed capacity.",
      },
      {
        "name": "studentsResiding",
        "label": "5. Students residing",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of students residing.",
      },
      {
        "name": "occupancyPercentage",
        "label": "6. Occupancy percentage",
        "type": "text",
        "disable": true,
        "required": false,
        "calculation": {
          "formula": "(studentsResiding / hostelBedCapacity) * 100",
        },
      },
      {
        "name": "girlsFromMinorityCommunities",
        "label": "7. Girls from minority communities",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg":
            "Please enter number of girls from minority communities.",
      },
      {
        "name": "wardenPosted",
        "label": "8. Warden posted?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether a warden is posted.",
      },
      {
        "name": "securityAvailable",
        "label": "9. Security available?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether security is available.",
      },
      {
        "name": "kitchenFunctional",
        "label": "10. Kitchen functional?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether the kitchen is functional.",
      },
      {
        "name": "toiletsFunctional",
        "label": "11. Toilets functional?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether the toilets are functional.",
      },
      {
        "name": "waitingList",
        "label": "12. Waiting list",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter the waiting list number.",
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
