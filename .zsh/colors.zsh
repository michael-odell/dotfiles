#!/usr/bin/env zsh

# This sourceable file creates a `color` associative array which is specific to the current terminal
# (i.e. value of $TERM) but contains style and color codes useful for making colored, styled
# terminal output
#
# The process involves a lot of forking to capture output of commands and hence it takes a
# non-negligible amount of time though, so my goal is to change it into a script that generates the
# color array and caches it into a file (probably one per $TERM value) that can be sourced on shell
# or startup cheaply.

typeset -AHg color

# Synonyms for reset
color[reset]=$(echoti sgr0)
color[off]=${color[reset]}
color[nocolor]=${color[reset]}

color[bold]=$(echoti bold)

color[underline]=$(echoti smul)
color[nounderline]=$(echoti rmul)

color[ul]=${color[underline]}
color[noul]=${color[nounderline]}

color[italic]=$(echoti sitm)
color[noitalic]=$(echoti ritm)


# There is no true standard for the color codes, which in this case are going to be used with the
# terminal capability "setaf" or "setab", but these names have served me well.
#
# If you want to go down the rabbit hole, look at this stack exchange question and things linked
# from it:
#
#    https://unix.stackexchange.com/questions/269077/tput-setaf-color-table-how-to-determine-color-codes
#
local -A color_num

color_num[black]=0
color_num[red]=1
color_num[green]=2
color_num[yellow]=3
color_num[blue]=4
color_num[magenta]=5
color_num[cyan]=6
color_num[white]=7

color_num[grey0]=16
color_num[navyblue]=17
color_num[darkgreen]=22
color_num[deepskyblue]=24
color_num[dodgerblue]=26
color_num[springgreen]=35
color_num[darkturqouise]=44
color_num[turquoise]=45
color_num[blueviolet]=57
color_num[orange]=58
color_num[slateblue]=62
color_num[paleturquoise]=66
color_num[steelblue]=67
color_num[cornflowerblue]=69
color_num[aquamarine]=79
color_num[darkred]=88
color_num[darkmagenta]=90
color_num[plum]=96
color_num[wheat]=101
color_num[lightslategrey]=103
color_num[darkseagreen]=108
color_num[darkviolet]=128
color_num[darkorange]=130
color_num[hotpink]=132
color_num[mediumorchid]=134
color_num[lightsalmon]=137
color_num[gold]=142
color_num[darkkhaki]=143
color_num[indianred]=167
color_num[orchid]=170
color_num[violet]=177
color_num[tan]=180
color_num[lightyellow]=185
color_num[honeydew]=194
color_num[salmon]=209
color_num[pink]=218
color_num[thistle]=225

color_num[grey100]=231
color_num[grey3]=232
color_num[grey7]=233
color_num[grey11]=234
color_num[grey15]=235
color_num[grey19]=236
color_num[grey23]=237
color_num[grey27]=238
color_num[grey30]=239
color_num[grey35]=240
color_num[grey39]=241
color_num[grey42]=242
color_num[grey46]=243
color_num[grey50]=244
color_num[grey54]=245
color_num[grey58]=246
color_num[grey62]=247
color_num[grey66]=248
color_num[grey70]=249
color_num[grey74]=250
color_num[grey78]=251
color_num[grey82]=252
color_num[grey85]=253
color_num[grey89]=254
color_num[grey93]=255

local setaf="$(echoti setaf)"
local setab="$(echoti setab)"

for name in ${(k)color_num} ; do
    color[$name]="$(echoti setaf ${color_num[$name]})"
    color[bg_$name]="$(echoti setab ${color_num[$name]})"
done

for i in {1..255} ; do
    color[$i]="$(echoti setaf $i)"
    color[bg_$i]="$(echoti setab $i)"
done
