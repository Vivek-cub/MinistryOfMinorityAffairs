class WomenCentricInfrastructureJson {
  static Map<String, dynamic> get womenCentricInfrastructureSection => {
    "pageHeading": "Women-centric Infrastructure - Working Women Hostel",
    "section": "womenCentricInfrastructureSector",
    "apiPaths": {"post": "v1/candidate/education", "get": ""},
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
        "name": "capacityAfterConstruction",
        "label": "4. Capacity (After construction)",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter the capacity after construction.",
      },
      {
        "name": "occupancy",
        "label": "5. Occupancy",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter occupancy.",
      },
      {
        "name": "security",
        "label": "6. Security",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of security personnel.",
      },
      {
        "name": "cctv",
        "label": "7. CCTV",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether CCTV is available.",
      },
      {
        "name": "warden",
        "label": "8. Warden",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of wardens.",
      },
      {
        "name": "childcareFacility",
        "label": "9. Childcare facility",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg":
            "Please select whether childcare facility is available.",
      },
      {
        "name": "maintenanceLastDoneDate",
        "label": "10. Maintenance (Last done date)",
        "type": "date",
        "required": true,
        "validationMsg": "Please select the last maintenance date.",
      },
      {
        "name": "inspectionRemarks",
        "label": "11. Inspection Remarks",
        "type": "textarea",
        "required": true,
        "maxLength": 500,
        "validationMsg": "Please enter remarks.",
      },
    ],
  };
}
