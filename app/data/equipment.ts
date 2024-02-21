import { Equipment } from "../models";

export const equipment: Equipment[] = [
  {
    name: "First Aid Kit",
    description:
      "Has bandages, stitches, antibiotic ointment, scissors, needles",
    uses: 5,
    cost: 2,
  },
  {
    name: "Mess Kit",
    description: "Has a bowl, cup, and a camp fork and a basic",
    uses: 1000,
    cost: 2,
  },
  {
    name: "Fuel Canister",
    description: "Has fuel to run a small burner",
    uses: 20,
    cost: 2,
  },
  {
    name: "Compact Burner",
    description: "Uses the Fuel Canister",
    uses: 500,
    cost: 2,
  },
  {
    name: "Lighter",
    description: "Can start a small fire",
    uses: 200,
    cost: 2,
  },
];
