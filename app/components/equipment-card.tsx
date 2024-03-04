"use client";
import { Equipment } from "../models";

export function EquipmentCard({ equipment }: { equipment: Equipment | null }) {
  if (!equipment) {
    return <></>;
  }
  return (
    <tr key={equipment.id} className="divide-x divide-gray-200">
      <td className="whitespace-nowrap py-4 pl-4 pr-4 text-sm font-medium text-gray-900 sm:pl-0">
        <div className="flex space-x-4 items-center">
          <div className="w-8 h-8 bg-gray-50 rounded-full">
            {/* <CharacterIcon height={32} width={32} /> */}
          </div>
          <p>{equipment.name}</p>
        </div>
      </td>
      <td className="whitespace-nowrap p-4 text-sm text-gray-500">
        {equipment.description}
      </td>
      <td className="whitespace-nowrap p-4 text-sm text-gray-500">
        ${equipment.cost}
      </td>
      <td className="whitespace-nowrap py-4 pl-4 pr-4 text-sm text-gray-500 sm:pr-0">
        QTY
      </td>
    </tr>
  );
}
