export const conditions = [
  {
    name: "Partly Cloudy",
    thresholds: {
      wind: 10,
      low_temperature: 15,
      high_temperature: 30,
      humidity: 65,
      pressure: 1003,
      precipitation: 15,
      clouds: 50,
    },
    rarity: 5,
    hex: "#F8CA1C",
  },
  {
    name: "Sunny",
    thresholds: {
      wind: 5,
      low_temperature: 18,
      high_temperature: 35,
      humidity: 60,
      pressure: 1005,
      precipitation: 5,
      clouds: 30,
    },
    rarity: 5,
    hex: "#FFD700",
  },
  {
    name: "Scattered Showers",
    thresholds: {
      wind: 15,
      low_temperature: 12,
      high_temperature: 28,
      humidity: 70,
      pressure: 1000,
      precipitation: 25,
      clouds: 70,
    },
    rarity: 4,
    hex: "#4682B4",
  },
  {
    name: "Heavy Rain",
    thresholds: {
      wind: 20,
      low_temperature: 10,
      high_temperature: 25,
      humidity: 75,
      pressure: 995,
      precipitation: 35,
      clouds: 80,
    },
    rarity: 3,
    hex: "#4169E1",
  },
  {
    name: "Scattered Thunder Showers",
    thresholds: {
      wind: 18,
      low_temperature: 15,
      high_temperature: 27,
      humidity: 72,
      pressure: 998,
      precipitation: 40,
      clouds: 75,
    },
    rarity: 3,
    hex: "#1E90FF",
  },
  {
    name: "Fog",
    thresholds: {
      wind: 8,
      low_temperature: 10,
      high_temperature: 20,
      humidity: 80,
      pressure: 995,
      precipitation: 15,
      clouds: 60,
    },
    rarity: 2,
    hex: "#D3D3D3",
  },
  {
    name: "Windy",
    thresholds: {
      wind: 25,
      low_temperature: 10,
      high_temperature: 25,
      humidity: 55,
      pressure: 1000,
      precipitation: 10,
      clouds: 40,
    },
    rarity: 2,
    hex: "#778899",
  },
  {
    name: "Tropical Storm",
    thresholds: {
      wind: 35,
      low_temperature: 20,
      high_temperature: 30,
      humidity: 85,
      pressure: 985,
      precipitation: 50,
      clouds: 90,
    },
    rarity: 1,
    hex: "#87CEEB",
  },
];
