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
    <div className="my-16 space-y-16">
      <div className="flex flex-col">
        <p className="text-white text-xl pb-2">Roster</p>
        <p className="text-xs italic">
          Choose from among these explorers to send on this excursion. Party
          members have specialized skills and abilities that may make your
          expedition easier...or harder. Be cautious with their health care, as
          a dead party member is actually dead and can not be resurrected.
          Unless of course we discover some kind of crazy dark magic, in which
          case, we might have bigger fish to fry.
        </p>
      </div>
      <div className="grid grid-cols-1 gap-4">
        {characters.map((character: Character) => (
          <div
            key={character.id}
            className="grid grid-cols-4 gap-4 border border-gray-900 p-4"
          >
            <div className="col-span-1">
              <CharacterCard character={character} />
            </div>
            <div className="col-span-3">
              <BackpackCard character={character} equipment={equipment} />
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
