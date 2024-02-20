import { characters, equipment } from "./data";
import {
  CharacterRoster,
  EquipmentCard,
  WeatherForecast,
  DaysPicker,
} from "./components";

export default function Home() {
  const days = 7;
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="max-w-5xl w-full justify-center font-mono">
        <div className="mb-32 space-y-4 flex flex-col justify-center items-center">
          <h1 className="text-white text-7xl">Mt Aptos</h1>
          <p className="text-2xl">
            Welcome to Base Camp{" "}
            <span className="text-purple-600">Cafeteria.</span>
          </p>
        </div>
        <WeatherForecast days={days} />
        <DaysPicker />
        <CharacterRoster characters={characters} />
        <div className="my-16 flex justify-between items-center p-8 bg-gray-950">
          <div>
            <p className="text-white text-3xl">Ready to go?</p>
          </div>
          <button
            type="button"
            className="rounded-md bg-white/10 px-3.5 py-2.5 text-4xl font-semibold text-white shadow-sm hover:bg-gray-700"
          >
            Depart
          </button>
        </div>
        <div className="my-16 flex justify-between items-center p-8 bg-gray-950">
          <div>
            <p className="text-white text-3xl">Need to rest?</p>
          </div>
          <button
            type="button"
            className="rounded-md bg-white/10 px-3.5 py-2.5 text-4xl font-semibold text-white shadow-sm hover:bg-gray-700"
          >
            Rest
          </button>
        </div>
      </div>
    </main>
  );
}
