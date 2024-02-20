import { Character } from "../models";
import { CharacterCard } from "./character-card";

export function CharacterRoster({ characters }: { characters: Character[] }) {
  return (
    <div className="my-16 space-y-6">
      <p className="text-white text-xl pb-2">Roster</p>
      <div className="grid grid-cols-2 gap-2">
        {characters.map((character: Character) => (
          <div key={character.id}>
            <CharacterCard character={character} />
          </div>
        ))}
      </div>
    </div>
  );
}
