import { Character } from "../models";
import { CharacterCard } from "./character-card";

export function CharacterRoster({ characters }: { characters: Character[] }) {
  return (
    <div className="my-16 space-y-16">
      <div className="flex flex-col">
        <p className="text-white text-xl pb-2">Roster</p>
        <p className="text-xs italic">
          Choose from among these explorers to send on your trip. Party members
          have specialized skills and abilities that may make your expedition
          easier, or harder. Be cautious with their health meter, as a dead
          party member is actually dead and can not be resurrected, unless of
          course we discover some kind of crazy dark magic.
        </p>
      </div>
      <div className="grid grid-cols-3 gap-2">
        {characters.map((character: Character) => (
          <div key={character.id}>
            <CharacterCard character={character} />
          </div>
        ))}
      </div>
    </div>
  );
}
