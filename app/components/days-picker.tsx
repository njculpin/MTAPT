"use client";
import { useState } from "react";
export function DaysPicker() {
  const [days, setDays] = useState(1);
  return (
    <div>
      <div className="space-y-4">
        <p className="text-white text-xl">How many days will you attempt?</p>
        <p className="text-white text-md italic">
          {days} days is {days} blocks
        </p>
      </div>
      <div className="mt-6">
        <input
          type="number"
          name="days"
          id="days"
          style={{ fontSize: "32px" }}
          className="block w-full rounded-md border-0 py-1.5 bg-black text-white shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6 p-4"
          value={days}
          onChange={(e) => setDays(Number(e.target.value))}
          min={1}
        />
      </div>
    </div>
  );
}
