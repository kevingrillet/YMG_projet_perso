# Guide

## Exemple de fichier ProjetPersoConf.ini

```dosini
[CONF]
Url=http://192.168.0.200/
[AUTO]
Session=1
Teams=0
```

## Sources

### Icones

<https://www.fatcow.com/free-icons>

Les icones viennent de la librairie FatCow, celle-ci contient tout ce qui peut être utile lors de la réalisation d'un logiciel.

### Communiquer avec le module

<https://blog.dummzeuch.de/2016/09/25/first-steps-rest-json/>

En récupérant directement la réponse au lieu de la traiter comme du JSON.

```delphi
procedure Tf_DelphiDabblerSwag.doRequest(const _Command: string; out _Response: TJSONObject);
var
  HTTP: TIdHTTP;
  JSON: string;
begin
  HTTP := TIdHTTP.Create(nil);
  try
    JSON := HTTP.Get('http://swag.delphidabbler.com/api/v1/' + _Command);
//    m_Result.Lines.text := JSON;
  finally
    FreeAndNil(HTTP);
  end;
  _Response := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
end;
```

Il est possible d'ajouter un ```timeout``` si jamais le module ne répond pas, par contre il ne faut pas oublier d'attraper l'erreur.

```delphi
HTTP.ConnectTimeout := 1000; // 1s
```

### Détecter quand un utilisateur vérouille/déverouille sa session

<https://stackoverflow.com/questions/45988192/detect-when-user-locks-unlocks-screen-in-windows-7-with-delphi>

```delphi
interface

uses
  ...;

type
  TfrmAlisson = class(TForm)
    lbl2: TLabel;
  protected
    procedure CreateWnd; override;
    procedure DestroyWindowHandle; override;
    procedure WndProc(var Message: TMessage); override;
  public
    LockedCount: Integer;
  end;

implementation

const
  NOTIFY_FOR_THIS_SESSION = $0;
  NOTIFY_FOR_ALL_SESSIONS = $1;

function WTSRegisterSessionNotification(hWnd: HWND; dwFlags: DWORD): Boolean; stdcall; external 'wtsapi32.dll' name 'WTSRegisterSessionNotification';
function WTSUnRegisterSessionNotification(hWnd: HWND): Boolean; stdcall; external 'wtsapi32.dll' name 'WTSUnRegisterSessionNotification';

procedure TfrmAlisson.CreateWnd;
begin
  inherited;
  if not WTSRegisterSessionNotification(Handle, NOTIFY_FOR_THIS_SESSION) then
    RaiseLastOSError;
end;

procedure TfrmAlisson.DestroyWindowHandle;
begin
  WTSUnRegisterSessionNotification(Handle);
  inherited;
end;

procedure TfrmAlisson.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_WTSSESSION_CHANGE then
  begin
    case Message.wParam of
      WTS_SESSION_LOCK: begin
        Inc(LockedCount);
      end;
      WTS_SESSION_UNLOCK: begin
        lbl2.Caption := Format('Session was locked %d times.', [LockedCount]);
      end;
    end;
  end;
  inherited;
end;

end.
```

### Évolution possible pour ajouter un fonctionnement avec Teams.

Pour Teams ce n'est actuellement pas possible, nous avons un problème avec l'inscription de notre application sur la Plateforme d’identités Microsoft. La page ne fonctionne pas au moment ou nous développons.

<https://portal.azure.com/#blade/Microsoft_AAD_IAM/ActiveDirectoryMenuBlade/RegisteredApps>

Le principe serait le suivant :

- Authentification:
	- <https://docs.microsoft.com/fr-fr/graph/auth-register-app-v2?context=graph%2Fapi%2Fbeta&view=graph-rest-beta>
	- <https://www.example-code.com/delphidll/microsoft_graph_oauth2_access_token.asp>
- Présence:
	- <https://docs.microsoft.com/fr-fr/graph/api/presence-get?view=graph-rest-beta&tabs=http> 