import { characters, equipment } from "./data";
import { CharacterCard, EquipmentCard, WeatherForecast } from "./components";
import { numberToString } from "./utils";
import { DaysPicker } from "./components/days-picker";

export default function Home() {
  const days = 5;
  const day = numberToString(days);
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="max-w-5xl w-full justify-center font-mono">
        <div className="my-16 space-y-4">
          <h1 className="text-white text-6xl">Mt Aptos</h1>
          <p className="text-xl">
            Welcome to Base Camp{" "}
            <span className="text-purple-600">Cafeteria.</span>
          </p>
        </div>
        <div className="my-16 space-y-6">
          <DaysPicker />
        </div>
        <div className="my-16 space-y-16">
          <p className="text-white text-xl pb-2">
            Here is the latest {day} day weather report
          </p>
          <WeatherForecast days={days} />
        </div>
        <div className="my-16 space-y-6">
          <p className="text-white text-xl pb-2">
            Select your team for the trip
          </p>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            {characters.map(function (item: CharacterAttributes) {
              return (
                <div key={item.name}>
                  <CharacterCard character={item} />
                </div>
              );
            })}
          </div>
        </div>
        <div className="my-16 space-y-6">
          <p className="text-white text-xl pb-2">Select Gear and Equipment</p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
            {equipment.map(function (item) {
              return (
                <div key={item.name}>
                  <EquipmentCard equipment={item} />
                </div>
              );
            })}
          </div>
        </div>
        <div className="my-16 flex justify-between items-center p-8 border">
          <div>
            <p className="text-white text-3xl">Ready to go?</p>
          </div>
          <button
            type="button"
            className="rounded-md bg-white/10 px-3.5 py-2.5 text-4xl font-semibold text-white shadow-sm hover:bg-white/20"
          >
            Depart
          </button>
        </div>
      </div>
    </main>
  );
}
