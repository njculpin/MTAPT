"use client";
import { Character } from "../models";
import { CharacterCard } from ".";

export function CharacterRoster({ characters }: { characters: Character[] }) {
  return (
    <div className="space-7-4">
      <div className="flex flex-col">
        <p className="text-black text-xl pb-2">Crew</p>
      </div>
      <div className="mt-8 flow-root">
        <div className="-mx-4 -my-2 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div className="inline-block min-w-full py-2 align-middle sm:px-6 lg:px-8">
            <table className="min-w-full divide-y divide-gray-300">
              <thead>
                <tr className="divide-x divide-gray-200">
                  <th
                    scope="col"
                    className="py-3.5 pl-4 pr-4 text-left text-sm font-semibold text-gray-900 sm:pl-0"
                  >
                    Name
                  </th>
                  <th
                    scope="col"
                    className="px-4 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Profession
                  </th>
                  <th
                    scope="col"
                    className="px-4 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Health
                  </th>

                  <th
                    scope="col"
                    className="px-4 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Backpack
                  </th>
                  <th
                    scope="col"
                    className="px-4 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Status
                  </th>
                  <th
                    scope="col"
                    className="px-4 py-3.5 text-left text-sm font-semibold text-gray-900"
                  >
                    Day Rate
                  </th>
                  <th
                    scope="col"
                    className="py-3.5 pl-4 pr-4 text-left text-sm font-semibold text-gray-900 sm:pr-0"
                  >
                    Rest/Work
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 bg-white">
                {characters.map((character) => (
                  <CharacterCard key={character.id} character={character} />
                ))}
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  );
}
