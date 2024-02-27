"use client";
import { Character } from "../models";
import { CharacterCard } from ".";

export function CharacterRoster({ characters }: { characters: Character[] }) {
  return (
    <div className="space-7-4">
      <div className="flex flex-col">
        <p className="text-black text-xl pb-2">Crew</p>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {characters.map((character: Character) => (
          <div key={character.id}>
            <CharacterCard character={character} />
          </div>
        ))}
      </div>
    </div>
  );
}
