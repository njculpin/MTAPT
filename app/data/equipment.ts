import { Equipment } from "../models";

export const equipment: Equipment[] = [
  {
    id: 0,
    name: "First Aid Kit",
    category: "equipment",
    description:
      "Has bandages, stitches, antibiotic ointment, scissors, needles",
    size: 10,
    uses: 5,
    cost: 2,
  },
  {
    id: 1,
    name: "Mess Kit",
    category: "equipment",
    description: "Has a bowl, cup, and a camp fork and a basic",
    size: 10,
    uses: 1000,
    cost: 2,
  },
  {
    id: 2,
    name: "Fuel Canister",
    category: "equipment",
    description: "Has fuel to run a small burner",
    size: 10,
    uses: 20,
    cost: 2,
  },
  {
    id: 3,
    name: "Compact Burner",
    category: "equipment",
    description: "Uses the Fuel Canister",
    size: 5,
    uses: 500,
    cost: 2,
  },
  {
    id: 4,
    name: "Lighter",
    category: "equipment",
    description: "Can start a small fire",
    size: 1,
    uses: 200,
    cost: 2,
  },
  {
    id: 5,
    name: "Tent",
    category: "equipment",
    description: "Capacity for one person",
    size: 30,
    uses: 200,
    cost: 20,
  },
];
