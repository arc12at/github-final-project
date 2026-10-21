#!/usr/bin/env bash
# =============================================================================
# simple-interest.sh
# -----------------------------------------------------------------------------
# A command-line calculator that computes SIMPLE INTEREST from user input.
#
# Inputs (the three values the user provides):
#   P - Principal amount  : the original sum of money lent or invested (₹)
#   R - Rate of interest  : the yearly interest rate, as a percentage (e.g. 7.5)
#   T - Time period       : how long the money is lent/invested, in years
#
# Formula used:
#   Simple Interest (SI) = (P × R × T) / 100
#   Total Amount     (A) = P + SI
#
#   Why divide by 100? R is entered as a percentage (7.5 means 7.5%), so it
#   must be converted to a fraction (7.5 / 100 = 0.075) before multiplying.
#   "Simple" interest means interest is charged on the ORIGINAL principal only;
#   it does not compound (interest is never added back to earn more interest).
#
# Usage:
#   ./simple-interest.sh               # interactive mode: prompts for P, R, T
#   ./simple-interest.sh P R T         # argument mode, e.g. ./simple-interest.sh 10000 7.5 3
#
# Edge cases handled:
#   - Empty input (user just presses Enter)          -> rejected, asked again
#   - Letters / symbols ("abc", "10k", "$500")        -> rejected, asked again
#   - Negative numbers ("-500")                       -> rejected (a negative
#     principal, rate or time has no real meaning for this calculator)
#   - Malformed decimals ("7.", ".5", "1.2.3")        -> rejected
#   - Wrong number of command-line arguments          -> usage message, exit 1
#   - Invalid value passed as an argument             -> error message, exit 1
#   - Decimal values (e.g. 7.5% or 2.5 years)         -> supported via awk,
#     because Bash's built-in $(( )) arithmetic only works with integers
#   - Zero values (e.g. rate = 0)                     -> allowed; the result
#     is simply ₹0.00 interest, which is mathematically correct
#
# Exit codes:
#   0 - calculation completed successfully
#   1 - invalid arguments were supplied on the command line
# =============================================================================


# -----------------------------------------------------------------------------
# is_number VALUE
# Returns success (0) if VALUE is a non-negative integer or decimal number.
#
# The regular expression ^[0-9]+([.][0-9]+)?$ means:
#   ^[0-9]+        - must START with one or more digits        (e.g. "10")
#   ([.][0-9]+)?   - optionally followed by a dot AND digits   (e.g. ".5")
#   $              - and nothing else may follow
#
# Because there is no "-" allowed in the pattern, negative numbers fail.
# An empty string also fails, because at least one digit is required.
# -----------------------------------------------------------------------------
is_number() {
  [[ "$1" =~ ^[0-9]+([.][0-9]+)?$ ]]
}


# -----------------------------------------------------------------------------
# read_number PROMPT
# Shows PROMPT, reads a line from the user and repeats until the input is a
# valid number. The valid number is printed to stdout so the caller can
# capture it with $( ... ).
#
# Note: the error message is sent to stderr (>&2) on purpose. If it went to
# stdout, it would be captured by $( ... ) together with the number and
# corrupt the value stored in the variable.
# -----------------------------------------------------------------------------
read_number() {
  local prompt="$1"   # 'local' keeps these variables private to the function
  local value

  while true; do
    # -r : treat backslashes literally (don't interpret them as escapes)
    # -p : display the prompt text on the same line as the input
    read -r -p "$prompt" value

    if is_number "$value"; then
      echo "$value"   # valid -> return it to the caller and stop looping
      return
    fi

    echo "  Invalid input. Please enter a positive number (e.g. 1000 or 7.5)." >&2
  done
}


# ----------------------------- Program header --------------------------------
echo "==================================="
echo "    Simple Interest Calculator"
echo "==================================="


# ------------------------- Collect the three inputs --------------------------
# $# holds the number of command-line arguments passed to the script.
if [[ $# -eq 3 ]]; then
  # ARGUMENT MODE: values were given directly, e.g. ./simple-interest.sh 10000 7.5 3
  principal="$1"
  rate="$2"
  time_period="$3"   # not named 'time' to avoid confusion with the shell keyword

  # Arguments can't be re-asked interactively, so if any is invalid we
  # print a clear error and stop with a non-zero exit code.
  for v in "$principal" "$rate" "$time_period"; do
    if ! is_number "$v"; then
      echo "Error: '$v' is not a valid number." >&2
      echo "Usage: $0 <principal> <rate> <time_in_years>" >&2
      exit 1
    fi
  done

elif [[ $# -eq 0 ]]; then
  # INTERACTIVE MODE: no arguments, so ask the user for each value.
  # read_number keeps asking until a valid number is entered.
  principal=$(read_number "Enter the principal amount (₹): ")
  rate=$(read_number "Enter the rate of interest (% per year): ")
  time_period=$(read_number "Enter the time period (in years): ")

else
  # Any other number of arguments (1, 2, 4, ...) is a usage mistake.
  echo "Usage: $0 [<principal> <rate> <time_in_years>]" >&2
  exit 1
fi


# ------------------------------ Calculation ----------------------------------
# Bash arithmetic $(( )) only supports whole numbers, so 7.5 or 2.5 would
# cause an error. awk supports floating-point maths, so we pass the values
# into awk with -v and let it compute the result.
#
# printf "%.2f" rounds the result to 2 decimal places (paise), which is the
# standard way to display currency.
#
# Step 1: SI = (P × R × T) / 100
interest=$(awk -v p="$principal" -v r="$rate" -v t="$time_period" \
  'BEGIN { printf "%.2f", (p * r * t) / 100 }')

# Step 2: Total Amount = P + SI
total=$(awk -v p="$principal" -v si="$interest" \
  'BEGIN { printf "%.2f", p + si }')


# -------------------------------- Output -------------------------------------
# %% prints a literal percent sign inside printf.
echo "-----------------------------------"
printf "Principal       : ₹%.2f\n" "$principal"
printf "Rate            : %s%% per year\n" "$rate"
printf "Time Period     : %s year(s)\n" "$time_period"
echo "-----------------------------------"
printf "Simple Interest : ₹%s\n" "$interest"
printf "Total Amount    : ₹%s\n" "$total"
echo "==================================="

exit 0
