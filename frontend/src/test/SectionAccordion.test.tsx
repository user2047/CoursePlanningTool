import React from "react";
import { render, screen } from "@testing-library/react";
import SectionAccordion from "../components/screens/CoursePage/SyllabusView/BasicInformation/SectionAccordion";
import { BasicInfoData } from "../utils/loadBasicInfoFields";

const mockFields: BasicInfoData[] = [
  {
    section: "Basic Info",
    row: 1,
    layoutRow: 1,
    label: "Name",
    type: "text",
    placeholder: "Enter name",
    required: false,
  },
  {
    section: "Basic Info", 
    row: 2,
    layoutRow: 1,
    label: "Description",
    type: "textarea",
    placeholder: "Enter description",
    required: false,
  },
  {
    section: "Basic Info",
    row: 3,
    layoutRow: 1,
    label: "Additional Information",
    type: "textarea",
    placeholder: "Enter additional information",
    required: false,
  },
];

test("renders SectionAccordion with grouped rows and fields", () => {
  render(
    <SectionAccordion
      sectionName="Basic Info"
      fields={mockFields}   
      formData={{
        Name: "Alice",
        Description: "Some desc",
        "Additional Information": ""
      }}
      onFieldChange={() => {}}
    />
  );

  expect(screen.getByText("Basic Info")).toBeInTheDocument();
  expect(screen.getByPlaceholderText("Enter name")).toBeInTheDocument();
  expect(screen.getByRole("textbox", { name: /Description/i })).toBeInTheDocument();
  expect(screen.getByRole("textbox", { name: /Additional Information/i })).toBeInTheDocument();
});
