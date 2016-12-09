# Crazy Eights

Play crazy eights against the computer


### Setup:
Make sure you have elm installed.
Clone this repo into a new project folder, e.g. `my-elm-project`:

```
git clone https://github.com/tajohnson661/elm-crazy-eights my-elm-project
cd my-elm-project
npm install
elm package install
```



### Serve locally:
```
npm start
```
* Access app at `http://localhost:8080/`
* The entry point file is `src/elm/Main.elm`
* Browser will refresh automatically on any file changes..


### Tests:
```
elm-test
```
### Build & bundle for prod:
```
npm run build
```

* Files are saved into the `/dist` folder
* To check it, open `dist/index.html`

### Elm Development Notes:


### Game Development Notes:

* Dealer only plays an eight if nothing else to play
* If the deck to draw cards from is empty, I refill/shuffle the cards right away instead of when the user needs to draw.  This will help with the UI in showing the current state
* One known situation I don't handle: If the player and dealer hold all the cards in their hands (nothing in the draw pile and nothing in the discard pile), and then the player plays a card, I don't reset the draw pile.  Super edge case, so who cares.

