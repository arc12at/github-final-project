#!/usr/bin/env bash
#
# simple-interest.sh
# Calculates simple interest from user input.
#
# Formula:
#   Simple Interest (SI) = (P × R × T) / 100
#   Total Amount         = P + SI
#
# Usage:
#   ./simple-interest.sh            # interactive mode (asks for each value)
#   ./simple-interest.sh P R T      # e.g. ./simple-interest.sh 10000 7.5 3

# Check that a value is a non-negative number (integer or decimal)
is_number() {
  [[ "$1" =~ ^[0-9]+([.][0-9]+)?$ ]]
}

# Keep asking until the user enters a valid number
read_number() {
  local prompt="$1" value
  while true; do
    read -r -p "$prompt" value
    if is_number "$value"; then
      echo "$value"
      return
    fi
    echo "  Invalid input. Please enter a positive number (e.g. 1000 or 7.5)." >&2
  done
}

echo "==================================="
echo "    Simple Interest Calculator"
echo "==================================="

if [[ $# -eq 3 ]]; then
  principal="$1"
  rate="$2"
  time_period="$3"
  for v in "$principal" "$rate" "$time_period"; do
    if ! is_number "$v"; then
      echo "Error: '$v' is not a valid number." >&2
      echo "Usage: $0 <principal> <rate> <time_in_years>" >&2
      exit 1
    fi
  done
elif [[ $# -eq 0 ]]; then
  principal=$(read_number "Enter the principal amount (₹): ")
  rate=$(read_number "Enter the rate of interest (% per year): ")
  time_period=$(read_number "Enter the time period (in years): ")
else
  echo "Usage: $0 [<principal> <rate> <time_in_years>]" >&2
  exit 1
fi

# Bash only does integer maths, so use awk for decimal calculation
interest=$(awk -v p="$principal" -v r="$rate" -v t="$time_period" \
  'BEGIN { printf "%.2f", (p * r * t) / 100 }')
total=$(awk -v p="$principal" -v si="$interest" \
  'BEGIN { printf "%.2f", p + si }')

echo "-----------------------------------"
printf "Principal       : ₹%.2f\n" "$principal"
printf "Rate            : %s%% per year\n" "$rate"
printf "Time Period     : %s year(s)\n" "$time_period"
echo "-----------------------------------"
printf "Simple Interest : ₹%s\n" "$interest"
printf "Total Amount    : ₹%s\n" "$total"
echo "==================================="
