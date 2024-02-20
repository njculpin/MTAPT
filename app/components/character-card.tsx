"use client";
import { useState } from "react";
import { Switch } from "@headlessui/react";

function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

export function CharacterCard({ character }: { character: any }) {
  const [enabled, setEnabled] = useState(false);
  return (
    <Switch.Group as="div" className="w-full flex justify-center items-center">
      <Switch checked={enabled} onChange={setEnabled} className="w-full">
        <span
          className={classNames(
            enabled ? "bg-gray-900" : "bg-black",
            "w-full flex flex-grow flex-col p-4"
          )}
        >
          <Switch.Label
            as="span"
            className="text-sm leading-6 text-white font-bold"
            passive
          >
            {character.name}
          </Switch.Label>
          <Switch.Description as="span" className="text-sm text-gray-50">
            {character.skills}
          </Switch.Description>
          <Switch.Description as="span" className="text-xs text-gray-50 mt-4">
            Hire for ${character.salary} APT per day
          </Switch.Description>
        </span>
      </Switch>
    </Switch.Group>
  );
}
