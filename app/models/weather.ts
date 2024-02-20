export interface Weather {
  id: number;
  name: string;
  hex: string;
  adj: number[];
}

export function getWeather({
  weather,
  days,
}: {
  weather: Weather[];
  days: number;
}): Weather[] {
  const forecast: Weather[] = [];
  const randomIndex = Math.floor(Math.random() * weather.length);
  let next = weather[randomIndex];
  forecast.push(next);
  for (let i = 1; i < days; i++) {
    const adjacency = next.adj;
    const randomIndex = Math.floor(Math.random() * adjacency.length);
    const value = adjacency[randomIndex];
    const randomStart = weather.find((x) => x.id === value) || weather[0];
    next = randomStart;
    forecast.push(next);
  }
  return forecast;
}
