// This is the configuration file for Kanji startpage. Basic settings are here.

var data = {

    // -------------------------------------------------
    // Greetings config. Change greetings from here

    g1: "おやすみなさい", // From 23:00 to 5:00
    g2: "おはようございます", // Until 12:00
    g3: "こんにちは", // Until 17:00
    g4: "おやすみなさい", // Rest of the time

    // Font size of the greeting
    greeting_fontsize: "40px",
    // Foreground color of the greeting
    greeting_fgcolor: "#c795ae",

    // -------------------------------------------------
    // Clock config

    // Enable/disable clock
    clock: true,
    // Foreground color of the clock
    clock_fgcolor: "#c785ae",
    // Font size of the clock
    clock_fontsize: "20px",

    // -------------------------------------------------
    // Change image proprieties from here

    // Border radius: set it to 50% to create a circle
    image_radius: "10px",
    // Border for the image
    image_border: "0px solid",
    // Color of the border
    image_bordercolor: "#ba8991",
    // Filters for the image.
    image_filter: "grayscale(56%) brightness(60%)",
    // Width/height for the image
    image_width: "350px",
    // Image source: you can use local files, or a link
    // Ex.: image_source: "/img/kanji.jpg"
    image_source: "/home/hakuya/.mozilla/firefox/26xsrevv.default-release/homepage/Kanji/img/kanji.jpg",

    // -------------------------------------------------
    // Enable/disable site icons
    enable_icons: false,

    // -------------------------------------------------
    // Page title
    title: "ここから始める",

    // -------------------------------------------------
    // Change search bar proprietis from here
    // Search bar placeholder
    search_placeholder: "Search here",
    // Search engine
    // Possible choices: (case sensitive)
    // google
    // duckduckgo
    // qwant
    // startpage
    // ecosia
    // youtube
    search_engine: "duckduckgo"

}
