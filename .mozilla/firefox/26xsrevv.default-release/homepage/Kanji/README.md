![bg](bg.png)

![licence](https://img.shields.io/github/license/alededorigo/kanji?color=%23cd58f4&style=for-the-badge) ![release](https://img.shields.io/github/v/release/alededorigo/kanji?color=ee4f84&include_prereleases&style=for-the-badge) ![lastcommit](https://img.shields.io/github/last-commit/alededorigo/kanji?color=%231ce590&style=for-the-badge)

<br />

# A minimal startpage for the browser
  
## Release 2.1 <img alt="" align="right" src="https://img.shields.io/github/repo-size/alededorigo/kanji?color=%2358d0f4&style=for-the-badge"/>

<a href="https://github.com/Alededorigo/Kanji/releases/tag/2.1">
  <img style="border-radius: 4px" src="https://res.cloudinary.com/dn3cdvdix/image/upload/v1615294890/image_2021-03-09_14-00-52_xiacwg.png" alt="preview" align="right" width="400px"/>
</a>


Changelog <kbd>version 2.1</kbd>:
* Updated config.js: you can configure the startpage with a config file ([config.js](https://github.com/Alededorigo/Kanji/blob/main/config.js))
* Changed clock font style
* Fixed favicon errors
* Made the search bar placeholder configurable
* Added the ability to change search engine in the config file
* Fixed some bugs in the HTML file

<br />

# Set up

<img style="border-radius: 4px" src="https://res.cloudinary.com/dn3cdvdix/image/upload/v1615300936/preview_nosmbp.gif" alt="screenshot"/>

## Extensions:
* For Firefox use "Custom New Tab Page"
* For Chrome use "Custom New Tab"

## Usage:
- On the new tab: use one of the [extensions](#extensions) mentioned

- On the home page:
    * Firefox: Go into
    ```Preferences > Home > Homepage and new windows```
    * Chrome: Go into
    ``` Options > Start > Homepage```

## Changing links:
```html
<div class="column">
    <p>COLUMN NAME</p>
    <!-- Sostitute "link" with "null" if you want a blank link -->
    <!-- Many websites uses favicon.ico as icon. If you don't find it smiply download a png/ico/svg icon and put its path <img src="HERE"> -->
    <a class="link" href="WEBSITE LINK"><img src="WEBSITE/favicon.ico">WEBSITE NAME</a>
    <!-- To make a link opening in a new tab, add 'target="_BLANK"' inside the link tag -->
    <a target="_BLANK"></a>
</div>
```

## Resources that i used:
* Mt Fuji picture: [WallpaperCave](https://wallpapercave.com/mt-fuji-wallpaper)
* Fonts: see [HTML file](https://github.com/Alededorigo/Kanji/blob/main/index.html)

## Credits:
* [Font for greetings](https://www.1001fonts.com/electroharmonix-font.html)
* [Image on left](https://wallpapercave.com/mt-fuji-wallpaper)