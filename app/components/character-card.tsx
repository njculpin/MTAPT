"use client";
import { useState } from "react";
import { Switch } from "@headlessui/react";

function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

export function CharacterCard({ character }: { character: any }) {
  const [enabled, setEnabled] = useState(false);
  return (
    <div className="p-4 border border-gray-50">
      <div className="border-b pb-2 flex justify-between items-center">
        <div>
          <p>{character.name}</p>
        </div>
      </div>
      <div className="border-b py-2">
        <p>
          Can{" "}
          {character.skills
            .map(function (skill: SkillAttributes) {
              return skill.description;
            })
            .join(", and ")}
        </p>
      </div>
      <div className="py-2">
        <Switch.Group as="div" className="flex items-center justify-between">
          <Switch
            checked={enabled}
            onChange={setEnabled}
            className={classNames(
              enabled ? "bg-gray-900" : "bg-gray-200",
              "relative inline-flex h-6 w-11 flex-shrink-0 cursor-pointer rounded-full border-2 border-transparent transition-colors duration-200 ease-in-out focus:outline-none focus:ring-2 focus:ring-gray-900 focus:ring-offset-2"
            )}
          >
            <span
              aria-hidden="true"
              className={classNames(
                enabled ? "translate-x-5" : "translate-x-0",
                "pointer-events-none inline-block h-5 w-5 transform rounded-full bg-white shadow ring-0 transition duration-200 ease-in-out"
              )}
            />
          </Switch>
          <span className="ml-4 flex flex-grow flex-col">
            <Switch.Label
              as="span"
              className="text-sm font-medium leading-6 text-white"
              passive
            >
              Hire
            </Switch.Label>
            <Switch.Description as="span" className="text-sm text-gray-500">
              <p>{character.salary} APT per day</p>
            </Switch.Description>
          </span>
        </Switch.Group>
      </div>
    </div>
  );
}
