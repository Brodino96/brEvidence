/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{html, js, ts, pcss}"],
  theme: {
    extend: {
      boxShadow: {
        '3xl': '0 35px 60px -15px rgba(0, 0, 0, 0.7)',
      }
    },
  },
  plugins: [
    require('@tailwindcss/typography')
  ],
}

