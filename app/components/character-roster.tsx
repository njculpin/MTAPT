import { Character, Equipment } from "../models";
import { CharacterCard, BackpackCard } from ".";

export function CharacterRoster({
  characters,
  equipment,
}: {
  characters: Character[];
  equipment: Equipment[];
}) {
  return (
    <div className="space-7-4">
      <div className="flex flex-col">
        <p className="text-black text-xl pb-2">Crew</p>
      </div>
      <div className="grid grid-cols-2 lg:grid-cols-12 gap-4">
        {characters.map((character: Character) => (
          <div key={character.id} className="p-4">
            <CharacterCard character={character} />
          </div>
        ))}
      </div>
    </div>
  );
}
