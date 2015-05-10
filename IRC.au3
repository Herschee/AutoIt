;===============================================================================
; Description:      Connects to IRC Server with given nick (see below)
; Parameter(s):     $server: IRC Server
;                   $port: Port (6667)
;                   $nick: Nickname
; Requirement(s):   TCPStartup () called beforehand
; Return Value(s):  On Success: socket
;                   On Failure: on error
; Author(s):        Hersche
; Note(s):          Reserved
;===============================================================================
Func _IRCConnect ($server, $port, $nick)
	Local $_i = TCPConnect(TCPNameToIP($server), $port)

	If $_i = -1 Then
		Exit MsgBox(1, "IRC.au3 Error", "Server " & $server & " is not responding.")

		TCPSend($_i, "NICK " & $nick & @CRLF)
		TCPSend($_i, "USER " & $nick & " 0 0 " & $nick &@CRLF)
	EndIf

	Return $_i
EndFunc

;===============================================================================
; Description:      Joins an IRC Channel
; Parameter(s):     $irc: Socket returned from a successful _IRCConnect ()
;                   $chan: IRC Channel
; Requirement(s):   _IRCConnect () called beforehand
; Return Value(s):  On Success: 1
;                   On Failure: -1  (Server disconnected)
; Author(s):        Hersche
; Note(s):          Reserved
;===============================================================================
Func _IRCJoinChannel ($irc, $chan)
	If $irc = -1 Then Return 0

	TCPSend($irc, "JOIN " & $chan & @CRLF)

	If @error Then
		MsgBox(1, "IRC.au3", "Server has disconnected.")
		Return -1
	EndIf

	Return 1
EndFunc

;===============================================================================
; Description:      Sends message to IRC
; Parameter(s):     $irc - Socket returned from _IRCConnect ()
;					$msg - Message to send
;                   $chan - Channel recipient
; Requirement(s):   _IRCConnect () called beforehand
; Return Value(s):  On Success: 1
;                   On Failure: -1 (Server disconnected)
; Author(s):        Hersche
; Note(s):          Reserved
;===============================================================================
Func _IRCSendMessage ($irc, $msg, $chan="")
	If $irc = -1 Then Return 0

	If $chan = "" Then
		TCPSend($irc, $msg & @CRLF)

		If @error Then
			MsgBox(1, "IRC.au3", "Server has disconnected.")
			Return -1
		EndIf

		Return 1
	EndIf

	TCPSend($irc, "PRIVMSG " & $chan & " :" & $msg & @CRLF)
		If @error Then
			MsgBox(1, "IRC.au3", "Server has disconnected.")

		Return -1
	EndIf

	Return 1
EndFunc

;===============================================================================
; Description:      Changes a MODE on IRC
; Parameter(s):     $irc - Socket returned from _IRCConnect ()
;					$mode - Mode you wish to change
;                   $chan - Channel recipient
; Requirement(s):   _IRCConnect () called beforehand
; Return Value(s):  On Success: 1
;                   On Failure: -1 (Server disconnected)
; Author(s):        Hersche
; Note(s):          Reserved
;===============================================================================
Func _IRCChangeMode ($irc, $mode, $chan="")
	If $irc = -1 Then Return 0

	If $chan = "" Then
		TCPSend($irc, "MODE " & $mode & @CRLF)
		If @error Then
			MsgBox(1, "IRC.au3", "Server has disconnected.")
			Return -1

		EndIf
	EndIf

	Return 1
EndFunc

;===============================================================================
; Description:      Returns a PING to Server
; Parameter(s):     $irc - Socket returned from _IRCConnect ()
;					$ret - The end of the PING to return
; Requirement(s):   _IRCConnect () called beforehand
; Return Value(s):  On Success: 1
;                   On Failure: -1 = Server disconnected.
; Author(s):        Hersche
; Note(s):          Reserved
;===============================================================================
Func _IRCPing($ret)
	If $ret = "" Then Return -1

	TCPSend($irc, "PONG " & $ret & @CRLF)
		If @error Then
			MsgBox(1, "IRC.au3", "Server has disconnected.")
		Return -1
	EndIf

	Return 1
EndFunc
