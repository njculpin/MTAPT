interface Condition {
  name: string;
  thresholds: Weather;
  rarity: number;
  hex: string;
}

interface Weather {
  wind: number;
  low_temperature: number;
  high_temperature: number;
  humidity: number;
  pressure: number;
  precipitation: number;
  clouds: number;
}

export function getWeather({
  conditions,
  days,
}: {
  conditions: Condition[];
  days: number;
}): Condition[] {
  const forecast: Weather[] = generateWeatherForecast({ conditions, days });
  return forecast.map((weather: Weather) =>
    getWeatherCondition({ conditions, weather })
  );
}

function generateWeatherForecast({
  conditions,
  days,
}: {
  conditions: Condition[];
  days: number;
}): Weather[] {
  const forecast: Weather[] = [];
  let previousWeather: Weather = generateRandomWeather(conditions);
  forecast.push(previousWeather);
  for (let i = 1; i < days; i++) {
    let retries = 0;
    let currentWeather: Weather;
    do {
      currentWeather = generateRandomWeather(conditions);
      retries++;
    } while (
      retries < 10 &&
      (compareWeather(previousWeather, currentWeather) ||
        (i > 1 && compareWeather(forecast[i - 2], currentWeather)))
    );
    forecast.push(currentWeather);
    previousWeather = currentWeather;
  }
  return forecast;
}

function compareWeather(weather1: Weather, weather2: Weather): boolean {
  return (
    weather1.wind === weather2.wind &&
    weather1.low_temperature === weather2.low_temperature &&
    weather1.high_temperature === weather2.high_temperature &&
    weather1.humidity === weather2.humidity &&
    weather1.pressure === weather2.pressure &&
    weather1.precipitation === weather2.precipitation &&
    weather1.clouds === weather2.clouds
  );
}

function generateRandomWeather(conditions: Condition[]): Weather {
  const totalRarity = conditions.reduce(
    (acc, condition) => acc + condition.rarity,
    0
  );
  let randomIndex = Math.floor(Math.random() * totalRarity);
  for (const condition of conditions) {
    randomIndex -= condition.rarity;
    if (randomIndex <= 0) {
      return condition.thresholds;
    }
  }
  return conditions[0].thresholds;
}

function getWeatherCondition({
  conditions,
  weather,
}: {
  conditions: Condition[];
  weather: Weather;
}): Condition {
  const similarities: { weather: Condition; similarity: number }[] =
    conditions.map((condition) => {
      const { thresholds } = condition;
      const {
        wind,
        low_temperature,
        high_temperature,
        humidity,
        pressure,
        precipitation,
        clouds,
      } = weather;
      let similarity =
        Math.abs(wind - thresholds.wind) +
        Math.abs(low_temperature - thresholds.low_temperature) +
        Math.abs(high_temperature - thresholds.high_temperature) +
        Math.abs(humidity - thresholds.humidity) +
        Math.abs(pressure - thresholds.pressure) +
        Math.abs(precipitation - thresholds.precipitation) +
        Math.abs(clouds - thresholds.clouds);
      return { weather: condition, similarity };
    });

  similarities.sort((a, b) => a.similarity - b.similarity);
  const minSimilarity = similarities[0].similarity;
  const closestMatches = similarities.filter(
    (match) => match.similarity === minSimilarity
  );

  const randomIndex = Math.floor(Math.random() * closestMatches.length);
  const val = closestMatches[randomIndex];
  return val.weather;
}
