unit ProjetPerso.Windows;

interface

uses
   Winapi.Windows;

implementation

// Fonctions permettant de s'abonner au verrouillage / déverrouillage de la session Windows
function WTSRegisterSessionNotification(hWnd: hWnd; dwFlags: DWORD): Boolean;
  stdcall; external 'wtsapi32.dll' name 'WTSRegisterSessionNotification';
function WTSUnRegisterSessionNotification(hWnd: hWnd): Boolean; stdcall;
  external 'wtsapi32.dll' name 'WTSUnRegisterSessionNotification';

end.
