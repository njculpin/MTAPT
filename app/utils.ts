export function numberToString(num: number): string {
  // Define arrays for numbers and their string representations
  const units: string[] = [
    "",
    "one",
    "two",
    "three",
    "four",
    "five",
    "six",
    "seven",
    "eight",
    "nine",
  ];
  const teens: string[] = [
    "ten",
    "eleven",
    "twelve",
    "thirteen",
    "fourteen",
    "fifteen",
    "sixteen",
    "seventeen",
    "eighteen",
    "nineteen",
  ];
  const tens: string[] = [
    "",
    "",
    "twenty",
    "thirty",
    "forty",
    "fifty",
    "sixty",
    "seventy",
    "eighty",
    "ninety",
  ];

  // Define the big numbers (powers of ten)
  const bigNumbers: string[] = [
    "",
    "thousand",
    "million",
    "billion",
    "trillion",
  ];

  // Function to convert numbers below 1000
  function convertUnderThousand(n: number): string {
    let str = "";
    const hundred = Math.floor(n / 100);
    if (hundred > 0) {
      str += `${units[hundred]} hundred`;
      n %= 100;
      if (n > 0) {
        str += " and ";
      }
    }
    if (n >= 20) {
      const ten = Math.floor(n / 10);
      str += tens[ten];
      n %= 10;
      if (n > 0) {
        str += " ";
      }
    }
    if (n >= 10 && n < 20) {
      str += teens[n - 10];
      n = 0;
    }
    if (n > 0) {
      str += units[n];
    }
    return str;
  }

  // Handle the special case of zero
  if (num === 0) {
    return "zero";
  }

  let result = "";
  let index = 0;

  // Process the number in groups of three digits
  while (num > 0) {
    const chunk = num % 1000;
    if (chunk > 0) {
      result = `${convertUnderThousand(chunk)} ${bigNumbers[index]} ${result}`;
    }
    num = Math.floor(num / 1000);
    index++;
  }

  // Clean up any extra whitespace and return the result
  return result.trim();
}
