import { Equipment } from "../models";

export const equipment: Equipment[] = [
  {
    id: 0,
    name: "First Aid Kit",
    category: "",
    description:
      "Has bandages, stitches, antibiotic ointment, scissors, needles",
    size: 10,
    uses: 5,
    cost: 2,
  },
  {
    id: 1,
    name: "Mess Kit",
    category: "",
    description: "Has a bowl, cup, and a camp fork and a basic",
    size: 10,
    uses: 1000,
    cost: 2,
  },
  {
    id: 2,
    name: "Fuel Canister",
    category: "",
    description: "Has fuel to run a small burner",
    size: 10,
    uses: 20,
    cost: 2,
  },
  {
    id: 3,
    name: "Compact Burner",
    category: "",
    description: "Uses the Fuel Canister",
    size: 5,
    uses: 500,
    cost: 2,
  },
  {
    id: 4,
    name: "Lighter",
    category: "",
    description: "Can start a small fire",
    size: 1,
    uses: 200,
    cost: 2,
  },
];
