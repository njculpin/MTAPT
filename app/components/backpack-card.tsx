"use client";
import { useEffect, useState } from "react";
import { EquipmentCard } from ".";
import { Character, Equipment } from "../models";

export function BackpackCard({ equipment }: { equipment: Equipment[] }) {
  const [selectedEquipment, setSelectedEquipment] = useState<Equipment[]>([]);
  const [capacity, setCapacity] = useState(0);
  function handleSetSelected({
    equipment,
    enabled,
  }: {
    equipment: Equipment;
    enabled: boolean;
  }) {
    if (!enabled) {
      let prev = selectedEquipment.filter((x) => x.name !== equipment.name);
      setSelectedEquipment(prev);
    } else {
      setSelectedEquipment([...selectedEquipment, equipment]);
    }
  }

  useEffect(() => {
    const cap = selectedEquipment.map((x) => x.size);
    if (!cap.length) {
      return;
    }
    setCapacity(cap.reduce((a, b) => a + b));
  }, [selectedEquipment]);

  return (
    <div className="my-16 space-y-16">
      <div className="flex flex-col">
        <p className="text-black text-xl pb-2">Shop for equipment</p>
      </div>
      <div>
        <h2 className="sr-only">Items in your shopping cart</h2>
        <ul
          role="list"
          className="divide-y divide-gray-200 border-b border-t border-gray-200"
        >
          {equipment.map(function (equip) {
            return (
              <li key={equip.id} className="flex py-6 sm:py-10">
                <EquipmentCard equipment={equip} />
              </li>
            );
          })}
        </ul>
        <div className="mt-10 sm:ml-32 sm:pl-6">
          <div className="rounded-lg bg-white px-4 py-6 sm:p-6 lg:p-8">
            <h2 className="sr-only">Order summary</h2>

            <div className="flow-root">
              <dl className="-my-4 divide-y divide-gray-200 text-sm">
                <div className="flex items-center justify-between py-4">
                  <dt className="text-black">Subtotal</dt>
                  <dd className="font-medium text-gray-50">$99.00</dd>
                </div>
                <div className="flex items-center justify-between py-4">
                  <dt className="text-black">Shipping</dt>
                  <dd className="font-medium text-gray-50">$5.00</dd>
                </div>
                <div className="flex items-center justify-between py-4">
                  <dt className="text-black">Tax</dt>
                  <dd className="font-medium text-gray-50">$8.32</dd>
                </div>
                <div className="flex items-center justify-between py-4">
                  <dt className="text-base font-medium text-gray-50">
                    Order total
                  </dt>
                  <dd className="text-base font-medium text-gray-50">
                    $112.32
                  </dd>
                </div>
              </dl>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
