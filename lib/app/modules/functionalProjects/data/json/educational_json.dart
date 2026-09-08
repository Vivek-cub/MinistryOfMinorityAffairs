class EducationalJson {
  static Map<String, dynamic> get educationalSection => {
    "pageHeading": "Education Details",
    "section": "educationSector",
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
        "name": "currentStudentEnrolment",
        "label": "4. Current student enrolment (annual enrolment)",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter current student enrolment.",
      },

      {
        "name": "studentEnrolmentBeforeProject",
        "label": "5. Student enrolment before project (annual)",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter student enrolment before project.",
      },
      {
        "name": "girlsEnrolled",
        "label": "6. Girls enrolled (annual)",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of girls enrolled.",
      },
      {
        "name": "minorityStudents",
        "label": "7. Minority students (annual)",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of minority students.",
      },
      {
        "name": "classroomsInUse",
        "label": "8. Number of classrooms in use",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of classrooms in use.",
      },
      {
        "name": "classroomsVacant",
        "label": "9. Number of classrooms vacant",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of vacant classrooms.",
      },
      {
        "name": "numberOfTeachers",
        "label": "10. Number of teachers",
        "type": "text",
        "required": true,
        "keyboardType": "number",
        "validationMsg": "Please enter number of teachers.",
      },
      {
        "name": "increaseInEnrolment",
        "label": "11. Increase in enrolment after construction",
        "type": "text",
        "disable": true,
        "required": false,
        "calculation": {
          "formula": "currentStudentEnrolment - studentEnrolmentBeforeProject",
        },
      },
      {
        "name": "hasDropoutReduced",
        "label": "12. Has dropout reduced?",
        "type": "radio",
        "required": true,
        "options": [
          {"label": "Yes", "value": true},
          {"label": "No", "value": false},
        ],
        "validationMsg": "Please select whether dropout has reduced.",
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
