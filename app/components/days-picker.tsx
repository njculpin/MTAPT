"use client";
import { useState } from "react";
import { RadioGroup } from "@headlessui/react";

const options = [
  { name: "1" },
  { name: "2" },
  { name: "3" },
  { name: "4" },
  { name: "5" },
  { name: "6" },
  { name: "7" },
];

function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

export function DaysPicker() {
  const [days, setDays] = useState(options[2]);

  return (
    <div className="my-16 space-y-16">
      <div className="flex flex-col">
        <p className="text-white text-xl pb-2">Number of days for this trip</p>
        <p className="text-xs italic">
          Choose a number of days you think you can survive and be effective.
          You should balance your equipment, party members, your route, and
          known weather conditions.
        </p>
      </div>
      <RadioGroup value={days} onChange={setDays} className="mt-2">
        <RadioGroup.Label className="sr-only">
          Choose the number of days for your trip
        </RadioGroup.Label>
        <div className="grid grid-cols-1 md:grid-cols-3 lg:grid-cols-7 gap-3">
          {options.map((option) => (
            <RadioGroup.Option
              key={option.name}
              value={option}
              className={({ active, checked }) =>
                classNames(
                  checked
                    ? "bg-gray-900 border border-gray-800"
                    : "bg-gray-950",
                  "w-full flex flex-grow flex-col justify-center items-center p-4 hover:bg-gray-700"
                )
              }
            >
              <RadioGroup.Label as="span">{option.name}</RadioGroup.Label>
            </RadioGroup.Option>
          ))}
        </div>
      </RadioGroup>
    </div>
  );
}
