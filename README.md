# Why
There are often times you need to work with your windows machine. And can't have all the goodies that comes on a UNIX box. 

I often myself switch between Linux and Windows environment depending on the particular application I would like to run. 

Now, there are many tools specially in GUI in windows but most of the time non of them come quite close with the easiness and handiness to those of UNIX programs like find, grep, vim, etc.

There is cygwin to exactly to that. However I have always found it bit troublesome and time-consuming to just set it up and have it the way I wanted to be. However there a very good wrapper or distribution around cygwin called [babun](http://babun.github.io/) that gets rid of these process and gives you a nice looking zsh shell after installation without being interrupted. 

So I have created a small script(s) to do that as well as automatically install some of my favorite UNIX/cygwin and windows programs(using [chocolatey](https://chocolatey.org/)). 

The code is available at http://github.com/Swoorup/developerify-windows

# Installation
* Download the repo and extract to a directory.
* Just run the developerify.ps1 as a powershell script. It should prompt to elevate to administrator if not running as one. 


# Screenshot
![alt text] (http://i.imgur.com/IXWBiDz.png)

*<p style="text-align: center;"><sub>Disclaimer: Raise an issue if you find any bugs. However, I do not take the responsibility of damages done by this script in any way. Please run it at your own risk. Please read through the code files if in doubts. </sub></p>*

# Update: 2:53 AM 26 December, 2016

I, no longer use babun simply because all the cygwin based tools turned out to be too slow for my work, especially git. I now use msys2. I will update this shortly. If you have Windows 10 that is better, since you would have Windows Subsystem for Linux (WSL). But the only problem I find with it are its inability to run win32 native application, but looks like microsoft has progressed on that area too.
