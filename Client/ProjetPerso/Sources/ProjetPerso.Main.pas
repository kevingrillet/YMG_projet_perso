unit ProjetPerso.Main;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Menus, System.ImageList,
   Vcl.ImgList, Vcl.ComCtrls,
   ProjetPerso.AzureOauth2.Model;

type
   TfProjetPersoMain = class(TForm)
      bGreen: TButton;
      bRed: TButton;
      bYellow: TButton;
      bOff: TButton;
      pAdresse: TPanel;
      eUrl: TEdit;
      bValider: TButton;
      lAdresse: TLabel;
      pActions: TPanel;
      lActions: TLabel;
      pAuto: TPanel;
      cbWindows: TCheckBox;
      cbTeams: TCheckBox;
      lAuto: TLabel;
      pFooter: TPanel;
      llSources: TLinkLabel;
      lSources: TLabel;
      iHelp: TImage;
      fpAuto: TFlowPanel;
      fpActions: TFlowPanel;
      pLog: TPanel;
      pParam: TPanel;
      cbLog: TCheckBox;
      lParam: TLabel;
      llLog: TLinkLabel;
      reLog: TRichEdit;
      pLogParam: TPanel;
      lLog: TLabel;
      pTeams: TPanel;
      lTeams: TLabel;
      bLogin: TButton;
      bGetToken: TButton;
      fbLogin: TFlowPanel;
      lLogin: TLabel;
      eToken: TEdit;
      fbToken: TFlowPanel;
      procedure bValiderClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure bBtnClick(Sender: TObject);
      procedure myTrayIconDblClick(Sender: TObject);
      procedure miCloseClick(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure miRefreshClick(Sender: TObject);
      procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
      procedure llSourcesClick(Sender: TObject);
      procedure cbTeamsClick(Sender: TObject);
      procedure bLoginClick(Sender: TObject);
      procedure bGetTokenClick(Sender: TObject);

   strict private
      FbCanClose: Boolean;
      FcCur: TCursor;

      /// <summary>
      /// Gère l'état des différents boutons d'actions
      /// </summary>
      /// <param name="bState">
      /// Etat à affecter
      /// </param>
      procedure EnableButtons(bState: Boolean);

      procedure GetToken(sString: string);

      /// <summary>
      /// Permet de dialoguer avec le module via une requète HttpGet
      /// </summary>
      /// <param name="sUrl">
      /// Adresse à interroger
      /// </param>
      /// <remarks>
      /// Si le module ne répond pas après 2 s (2000 ms), le résultat est vide
      /// </remarks>
      /// <returns>
      /// Valeur retournée par la requète : [OFF, GREEN, RED, YELLOW]
      /// https://github.com/kevingrillet/YMG_projet_perso/tree/master/ESP8266
      /// </returns>
      function HttpGet(sUrl: string): string;

      /// <summary>
      /// Permet de mettre à jour l'image du TrayIcon en fonction de la LED allumée
      /// </summary>
      /// <param name="sResult">
      /// Etat de la LED que l'on souhaite afficher : [OFF, GREEN, RED, YELLOW]
      /// </param>
      /// <remarks>
      /// Si sResult est vide, on va récupérer la valeur de la LED actuellement active sur le module.
      /// Si sResult est non conforme, on affiche un icone Warning
      /// </remarks>
      procedure UpdateTrayIcon(sResult: string = '');

      /// <summary>
      /// Permet de faire un ShellAPI.ShellExecute plus simplement
      /// </summary>
      /// <param name="FileName">
      /// Correspond à FileName de ShellAPI.ShellExecute
      /// </param>
      /// <param name="Parameters">
      /// Correspond à Parameters de ShellAPI.ShellExecute
      /// </param>
      procedure ShellOpen(const FileName: string;
        const Parameters: string = '');

      { strict private }

   protected
      procedure CreateWnd; override;
      procedure DestroyWindowHandle; override;
      procedure WndProc(var Message: TMessage); override;

      { protected }

   end;

var
   fProjetPersoMain: TfProjetPersoMain;

implementation

{$R *.dfm}

uses IniFiles, IdHTTP, ShellAPI,
   ProjetPerso.Constantes, ProjetPerso.Images, ProjetPerso.TrayIcon,
   ProjetPerso.AzureOauth2.Authorize, ProjetPerso.AzureOauth2.Rest;

// Fonctions permettant de s'abonner au verrouillage / déverrouillage de la session Windows
function WTSRegisterSessionNotification(hWnd: hWnd; dwFlags: DWORD): Boolean;
  stdcall; external 'wtsapi32.dll' name 'WTSRegisterSessionNotification';
function WTSUnRegisterSessionNotification(hWnd: hWnd): Boolean; stdcall;
  external 'wtsapi32.dll' name 'WTSUnRegisterSessionNotification';

procedure TfProjetPersoMain.bBtnClick(Sender: TObject);
var
   sGPIO: string;
begin
   if (Sender = bOff) or (Sender = dmTrayIcon.miOff) then
      sGPIO := CST_GPIO_OFF
   else if (Sender = bGreen) or (Sender = dmTrayIcon.miGreen) then
      sGPIO := CST_GPIO_GREEN
   else if (Sender = bYellow) or (Sender = dmTrayIcon.miYellow) then
      sGPIO := CST_GPIO_YELLOW
   else if (Sender = bRed) or (Sender = dmTrayIcon.miRed) then
      sGPIO := CST_GPIO_RED;

   UpdateTrayIcon(HttpGet(eUrl.Text + CST_URL_SET_GPIO + sGPIO));
end;

function TfProjetPersoMain.HttpGet(sUrl: string): string;
var
   HTTP: TidHTTP;
begin
   Result := CST_ERROR;
   if (eUrl.Text = '') then
      exit;

   HTTP := TidHTTP.Create(nil);
   try
      HTTP.ConnectTimeout := 1000; // 1s
      try
         Result := HTTP.Get(sUrl);
      except
      end;
   finally
      FreeAndNil(HTTP);
   end;
end;

procedure TfProjetPersoMain.llSourcesClick(Sender: TObject);
begin
   ShellOpen(llSources.Hint);
end;

procedure TfProjetPersoMain.myTrayIconDblClick(Sender: TObject);
begin
   fProjetPersoMain.Visible := not fProjetPersoMain.Visible;
end;

procedure TfProjetPersoMain.ShellOpen(const FileName, Parameters: string);
begin
   ShellAPI.ShellExecute(0, 'Open', PChar(FileName), PChar(Parameters), nil,
     SW_SHOWNORMAL);
end;

procedure TfProjetPersoMain.bGetTokenClick(Sender: TObject);
begin
   FcCur := Screen.Cursor;
   Screen.Cursor := crHourGlass;
   dmAzureOauth2Rest.GetToken;
end;

procedure TfProjetPersoMain.bLoginClick(Sender: TObject);
var
   sTemp: string;
begin
   Visible := False;
   sTemp := dmAzureOauth2Rest.login;
   Visible := True;

   if sTemp <> 'ERROR' then
   begin
      reLog.Lines.Add('Authentication Code: ' + sTemp.Substring(0, 8) + '...');
      bGetToken.Enabled := True;
   end;
end;

procedure TfProjetPersoMain.bValiderClick(Sender: TObject);
var
   ifIniFile: TIniFile;
begin
   FcCur := Screen.Cursor;
   Screen.Cursor := crHourGlass;
   if HttpGet(eUrl.Text + CST_URL_READ_REVICE) <> '' then
   begin
      ifIniFile := TIniFile.Create((ExtractFileDir(ParamStr(0))) + '\' +
        CST_CONF_FILE);
      try
         ifIniFile.WriteString('CONF', 'Url', eUrl.Text);
{$WARN SYMBOL_PLATFORM OFF}
         FileSetAttr(ifIniFile.FileName, faHidden);
{$WARN SYMBOL_PLATFORM ON}
      finally
         ifIniFile.Free;
      end;

      EnableButtons(True);
   end
   else
   begin
      EnableButtons(False);
      showmessage(CST_ERROR_VALIDATION);
      eUrl.Text := '';
   end;

   UpdateTrayIcon;
   Screen.Cursor := FcCur;
end;

procedure TfProjetPersoMain.cbTeamsClick(Sender: TObject);
begin
   bLogin.Enabled := cbTeams.State = cbChecked;
end;

procedure TfProjetPersoMain.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
   CanClose := FbCanClose;
   if not CanClose then
      fProjetPersoMain.Visible := False;
end;

procedure TfProjetPersoMain.FormCreate(Sender: TObject);
var
   ifIniFile: TIniFile;
begin
   FbCanClose := False;

   iHelp.Stretch := True;
   iHelp.Proportional := True;
   iHelp.Picture.Bitmap := nil;
   dmImages.imageList32.GetBitmap(6, iHelp.Picture.Bitmap);

   // On init ProjetPerso.TrayIcon
   dmTrayIcon.SetAction(bBtnClick);
   dmTrayIcon.SetParam(myTrayIconDblClick);
   dmTrayIcon.SetRefresh(miRefreshClick);
   dmTrayIcon.SetClose(miCloseClick);

   // On init ProjetPerso.AzureOauth2.Rest
   dmAzureOauth2Rest.Init(GetToken);

   ifIniFile := TIniFile.Create((ExtractFileDir(ParamStr(0))) + '\' +
     CST_CONF_FILE);
   try
      eUrl.Text := ifIniFile.ReadString('CONF', 'Url', '');
      if ifIniFile.ReadBool('AUTO', 'Session', False) then
         cbWindows.State := cbChecked
      else
         cbWindows.State := cbUnChecked;
      if ifIniFile.ReadBool('AUTO', 'Teams', False) then
         cbTeams.State := cbChecked
      else
         cbTeams.State := cbUnChecked;
   finally
      ifIniFile.Free;
   end;

   if eUrl.Text <> '' then
      UpdateTrayIcon(HttpGet(eUrl.Text + CST_URL_SET_GPIO + CST_GPIO_GREEN));

   EnableButtons(eUrl.Text <> '');

   // Traiter le masquage de la fiche si tout est ok
   fProjetPersoMain.Visible := (eUrl.Text = '') and
     (dmTrayIcon.myTrayIcon.IconIndex <> CST_IMG_WARN);
end;

procedure TfProjetPersoMain.FormDestroy(Sender: TObject);
var
   ifIniFile: TIniFile;
begin
   if eUrl.Text <> '' then
   begin
      ifIniFile := TIniFile.Create((ExtractFileDir(ParamStr(0))) + '\' +
        CST_CONF_FILE);
      try
         ifIniFile.WriteBool('AUTO', 'Session', cbWindows.State = cbChecked);
         ifIniFile.WriteBool('AUTO', 'Teams', cbTeams.State = cbChecked);
      finally
         ifIniFile.Free;
      end;
      HttpGet(eUrl.Text + CST_URL_SET_GPIO + CST_GPIO_OFF);
   end;
end;

procedure TfProjetPersoMain.GetToken(sString: string);
var
   ifIniFile: TIniFile;
begin
   if sString <> 'ERROR' then
   begin
      reLog.Lines.Add('Access Token: ' + sString);
      eToken.Text := sString;

      ifIniFile := TIniFile.Create((ExtractFileDir(ParamStr(0))) + '\' +
        CST_CONF_FILE);
      try
         ifIniFile.WriteString('Teams', 'AccessToken', sString);
      finally
         ifIniFile.Free;
      end;
   end;
   Screen.Cursor := FcCur;
end;

procedure TfProjetPersoMain.miCloseClick(Sender: TObject);
begin
   FbCanClose := True;
   Close;
end;

procedure TfProjetPersoMain.miRefreshClick(Sender: TObject);
begin
   UpdateTrayIcon;
end;

procedure TfProjetPersoMain.UpdateTrayIcon(sResult: string = '');
begin
   if (sResult = '') then
      sResult := HttpGet(eUrl.Text + CST_URL_READ_LED);

   if sResult = CST_RESULT_OFF then
   begin
      dmTrayIcon.myTrayIcon.IconIndex := CST_IMG_OFF;
      dmTrayIcon.myTrayIcon.Hint := CST_HINT_OFF;
   end
   else if sResult = CST_RESULT_GREEN then
   begin
      dmTrayIcon.myTrayIcon.IconIndex := CST_IMG_GREEN;
      dmTrayIcon.myTrayIcon.Hint := CST_HINT_GREEN;
   end
   else if sResult = CST_RESULT_YELLOW then
   begin
      dmTrayIcon.myTrayIcon.IconIndex := CST_IMG_YELLOW;
      dmTrayIcon.myTrayIcon.Hint := CST_HINT_YELLOW;
   end
   else if sResult = CST_RESULT_RED then
   begin
      dmTrayIcon.myTrayIcon.IconIndex := CST_IMG_RED;
      dmTrayIcon.myTrayIcon.Hint := CST_HINT_RED;
   end
   else
   begin
      dmTrayIcon.myTrayIcon.IconIndex := CST_IMG_WARN;
      dmTrayIcon.myTrayIcon.Hint := CST_HINT_WARN;
   end;
end;

procedure TfProjetPersoMain.CreateWnd;
begin
   inherited;
   if not WTSRegisterSessionNotification(Handle, NOTIFY_FOR_THIS_SESSION) then
      RaiseLastOSError;
end;

procedure TfProjetPersoMain.DestroyWindowHandle;
begin
   WTSUnRegisterSessionNotification(Handle);
   inherited;
end;

procedure TfProjetPersoMain.EnableButtons(bState: Boolean);
begin
   bOff.Enabled := bState;
   bGreen.Enabled := bState;
   bYellow.Enabled := bState;
   bRed.Enabled := bState;

   cbWindows.Enabled := bState;
   if not cbWindows.Enabled then
      cbWindows.State := cbUnChecked;
   cbTeams.Enabled := bState;
   if not cbTeams.Enabled then
      cbTeams.State := cbUnChecked;

   dmTrayIcon.EnableButtons(bState);
end;

procedure TfProjetPersoMain.WndProc(var Message: TMessage);
begin
   inherited;
   if not(Assigned(cbWindows) and (cbWindows.State = cbUnChecked)) then
   begin
      if Message.Msg = WM_WTSSESSION_CHANGE then
      begin
         case Message.wParam of
            WTS_SESSION_LOCK:
               UpdateTrayIcon(HttpGet(eUrl.Text + CST_URL_SET_GPIO +
                 CST_GPIO_YELLOW));
            WTS_SESSION_UNLOCK:
               UpdateTrayIcon(HttpGet(eUrl.Text + CST_URL_SET_GPIO +
                 CST_GPIO_GREEN));
         end;
      end;
   end;
end;

end.
