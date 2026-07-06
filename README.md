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


----

**PLAN**
Cards are played as individual notes (white + not pressed = inactive, gray + pressed = active - test this to see if its clear enough, perhaps the inverse is better).

"Jokers" add modifiers. i.e. Every played "C" gives +5 mult, Each note played adds its "Perfect 5th" etc...

Taking a turn is undecided, first idea is that the "board" is 5 octaves of a piano. Each "Card" played adds that card's note to the octave (moving only up to octave to avoid dissonance on playback). 
    - There are many ways to build on this, or perhaps change this. It could make more sense to reduce it down to 2 octaves, and allow playing of x amount of notes which compound.

Perhaps cards can have rarities? i.e. Sometimes they will spawn with an additional note, even more rare it may spawn with 2 or 3 extra.

Round of play example:
1. Player has a card that adds 5 Mult to each white note played, and +20 Mult if all notes played are part of the same pentatonic scale
2. Player decides to play his notes "C", "D", "G", "C" and another "C".
3. This results in *base score* * `15 (3 C's Played)` * `20 (all notes pentatonic)`
