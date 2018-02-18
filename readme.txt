A Markov chain for generating new Lessons of Vivec

I was playing Morrowind, and whilst reading one of the "36 Lessons of Vivec," two thoughts came to me in rapid succession:
	1) These things read like a Markov chain generator wrote them
	2) I should write a Markov chain generator to generate new lessons!
So I did.

This is just something silly I made for fun.

-----------------------------------

To work it and generate your own lessons:

Simply put the lessons you wish to "train" it on into a sub-directory of the lessons_of_vivec_generator directory (they don't actually have to be the 36 Lessons, you can train it on anything, but it will but the ending of the words at the end).

	Note: the files should be in *.txt format. If you don't want to parse txt for some reason, change the pattern in the script.

Then, from a shell (could be Linux, Windows, or Mac), type "ruby lessons_generator.rb" and press enter.

The new lesson will get generated, and output in the shell, as well as written to a file called "new_lesson.txt" in the main directory.

Note that if you run the script again, it will overwrite the last lesson you generated. So back them up if you like them and want to keep them!