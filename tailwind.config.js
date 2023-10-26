/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["Main.gren"],
  theme: {
    extend: {
      boxShadow: {
        'inset': 'inset 0px 1px 10px 6px rgba(0, 0, 0, 0.2)',
        'inset3': 'inset 0px 1px 10px 6px rgba(0, 0, 0, 0.3)',
        'inset-y': 'inset 0px 12px 10px -5px rgba(0, 0, 0, 0.2), inset 0px -12px 10px -5px rgba(0, 0, 0, 0.2)',
        'inset-t': 'inset 0px 12px 10px -5px rgba(0, 0, 0, 0.3)',
        'inset-b': 'inset 0px -12px 10px -5px rgba(0, 0, 0, 0.2)',
        'button': '0px 1px 4px 2px rgba(0, 0, 0, 0.3)',
      }
    },
  },
  plugins: [],
}
