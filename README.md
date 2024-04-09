# PNWMD - Pacific Northwest Meditation Deathmatch installation
This project was built by Brey Tucker, Alyssa Haas and Greg Borreson with the assistance of an art installation grant from Bass Coast Festival for 2018. It was inspired by and borrows the base premise from previous Meditation Deathmatch projects but took some of its own liberties. Participants were affixed with EEG headbands to measure their brainwaves and then competed to RELAX HARDER in a deeply distracting environment while being alternately heckled and read passages from very dry books via megaphone.

Two Processing 3 sketches included:
 - PNWMD_diagnostic_stars: LED testing and a passive visualizer for when the installation was not in service
 - PNWMD_brains_phyllo: OSC receiver for Muse headbands, chillness scoring & chillness-responsive visualizer
 
Hardware we used:
 - a laptop running the sketches
 - two Muse 2016 headbands
 - two smartphones running Muse Direct forwarding data to the sketch via OSC
 - a Wi-Fi router for those smartphones and some ethernet connectivity
 - a HeroicRobotics PixelPusher LED driver connected by ethernet
 - two large plywood & steel meditation pods with a whole lot of WS2813 LED strips in them each


# Update - dusting off April 9, 2024
Heroic Robotics & their library for the PixelPusher seem to have evaporated into history, but I tracked down a copy of the library in someone else's project, and put it in the libraries directory here. It's probably easier just to install this into your Processing libraries folder (defaults to `~/Documents/Processing/libraries` on MacOS) rather than ripping out all the code that uses it. Copy the PixelPusher folder there.

The sketch should work fine with no actual PixelPusher hardware present. It seems like this works, at least enough for the sketch to run, with the current Processing 4.3 on MacOS.

You'll also need to install (through Processing's contributed libraries) the oscP5 library, to be able to receive OSC messages from the Muse headbands.

See comments at the start of PNWMD_brains_pyhllo.pde for details about the scoring system and visualizer, and the keyboard commands for starting/restarting a match.

Note that the Console is very spammy, updating with the latest received values from the headbands continuously. If you're trying to diagnose anything else that might show up in there, comment out the `println`s on lines 226, 227, 234 & 235 of the main sketch. However, if you're trying to see if you're getting appropriate OSC communications from the Muse app, this spam can be helpful.

I haven't touched the Muse hardware or app in a while, so I don't know if things even still work similarly to how they did before.
