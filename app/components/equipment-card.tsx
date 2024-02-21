"use client";
import { useState } from "react";
import { Equipment } from "../models";
import { Switch } from "@headlessui/react";

function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

export function EquipmentCard({ equipment }: { equipment: Equipment }) {
  const [enabled, setEnabled] = useState(false);
  return (
    <Switch.Group as="div" className="flex justify-center items-center">
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
            {equipment.name}
          </Switch.Label>
          <Switch.Description
            as="span"
            className="text-sm text-gray-50 flex flex-col justify-center items-center space-y-4"
          >
            <p>{equipment.cost}</p>
          </Switch.Description>
        </span>
      </Switch>
    </Switch.Group>
  );
}
