class WomenCommunityJson {
  static Map<String, dynamic> get womencommunitySection => {
    "pageHeading": "Women Community Json",
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

      // Women Community Centre
      {
        "name": "shgsUsingCentre",
        "label": "4. SHGs using centre",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether SHGs are using the centre.",
      },
      {
        "name": "programmesConducted",
        "label": "5. Programmes conducted",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter the number of programmes conducted.",
      },
      {
        "name": "womenBeneficiaries",
        "label": "6. Women beneficiaries",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter the number of women beneficiaries.",
      },
      {
        "name": "skillProgrammesOrganised",
        "label": "7. Skill programmes organised",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg":
            "Please enter the number of skill programmes organised.",
      },
      {
        "name": "healthCampsOrganised",
        "label": "8. Health camps organised",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter the number of health camps organised.",
      },
      {
        "name": "otherEventsOrganised",
        "label": "9. Other Events organised",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter the number of other events organised.",
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
