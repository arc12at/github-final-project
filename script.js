// Simple Interest Calculator
// Formula: SI = (P × R × T) / 100, where T is in years

const form = document.getElementById("si-form");
const principalEl = document.getElementById("principal");
const rateEl = document.getElementById("rate");
const timeEl = document.getElementById("time");
const unitEl = document.getElementById("unit");
const errorEl = document.getElementById("error");
const resultEl = document.getElementById("result");

const formatINR = (n) =>
  "₹" + n.toLocaleString("en-IN", { minimumFractionDigits: 2, maximumFractionDigits: 2 });

// Convert the entered time to years
function toYears(time, unit) {
  if (unit === "months") return time / 12;
  if (unit === "days") return time / 365;
  return time;
}

function calculateSimpleInterest(principal, rate, years) {
  const interest = (principal * rate * years) / 100;
  return { interest, total: principal + interest };
}

function validate(p, r, t) {
  if ([p, r, t].some((v) => Number.isNaN(v))) return "Please fill in all fields.";
  if (p <= 0) return "Principal must be greater than 0.";
  if (r < 0) return "Rate cannot be negative.";
  if (t <= 0) return "Time must be greater than 0.";
  return "";
}

form.addEventListener("submit", (e) => {
  e.preventDefault();

  const p = parseFloat(principalEl.value);
  const r = parseFloat(rateEl.value);
  const t = parseFloat(timeEl.value);

  const error = validate(p, r, t);
  errorEl.textContent = error;
  if (error) {
    resultEl.classList.add("hidden");
    return;
  }

  const years = toYears(t, unitEl.value);
  const { interest, total } = calculateSimpleInterest(p, r, years);

  document.getElementById("out-principal").textContent = formatINR(p);
  document.getElementById("out-interest").textContent = formatINR(interest);
  document.getElementById("out-total").textContent = formatINR(total);

  document.getElementById("bar-principal").style.width = (p / total) * 100 + "%";
  document.getElementById("bar-interest").style.width = (interest / total) * 100 + "%";

  resultEl.classList.remove("hidden");
});

document.getElementById("reset").addEventListener("click", () => {
  form.reset();
  errorEl.textContent = "";
  resultEl.classList.add("hidden");
  principalEl.focus();
});
