# atom-2048 package
Playing the interesting 2048 game right inside atom.

![2048-in-atom](https://raw.github.com/void-main/atom-2048/master/2048-in-atom.gif)

## Installation
You can install `atom-2048` either use the Atom package manager, which can be found in the Settings view, or run `apm install atom-2048` from the command line.

## How to play
### The normal way
After installation, you can find the toggle in menu `Packages -> atom-2048`, or you can simple press `ctrl-alt-a` to start and stop the game.

Once the view is loaded as demonstrated in the gif animation above, you can play the game simply as you are in a browser. You'll see your high scores, and you can reset the game by hit `spacebar`. Go wild!

NOTE: all the directions arrows can cause the cursor move around the editor view, so they are disabled in `atom-2048`, you can use direction keys, `WASD` keys or `vim` keys to move the tiles!

### boss-is-coming mode!
We all know what `boss-is-coming` mode is! :P

While playing the game, you simply hit `esc`, and everything will be gone! But don't worry, your progress is not destoryed. Wherever you feel safe, simple press `ctrl-alt-c`, and everything will show up again.  A little heads up, if you accidentally hit `ctrl-alt-a`, your progress will not be preserved, so, use carefully!

### Power mode!!
Inspired by [activate-power-mode](https://github.com/JoelBesada/activate-power-mode), you can enable power mode in package settings. Check out the demo gif:
![power-mode](https://raw.github.com/void-main/atom-2048/master/power-mode-demo.gif)

## Achievements
With the help of [achievements package](https://atom.io/packages/achievements) developed by [@rgbkrk](https://github.com/rgbkrk), you can play the game and get achievements! See the image below!

![achievements-for-2048](https://raw.github.com/void-main/atom-2048/master/achievements-for-2048.png)

NOTE: to get achievements, you have to install [achievements package](https://atom.io/packages/achievements) first!

## Change Log
- 1.0.0 Initial full transplanted game
- 1.1.0 Add `boss-is-coming` mode as proposed by [@christhekeele](https://github.com/christhekeele) in issue [#1](https://github.com/void-main/atom-2048/issues/1)
- 1.2.0 Add `achievement` system using [achievements package](https://atom.io/packages/achievements) developed by [@rgbkrk](https://github.com/rgbkrk). Reference issue [#2](https://github.com/void-main/atom-2048/issues/2)
- 1.2.1 Fix the fatal [blocking `b` key issue](https://github.com/void-main/atom-2048/issues/3)!
- 1.2.2 Add advertisement for achievements package
- 1.2.3 Change to `esc` key for `boss-is-coming` mode as discussed in issue [#3](https://github.com/void-main/atom-2048/issues/3)
- 3.0.0 Remove some deprecated APIs for new version of atom
- 3.1.0 Add `Power Mode` inspired by [activate-power-mode](https://github.com/JoelBesada/activate-power-mode), you can enable power mode or set power level in package settings

## Known issue
With new atom, I can't use `document.addEventListener`, but using `atom.views.getView(atom.workspace).addEventListener "keydown"` will not prevent keydown event to atom workspace. So, when you play the game with editor view open, you can see the cursor is moving when you press direction keys.

## Credits
Credit goes to the fantastic [2048](https://github.com/gabrielecirulli/2048) game and the [original version 1024](https://play.google.com/store/apps/details?id=com.veewo.a1024).
