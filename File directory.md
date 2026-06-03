
Normally, in Linux distributions like Arch, they don't naturally create folders for you, but i've gone ahead and done that for you (Pictures, documents, downloads, etc.)

---

Now your first question might be
	*How can I change my files(decoration, keybinds, etc)?*

Well, first lets discuss the directories. If you press Windows + E, it opens your file manager and it should open your directory for /home/{user}. Here is where you can see all of your hidden files, which you normally can't view unless you turn it on (how windows does it as well). 
	*And for the sake of it, we refer to /home/{user} as the symbol "~" or use the pre-defined variable "$HOME"*

~/.local is where a lot of program related files are held, specifically stuff like file storing and how your search bar (Windows + R) is able to show new packages. 

~/.config is where all of your preference/decoration files go. For instance, this is where you'll find the options for your bar at the bottom, which is a program called "Waybar" 
	I like to say that Linux is easier than windows becausthe structure is simple. Its simply /home/user/.config/{program}/{into any file/folder}.
		So for example, I structured your waybar with much priority on organization so it means the structure goes like this < ~/.config/waybar/themes/Subaru/{config or css file}

---

Now that we've discussed the structure of the file system, the way to edit it is through using Text Editors, they're self explanatory but heres an example.
	rnano ~/.config/waybar/themes/Subaru/style.css

This command uses the text editor (nano) and then list the file I want to edit. (The r here just represents restricted, its of no importance).

There are other text editors out there, but i personally like nano, you can choose whatever. For now stick with nano of course. 

---

Also as a reminder, there are different file types that will require you to learn how they work. For instance, Rofi files end with .rasi and they aren't the same as .json files. .css files however are used for decoration/style which is why you'll mostly (if not always) see them called "style".

