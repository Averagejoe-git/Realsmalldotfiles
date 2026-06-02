
To start, you should know about what SU and SUDO is 

SU - Super User
SUDO - Super User DO


At first, you'll notice that Sudo is used in alot of commands, specifically targeting ones that require a higher level of privileges. And yes, that is what it does, it's used in a ton of commands that require "root" or admin privileges. The reason why its named root, is because it refers your sensitive files and if anyone had this level of access (such as your root password), then they could delete your entire system. 

---

Next is pacman.

The command "pacman" is used for a variety of things; however, it's particularly for maintaining your packages. Because we simply wouldn't want someone to download packages, we use Sudo along with pacman to raise its privileges.
	Although the pacman commands can still be used, they won't really do much unless you're doing lower level commands such as viewing installed packages/a specific package.

Now, the command <sudo pacman> isn't used alone but requires an action that tells the computer what you want it to do. For the most part, you really only need to know what the -S, -y, -u, -r, -Sc commands do. if you wanted to find out more just use "man" which is a "reference manual." 
	***A BIG REMINDER THAT ANY TIME YOU REFER TO A FLAG/ACTION, THE CAPITALIZATION MATTERS BECAUSE -S AND -s are different commands.***

1. -S
	this "flag" or action refers to "sync' ACTION
2. -y
	refreshes the database to look for updated/new packages. 
3. -u
	dependign on what its used with, its mostly used for updating or upgrading packages (they mean the same thing). 

using these three flag together is how you update your system and you will need to at least once a week, otherwise your system could break. 

 So, the command goes, sudo pacman -Syu

Couple of last things i wanna go by 

sudo pacman -S <package.name>
	is how you install packages

sudo pacman -R <package.name>
	Is how you remove packages from your system

pacman -Q <package.name>
	how you search for installed packages

sudo pacman -Sc (or) sudo pacman -Scc (<-- the aggressive version>) Is how you get rid of cache and such. 


===

WARNING: NEVER EVER RUN `sudo pacman -Sy` OR ANY "INCOMPLETE" COMMAND BECAUSE IT WILL BREAK YOUR SYSTEM, ITS NOT MEANT TO ONLY SYNC AND REFRESH IT NEEDS TO UPGRADE AS WELL.

----------------------------


ALSO, i know you don't read code so if you ever need help just ask me or look up how to use "journalctl" for error/crash logs. 



