"use client";

export function EquipmentCard({ equipment }: { equipment: any }) {
  return (
    <div className="p-4 border border-gray-50" key={equipment.name}>
      <div className="flex flex-row justify-between items-center gap-4">
        <div>
          <label htmlFor="quantity" className="sr-only">
            Quantity
          </label>
          <select
            id="quantity"
            name="quantity"
            className="bg-black rounded-md border border-gray-300 text-left text-2xl font-bold text-white shadow-sm focus:border-gray-500 focus:outline-none focus:ring-1 focus:ring-gray-500 sm:text-sm p-2"
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
