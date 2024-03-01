import { characters, equipment } from "./data";
import { CharacterRoster, WeatherForecast, Shop } from "./components";

export default function Home() {
  const days = 7;
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <div className="max-w-7xl w-full justify-center font-mono">
        <div className="mb-32 space-y-4 flex flex-col justify-center items-center text-center">
          <h1 className="text-black text-7xl">Mt Aptos</h1>
          <p className="text-2xl">
            Welcome to Base Camp{" "}
            <span className="text-purple-600">Cafeteria.</span>
          </p>
        </div>
        <WeatherForecast days={days} />
        <CharacterRoster characters={characters} />
      </div>
    </main>
  );
}
