const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      // Adicione suas cores aqui dentro
      colors: {
        'tags-rosa': '#ED215E',
        'tags-cinza': '#4E4E4E', 
        'tags-branco': '#F9FAFB',
        'tags-preto': '#181818',
        'tags-cinza-fundo': '#EFEFEF'
      },
      fontFamily: {
      },
    },
  },
  plugins: []
}