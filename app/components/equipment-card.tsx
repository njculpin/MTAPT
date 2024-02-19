"use client";

export function EquipmentCard({ equipment }: { equipment: any }) {
  return (
    <div className="p-4 border border-gray-50" key={equipment.name}>
      <div className="flex flex-row justify-between gap-4">
        <div>
          <label htmlFor="quantity" className="sr-only">
            Quantity
          </label>
          <select
            id="quantity"
            name="quantity"
            className="rounded-md border border-gray-300 text-left text-2xl font-medium text-gray-700 shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500 sm:text-sm"
          >
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
        <div>
          <label
            htmlFor="name"
            className="block text-sm font-bold leading-6 text-white"
          >
            {equipment.name} - {equipment.cost} APT
          </label>
        </div>
      </div>
    </div>
  );
}
