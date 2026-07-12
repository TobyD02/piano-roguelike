# Piano Roguelike

## IDEAS
- Chain piano blocks together, to create harmonies etc...
	- Would require modifying card backgrounds again - since they will be just borders around the piano block itself.
	- Playing a turn would be selecting different piano blocks, which would line up against each other (to form a longer piano roll).
	- Harmonies would then be score (will have to figure out how to do this)
		- Need to figure this out.

- Notes have modifiers rather than blocks (or as well as)
	- Rather than generating each block with a random color, instead have all notes by default as white (or perhaps alternate white and grey for clarity??? maybe not im not sure)
	- Then, notes can be converted to yellow (gold), red, blue, green, etc... 
	- When scored, they will provide additional effects, e.g.:
		- gold: more money?
		- red: mult
		- blue: points
		- green: etc... (idk think balatro)

- Perhaps cards can have rarities? i.e. Sometimes they will spawn with an additional note, even more rare it may spawn with 2 or 3 extra.

- Cards on hover should show details above, i.e. what notes they have, what harmonies (i.e. Perfect 5th, Minor 3rd, Major Chord, etc...)
	- Perhaps when selecting a hand you can see the synergies between all selected cards? need to figure this out.

----

**PLAN**
Cards are played as individual notes (white + not pressed = inactive, gray + pressed = active - test this to see if its clear enough, perhaps the inverse is better).

"Jokers" add modifiers. i.e. Every played "C" gives +5 mult, Each note played adds its "Perfect 5th" etc...

Taking a turn is undecided, first idea is that the "board" is 5 octaves of a piano. Each "Card" played adds that card's note to the octave (moving only up to octave to avoid dissonance on playback). 
    - There are many ways to build on this, or perhaps change this. It could make more sense to reduce it down to 2 octaves, and allow playing of x amount of notes which compound.


Round of play example:
1. Player has a card that adds 5 Mult to each white note played, and +20 Mult if all notes played are part of the same pentatonic scale
2. Player decides to play his notes "C", "D", "G", "C" and another "C".
3. This results in *base score* * `15 (3 C's Played)` * `20 (all notes pentatonic)`

----

## Next Changes

Ok - what I really need to think about is gameplay. Firstly - I think cards should span 2 octaves? Once they have undergone harmonic analysis, this should be stored as part of the card. At that point, the card be reorganised so that the root note is the lowest. 

In terms of gameplay, is playing chords really the best idea? What about if you played single notes? all these notes would then add into some 3 octave piano in the middle, resulting in different harmonies etc... Then, rather than each card having its own harmonic profile (Chord class), the resulting played hand would instead. This can be assessed based on voicings etc... (which i will no longer have to shuffle for since i can just use the inversion played by the player). Different alterations can result in different scoring mechanisms etc... 

Need to think about how the gameplay progresses/accelerates as the game goes on as well. i.e. obviously notes can be modified (colours) to have unique effects, but is there something perhaps to do with:- Number of notes the player can play
- Number of octaves?
- Notes retriggering?
- Notes becoming the root of a new chord (or perhaps triggering all subchords from its root - i.e. `c e g b d` could trigger "cmaj", "cmaj7", "cmaj9")

----

## Next Changes (12/07/2026)
- Need to improve harmonic analysis still - its working, but I dont agree with alot of the classifications.
- Also - need to implement some sort of scoring, and better display for played cards (chords)
