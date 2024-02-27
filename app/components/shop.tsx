import { Equipment } from "../models";

export function Shop({ equipment }: { equipment: Equipment[] }) {
  return (
    <div className="my-16 space-y-4">
      <div className="flex justify-between">
        <p className="text-black text-xl pb-2">Shop</p>
      </div>
      <div className="mt-8 flow-root">
        <div className="mt-8 grid grid-cols-1 gap-y-12 sm:grid-cols-2 sm:gap-x-6 lg:grid-cols-4 xl:gap-x-8">
          {equipment.map(function (equip) {
            return (
              <div
                className="flex flex-col justify-between p-6 shadow"
                key={equip.id}
              >
                <div className="space-y-2">
                  <div>
                    <p className="font-bold text-2xl">{equip.name}</p>
                    <p>{equip.category}</p>
                  </div>
                  <div>
                    <p className="italic text-gray-700">{equip.description}</p>
                  </div>
                  <div className="text-gray-700 grid grid-cols-2 gap-4">
                    <p>{equip.size} size</p>
                    <p>{equip.uses} uses</p>
                  </div>
                </div>
                <div className="mt-6 flex justify-between items-center">
                  <div>
                    <p className="text-xl">${equip.cost}</p>
                  </div>
                  <button className="relative flex items-center justify-center rounded-md border border-transparent bg-gray-100 px-8 py-2 text-sm font-medium text-gray-900 hover:bg-gray-200">
                    Add to bag<span className="sr-only">, {equip.name}</span>
                  </button>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}
