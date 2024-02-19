interface LandAttributes {
  location: LocationAttributes;
}

interface LocationAttributes {
  x: number;
  y: number;
}

function haversine(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number
): number {
  const R: number = 6371; // Radius of the Earth in kilometers
  const dLat: number = toRadians(lat2 - lat1);
  const dLon: number = toRadians(lon2 - lon1);
  const a: number =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(toRadians(lat1)) *
      Math.cos(toRadians(lat2)) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c: number = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const distance: number = R * c;
  return distance;
}

function toRadians(degrees: number): number {
  return degrees * (Math.PI / 180);
}

function calculateTotalDaysToTravel(
  lat1: number,
  lon1: number,
  lat2: number,
  lon2: number,
  maxTimeInHoursPerDay: number,
  walkingSpeedKmph: number
): number {
  const totalDistance: number = haversine(lat1, lon1, lat2, lon2);
  const averageWalkingSpeed: number = walkingSpeedKmph; // km per hour
  const totalHoursToTravel: number = totalDistance / averageWalkingSpeed;
  const totalDays: number = totalHoursToTravel / maxTimeInHoursPerDay;
  return Math.round(totalDays) * 2;
}

// Palo Alto
const pointALatitude: number = 37.4427656;
const pointALongitude: number = -122.1618973;

// LA
const pointBLatitude: number = 34.0522;
const pointBLongitude: number = -118.2437;

//
const maxTimeInHoursPerDay: number = 8; // Maximum time traveled per day
const walkingSpeedKmph: number = 5; // Assume walking speed of 5 km/h

const totalDaysToTravel: number = calculateTotalDaysToTravel(
  pointALatitude,
  pointALongitude,
  pointBLatitude,
  pointBLongitude,
  maxTimeInHoursPerDay,
  walkingSpeedKmph
);
console.log(
  "Total number of days to travel from point A to point B:",
  totalDaysToTravel
);
