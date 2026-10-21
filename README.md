# Simple Interest Calculator

A clean, responsive web app that calculates **simple interest** and the **total amount** from a principal, rate, and time period. Built with plain HTML, CSS, and JavaScript — no frameworks, no build step.

## Features

- Calculates simple interest and total amount instantly
- Time can be entered in **years, months, or days**
- Input validation with clear error messages
- Amounts formatted in Indian Rupees (₹, en-IN grouping)
- Visual bar showing the principal vs. interest split
- Responsive layout for mobile and desktop
- Pastel glassmorphism design (lavender, peach & sage palette) with Poppins + DM Serif Display fonts
- Automatic light/dark mode based on system settings

## Formula

```
SI    = (P × R × T) / 100
Total = P + SI
```

| Symbol | Meaning                          |
|--------|----------------------------------|
| P      | Principal amount                 |
| R      | Rate of interest (% per year)    |
| T      | Time in years                    |

Months are converted as `T = months / 12` and days as `T = days / 365`.

**Example:** P = ₹10,000, R = 7.5%, T = 3 years → SI = ₹2,250, Total = ₹12,250

## Project Structure

```
github-final-project/
├── index.html   # Page structure
├── style.css    # Styling (light/dark themes)
├── script.js    # Calculation and validation logic
├── simple-interest.sh  # Command-line (Bash) version
├── LICENSE      # Apache License 2.0
├── CODE_OF_CONDUCT.md
├── CONTRIBUTING.md
└── README.md
```

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/arc12at/github-final-project.git
   cd github-final-project
   ```
2. Open `index.html` in any modern browser.

That's it — no installation required.

## Command-Line Version (Bash)

`simple-interest.sh` is a terminal version of the calculator. It asks for the principal, rate of interest and time period, then prints the simple interest and total amount.

```bash
chmod +x simple-interest.sh   # first time only
./simple-interest.sh          # interactive: enter each value when asked
./simple-interest.sh 10000 7.5 3   # or pass P, R, T directly
```

Sample output:

```
Principal       : ₹10000.00
Rate            : 7.5% per year
Time Period     : 3 year(s)
-----------------------------------
Simple Interest : ₹2250.00
Total Amount    : ₹12250.00
```

Invalid inputs (letters, negative numbers) are rejected with a message.

## Live Demo (GitHub Pages)

To host it for free:

1. Go to the repository's **Settings → Pages**.
2. Under **Source**, select the `main` branch and `/ (root)` folder.
3. Save — your site will be live at `https://arc12at.github.io/github-final-project/`.

## Tech Stack

- HTML5
- CSS3 (custom properties, flexbox, media queries)
- Vanilla JavaScript (ES6)
- Bash (command-line version)

## Contributing

All contributions, bug reports, bug fixes, documentation improvements, enhancements, and ideas are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## Code of Conduct

Please read the [Code of Conduct](CODE_OF_CONDUCT.md) before contributing.

## License

This project is licensed under the [Apache License 2.0](LICENSE).
