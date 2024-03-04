export function numberToString(num: number): string {
  const units: string[] = [
    "",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
  ];
  const teens: string[] = [
    "Ten",
    "Eleven",
    "Twelve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen",
  ];
  const tens: string[] = [
    "",
    "",
    "Twenty",
    "Thirty",
    "Forty",
    "Fifty",
    "Sixty",
    "Seventy",
    "Eighty",
    "Ninety",
  ];
  const bigNumbers: string[] = [
    "",
    "Thousand",
    "Million",
    "Billion",
    "Trillion",
  ];
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
  if (num === 0) {
    return "zero";
  }
  let result = "";
  let index = 0;
  while (num > 0) {
    const chunk = num % 1000;
    if (chunk > 0) {
      result = `${convertUnderThousand(chunk)} ${bigNumbers[index]} ${result}`;
    }
    num = Math.floor(num / 1000);
    index++;
  }
  return result.trim();
}
