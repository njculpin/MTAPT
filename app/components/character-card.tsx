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
            enabled ? "bg-gray-900 border border-gray-800" : "bg-gray-950",
            "w-full flex flex-grow flex-col justify-center items-center p-4",
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
          <Switch.Description
            as="span"
            className="text-sm text-gray-50 flex flex-col justify-center items-center space-y-4"
          >
            <p>{character.skills}</p>
            <HealthMeter health={character.health} />
            <p>Hire for ${character.salary} APT per day</p>
          </Switch.Description>
        </span>
      </Switch>
    </Switch.Group>
  );
}

function HealthMeter({ health }: { health: number }) {
  const counter = Array.from({ length: health }, (_, index) => index + 1);
  return (
    <div className="flex flex-row justify-center items-center space-x-4">
      {counter.map(function (heart) {
        return <HealthIcon key={heart} />;
      })}
    </div>
  );
}

function HealthIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      fill="none"
      viewBox="0 0 24 24"
      strokeWidth={1.5}
      stroke="currentColor"
      className="w-6 h-6 text-red-700"
    >
      <path
        strokeLinecap="round"
        strokeLinejoin="round"
        d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z"
      />
    </svg>
  );
}
