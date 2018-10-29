;
; Text scripts
;

TScript_HappyBirthday:
	TS_NewPos 3, 4
	TS_Speed 1
	TS_Text "  Happy 9th birthday,  "
	TS_Delay 95
	TS_Speed 1
	TS_NewLine
	TS_NewLine
	TS_Text "The Cutting Room Floor!"
	TS_End

TScript_DateOfBirth:
	TS_NewPos 23, 4
	TS_Speed 1
	TS_Text "TCRF"
	TS_Delay 12
	TS_Text ", the wiki"
	TS_Delay 93
	TS_NewLine
	TS_Text "        October 25, "
	TS_Delay 8
	TS_Text "2009"
	TS_Delay 100
	TS_NewLine
	TS_NewLine
	TS_Text "Original"
	TS_Delay 8
	TS_Text " website"
	TS_Delay 95
	TS_NewLine
	TS_Text "       November 20, "
	TS_Delay 8
	TS_Text "2002"
	TS_End

TScript_Test:
	.db TextScript_NewAddress, $20, $a1
	.db TextScript_ChangeSpeed, 2
	.db "Some sample text for the new"
	.db TextScript_DoDelay, 20
	.db TextScript_NewAddress, $20, $e1
	.db TextScript_ChangeSpeed, 5
	.db "'Text Script System'. "
	.db TextScript_DoDelay, 90
	.db TextScript_ChangeSpeed, 45
	.db "..."
	.db TextScript_ChangeSpeed, 2
	.db "yep."
	.db TextScript_NewAddress, $21, $21
	.db TextScript_DoDelay, 60
	.db "It can type"
	.db TextScript_ChangeSpeed, 40
	.db " slow"
	.db TextScript_ChangeSpeed, 10
	.db ", or "
	.db TextScript_ChangeSpeed, 1
	.db "fast."
	.db TextScript_DoDelay, 30
	.db TextScript_NewAddress, $21, $61
	.db TextScript_ChangeSpeed, 2
	.db "It can pause, too."
	.db TextScript_DoDelay, 120
	.db TextScript_ChangeSpeed, 3
	.db " Like that."
	.db TextScript_DoDelay, 180
	.db TextScript_ChangeSpeed, 1
	.db TextScript_NewAddress, $21, $c1
	.db "I think it's pretty neat."
	.db TextScript_End
