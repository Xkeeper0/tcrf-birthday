Music Files
===========

`music2-ft.asm` here is referenced in `prg-0.asm`. To change it, edit that file.

FamiTracker text-file outputs are not used directly, but must first be
processed into ASM files using the following command/tool:

    python tools/ft_txt_to_asm.py

Note that while there are multiple song files, the sound driver only supports
one _assembly_ file; therefore, all songs must be part of a single FamiTracker
export, and named according to GGSound's expectations.

For more information on GGSound and the converter, see
[GGSound's readme](https://github.com/gradualgames/ggsound/).
