"use client";
import { Equipment } from "../models";

export function EquipmentCard({ equipment }: { equipment: Equipment }) {
  return (
    <>
      {/* <div className="flex-shrink-0">
        <img
          src={equipment.imageSrc}
          alt={equipment.imageAlt}
          className="h-24 w-24 rounded-lg object-cover object-center sm:h-32 sm:w-32"
        />
      </div> */}
      <div className="relative mx-4 flex flex-1 flex-col justify-between sm:ml-6">
        <div>
          <div className="flex justify-between sm:grid sm:grid-cols-2">
            <div className="pr-6">
              <h3 className="text-sm">
                <p className="font-medium text-black hover:text-black">
                  {equipment.name}
                </p>
              </h3>
              <p className="mt-1 text-sm text-white0">
                {equipment.description}
              </p>
              {equipment.size ? (
                <p className="mt-1 text-sm text-white0">{equipment.size}</p>
              ) : null}
            </div>

            <p className="text-right text-sm font-medium text-black">
              {equipment.cost} APT
            </p>
          </div>

          <div className="mt-4 flex items-center sm:absolute sm:left-1/2 sm:top-0 sm:mt-0 sm:block">
            <label htmlFor={`quantity-${equipment.id}`} className="sr-only">
              Quantity, {equipment.name}
            </label>
            <select
              id={`quantity-${equipment.id}`}
              name={`quantity-${equipment.id}`}
              className="block max-w-full rounded-md border border-gray-300 py-1.5 text-left text-base font-medium leading-5 text-black shadow-sm focus:border-white focus:outline-none focus:ring-1 focus:ring-white sm:text-sm"
            >
              <option value={0}>0</option>
              <option value={1}>1</option>
              <option value={2}>2</option>
              <option value={3}>3</option>
              <option value={4}>4</option>
              <option value={5}>5</option>
              <option value={6}>6</option>
              <option value={7}>7</option>
              <option value={8}>8</option>
            </select>
          </div>
        </div>
      </div>
    </>
  );
}
