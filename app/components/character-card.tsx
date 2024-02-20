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
            enabled
              ? "bg-gray-900 border-gray-800"
              : "bg-gray-950 border-gray-950",
            "w-full flex flex-grow flex-col justify-center items-center p-4 border hover:bg-gray-700"
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
          </Switch.Description>
        </span>
      </Switch>
    </Switch.Group>
  );
}

function HealthMeter({ health }: { health: number }) {
  const counter = Array.from({ length: 4 }, (_, index) => index + 1);
  return (
    <div className="flex flex-row justify-center items-center space-x-4">
      {counter.map(function (heart) {
        if (health >= heart) {
          return <FullHealthIcon key={heart} />;
        } else {
          return <EmptyHealthIcon key={heart} />;
        }
      })}
    </div>
  );
}

function FullHealthIcon() {
  return (
    <svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="#b91c1c"
      className="w-6 h-6"
    >
      <path d="m11.645 20.91-.007-.003-.022-.012a15.247 15.247 0 0 1-.383-.218 25.18 25.18 0 0 1-4.244-3.17C4.688 15.36 2.25 12.174 2.25 8.25 2.25 5.322 4.714 3 7.688 3A5.5 5.5 0 0 1 12 5.052 5.5 5.5 0 0 1 16.313 3c2.973 0 5.437 2.322 5.437 5.25 0 3.925-2.438 7.111-4.739 9.256a25.175 25.175 0 0 1-4.244 3.17 15.247 15.247 0 0 1-.383.219l-.022.012-.007.004-.003.001a.752.752 0 0 1-.704 0l-.003-.001Z" />
    </svg>
  );
}

function EmptyHealthIcon() {
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
