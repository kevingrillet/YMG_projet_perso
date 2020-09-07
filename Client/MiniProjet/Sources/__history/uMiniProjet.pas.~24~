unit uMiniProjet;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Menus, System.ImageList, Vcl.ImgList;

type
  TfMiniProjet = class(TForm)
    TrayIcon1: TTrayIcon;
    bGreen: TBitBtn;
    bRed: TBitBtn;
    bYellow: TBitBtn;
    bOff: TBitBtn;
    pParam: TPanel;
    eUrl: TEdit;
    bValider: TBitBtn;
    lParam: TLabel;
    pInfos: TPanel;
    PopupMenu1: TPopupMenu;
    miParam: TMenuItem;
    miGreen: TMenuItem;
    miRed: TMenuItem;
    miYellow: TMenuItem;
    miOff: TMenuItem;
    N1: TMenuItem;
    miClose: TMenuItem;
    ImageList1: TImageList;
    lActions: TLabel;
    procedure bValiderClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bBtnClick(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure miCloseClick(Sender: TObject);

  private

 /// <summary>
 ///     Permet de dialoguer avec le module via une requète HttpGet
 /// </summary>
 /// <param name="sUrl">
 ///     Adresse à interroger
 /// </param>
 /// <remarks>
 ///     Si le module ne répond pas après 2 s (2000 ms), le résultat est vide
 /// </remarks>
 /// <returns>
 ///     Valeur retournée par la requète : [OFF, GREEN, RED, YELLOW]
 ///        https://github.com/kevingrillet/YMG_projet_perso/tree/master/ESP8266
 /// </returns>
    function  Requete(sUrl : string) : string;

 /// <summary>
 ///     Permet de mettre à jour l'image du TrayIcon en fonction de la LED allumée.
 /// </summary>
 /// <param name="sResultat">
 ///     Etat de la LED que l'on souhaite afficher : [OFF, GREEN, RED, YELLOW]
 /// </param>
 /// <remarks>
 ///     Si sResultat est vide, on va récupérer la valeur de la LED actuellement active sur le module.
 ///     Si sResultat est non conforme, on affiche un icone Warning
 /// </remarks>
    procedure AffichageIconeLED(sResultat : string = '');

    { Déclarations privées }

  protected
    procedure CreateWnd; override;
    procedure DestroyWindowHandle; override;
    procedure WndProc(var Message: TMessage); override;

    Const
      CST_IMG_GREEN  = 0;
      CST_IMG_RED    = 1;
      CST_IMG_OFF    = 2;
      CST_IMG_YELLOW = 3;
      CST_IMG_WARN   = 4;
  public
    { Déclarations publiques }

  end;

var
  fMiniProjet: TfMiniProjet;

implementation

{$R *.dfm}

uses IniFiles, OleAuto;

// fonction permettant de s'abonner au verrouillage / déverrouillage de la session Windows
function WTSRegisterSessionNotification(hWnd: HWND; dwFlags: DWORD): Boolean; stdcall; external 'wtsapi32.dll' name 'WTSRegisterSessionNotification';
function WTSUnRegisterSessionNotification(hWnd: HWND): Boolean; stdcall; external 'wtsapi32.dll' name 'WTSUnRegisterSessionNotification';

procedure TfMiniProjet.bBtnClick(Sender: TObject);
var sURL : string;
begin
   if (Sender = bGreen) or (Sender = miGreen) then
      sURL := '5'
   else
   if (Sender = bRed) or (Sender = miRed) then
      sURL := '4'
   else
   if (Sender = bYellow) or (Sender = miYellow) then
      sURL := '14'
   else
   if (Sender = bOff) or (Sender = miOff) then
      sURL := '0';

   AffichageIconeLED(Requete(eUrl.Text + 'setGPIO?gpio=' + sURL));
end;

function TfMiniProjet.Requete(sUrl : string) : string;
var
    Request: OleVariant;
begin
   Result := '';
   try
      // create the WinHttpRequest object instance
      Request := CreateOleObject('WinHttp.WinHttpRequest.5.1');
      Request.setTimeouts(2000, 2000, 2000, 2000);
      // open HTTP connection with GET method in synchronous mode
      Request.Open('GET', sURL, False);
      try
         // until WinHTTP completely receives the response (synchronous mode)
         Request.Send;
         // store the response into the field for synchronization
         Result := Request.ResponseText;
      except
      end;
   finally
      // release the WinHttpRequest object instance
      Request := Unassigned;
   end;
end;

procedure TfMiniProjet.TrayIcon1DblClick(Sender: TObject);
begin
   fMiniProjet.Visible := not fMiniProjet.Visible;
end;

procedure TfMiniProjet.bValiderClick(Sender: TObject);
var ifIniFile : TIniFile;
begin
   if Requete(eUrl.Text + 'readDeviceName') <> '' then
   begin
      ifIniFile := TIniFile.create(ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))) + '\ParamProjet.ini');
      try
         ifIniFile.WriteString('PARAM', 'Url', eUrl.Text);
      finally
         ifIniFile.Free;
      end;
   end
   else
      showmessage('Problème lors de la communication avec le module');

   AffichageIconeLED;
end;

procedure TfMiniProjet.FormCreate(Sender: TObject);
var ifIniFile : TIniFile;
begin
   ifIniFile := TIniFile.create(ExtractFileDir(ExtractFileDir(ExtractFileDir(ExtractFileDir(ParamStr(0))))) + '\ParamProjet.ini');
   try
      eUrl.Text := ifIniFile.ReadString('PARAM', 'Url', '');
   finally
      ifIniFile.Free;
   end;

   if eUrl.Text <> '' then
      AffichageIconeLED;

// Traiter le masquage de la fiche si tt ok
   fMiniProjet.Visible := eUrl.Text = '';
end;

procedure TfMiniProjet.miCloseClick(Sender: TObject);
begin
   Close;
end;

procedure TfMiniProjet.AffichageIconeLED(sResultat : string = '');
begin
   if sResultat = '' then
      sResultat := Requete(eUrl.Text + 'readLED');

   if sResultat = 'GREEN' then
      TrayIcon1.IconIndex := CST_IMG_GREEN
   else
   if sResultat = 'RED' then
      TrayIcon1.IconIndex := CST_IMG_RED
   else
   if sResultat = 'YELLOW' then
      TrayIcon1.IconIndex := CST_IMG_YELLOW
   else
   if sResultat = 'OFF' then
      TrayIcon1.IconIndex := CST_IMG_OFF
   else
      TrayIcon1.IconIndex := CST_IMG_WARN
end;

procedure TfMiniProjet.CreateWnd;
begin
  inherited;
  if not WTSRegisterSessionNotification(Handle, NOTIFY_FOR_THIS_SESSION) then
    RaiseLastOSError;
end;

procedure TfMiniProjet.DestroyWindowHandle;
begin
  WTSUnRegisterSessionNotification(Handle);
  inherited;
end;

procedure TfMiniProjet.WndProc(var Message: TMessage);
begin
  if Message.Msg = WM_WTSSESSION_CHANGE then
  begin
    case Message.wParam of
      WTS_SESSION_LOCK:    AffichageIconeLED(Requete(eUrl.Text + 'setGPIO?gpio=14'));
      WTS_SESSION_UNLOCK:  AffichageIconeLED(Requete(eUrl.Text + 'setGPIO?gpio=5'));
    end;
  end;
  inherited;
end;

end.
