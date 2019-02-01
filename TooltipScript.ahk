#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

;globalVariables
up := False, down := False, left := False, right := False
mode := 0	;When set to 1 direction keys get remapped


;loading the config
commandList := Object()
Loop, Read, %A_WorkingDir%\config.txt
{
    commandList.Push(StrSplit(A_LoopReadLine, "|"))
}

;
>^Numpad0::
>^F20::
	currentCommand := 0
	mode := 1

	loop
	{
		mousegetpos, x, y
		Text := commandList[currentCommand + 1, 1]
		Tooltip, %Text%, (x + 20), (y + 20), 1
		
		if (left){
			left := False
			Tooltip
			mode := 0
			Return
		}
		if (right){
			right := False
			Tooltip
			mode := 0
			Run % commandList[currentCommand + 1, 2]
			Return
		}
		if (up){
			up := False
			currentCommand -= 1
			if(currentCommand < 0){
				currentCommand := commandList.MaxIndex() - 1
			}
		}
		if (down){
			down := False
			currentCommand += 1
			currentCommand := Mod(currentCommand, commandList.MaxIndex())
		}
		
		Sleep 30
	}
	Tooltip
	mode := 0
Return

;remapping direction keys when needed
#if mode = 1
Left::
	left := True
Return

Right::
	right := True
Return

Up::
	up := True
Return

Down::
	down := True
Return

#if