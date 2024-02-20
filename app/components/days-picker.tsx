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
    <div className="my-16 space-y-6">
      <div className="flex items-center justify-between">
        <p className="text-white text-xl pb-2">Days</p>
      </div>
      <RadioGroup value={days} onChange={setDays} className="mt-2">
        <RadioGroup.Label className="sr-only">
          Choose a memory option
        </RadioGroup.Label>
        <div className="grid grid-cols-3 gap-3 sm:grid-cols-7">
          {options.map((option) => (
            <RadioGroup.Option
              key={option.name}
              value={option}
              className={({ active, checked }) =>
                classNames(
                  checked ? "bg-gray-900" : "bg-black",
                  "w-full flex flex-grow flex-col justify-center items-center p-4"
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
