"use client";
import { EquipmentCard } from ".";
import { Character, Equipment } from "../models";
import { useState } from "react";

function classNames(...classes: string[]) {
  return classes.filter(Boolean).join(" ");
}

export function BackpackCard({
  character,
  equipment,
}: {
  character: Character;
  equipment: Equipment[];
}) {
  return (
    <>
      <div className="w-full grid grid-cols-4 gap-4">
        {equipment.map(function (equip) {
          return (
            <div key={equip.name} className="flex justify-center items-start">
              <EquipmentCard equipment={equip} />
            </div>
          );
        })}
      </div>
      <p></p>
    </>
  );
}
