; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; General Asm Template by Lahar 
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл

.686					;Use 686 instuction set to have all inel commands
.model flat, stdcall	;Use flat memory model since we are in 32bit 
option casemap: none	;Variables and others are case sensitive

include Template.inc	;Include our files containing libraries

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; Our initialised variables will go into in this .data section
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
.data
	szAppName	db	"API Address Finder",0
	szFormat	db	"%X",0

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; Our uninitialised variables will go into in this .data? section
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
.data?
	hInstance	HINSTANCE	?
	szDll			db	60 dup (?)
	szApi			db	60 dup (?)
	szAddress		db	60 dup (?)

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; Our constant values will go onto this section
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
.const
	IDD_DLGBOX	equ	1001
	IDC_GETADDR	equ	1002
	IDC_DLL		equ	1004
	IDC_API		equ	1005
	IDC_ADDRESS	equ	1006
	APP_ICON	equ	2000

; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
; This is the section to write our main code
; ллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллллл
.code

start:	
	invoke GetModuleHandle, NULL
	mov hInstance, eax
	invoke InitCommonControls
	invoke DialogBoxParam, hInstance, IDD_DLGBOX, NULL, addr DlgProc, NULL
	invoke ExitProcess, NULL

DlgProc		proc	hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	.if uMsg == WM_INITDIALOG
		invoke SetWindowText, hWnd, addr szAppName
		invoke LoadIcon, hInstance, APP_ICON
		invoke SendMessage, hWnd, WM_SETICON, 1, eax
	.elseif uMsg == WM_COMMAND
		mov eax, wParam
		.if eax == IDC_GETADDR
			invoke RtlZeroMemory, addr szDll,60
			invoke RtlZeroMemory, addr szApi,60
			invoke RtlZeroMemory, addr szAddress,60
			invoke GetDlgItemText, hWnd, IDC_DLL, addr szDll, 60
			.if eax
				invoke LoadLibrary, addr szDll
				push eax
				push eax
				invoke GetDlgItemText, hWnd, IDC_API, addr szApi, 60
				.if eax
					pop eax
					invoke GetProcAddress, eax , addr szApi
					invoke wsprintf, addr szAddress, addr szFormat, eax
					invoke SetDlgItemText, hWnd, IDC_ADDRESS, addr szAddress
					pop eax
					invoke FreeLibrary, eax
				.else
					ret
				.endif
			.else
				ret
			.endif				 
		.endif
	.elseif uMsg == WM_CLOSE
		invoke EndDialog, hWnd, NULL
	.endif
	
	xor eax, eax				 
	Ret
DlgProc EndP

end start	
	 