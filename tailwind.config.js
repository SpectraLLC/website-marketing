module.exports = {
  // Tailwind scans these files to decide which utility classes to include in main.css.
  // Add new template folders here if you create them.
  content: [
    "./_layouts/**/*.html",
    "./_includes/**/*.html",
    "./*.{html,md}",
    "./campaigns/**/*.{html,md}"
  ],
  theme: {
    extend: {
      // Project color palette. Change these values to restyle the site globally.
      colors: {
        mist: {
          50: "#f7f9f9",
          100: "#eff2f2",
          200: "#e3e7e9",
          300: "#d5dbde",
          400: "#b0bbc0",
          500: "#8f9ba1",
          600: "#6e7a82",
          700: "#59636b",
          800: "#414a52",
          900: "#343b42",
          950: "#252a31"
        }
      },
      // Fonts are loaded in assets/css/input.css, then named here for Tailwind classes.
      fontFamily: {
        display: ["Mona Sans", "Inter", "ui-sans-serif", "system-ui", "sans-serif"],
        sans: ["Inter", "ui-sans-serif", "system-ui", "sans-serif"]
      },
      // Custom elevation tokens can be referenced from templates if needed.
      boxShadow: {
        hero: "0 30px 80px rgba(37, 42, 49, 0.12)"
      }
    }
  },
  plugins: []
};
