# getlamp-game - Turbo C

This version of the game has been implemented using Borland Turbo C v3.0, emulated using DOSBox v0.74.

## Running on Windows 10

1. Download and install DOSBox from https://www.dosbox.com/download.php?main=1.

1. Download the Borland Turbo C compressed installation package from http://www.mediafire.com/file/x3k5k6z7unonnou/Borland_Turbo_C%252B%252B_v3.0_%2528C_Compiler%2529.rar/file and extract it to a local folder (e.g. C:\turbo).

1. Start DOSBOX and mount the local folder (e.g. C:\Turbo) to a virtual drive (C:) on DOS:
`mount c c:\turbo`

1. Add TC.EXE to the path:
`set PATH=Z:\;c:\TC\BIN`

1. You can now run `TC` in order to start Turbo C.

1. Copy the source files from this repo to the c:\turbo local directory, and have fun.

The steps to install Turbo C with DOSBox can also be found at https://www.youtube.com/watch?v=NAjhj0LHOjg.

## References

I used some ideas from the Little Cave Adventure tutorial: https://home.hccnet.nl/r.helderman/adventures/htpataic01.html

If you're looking for a neater and more complete implementation of a text adventure in C than my example, the tutorial above is a good next step.




