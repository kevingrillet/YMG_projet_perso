unit uProjetPerso;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Menus, System.ImageList,
   Vcl.ImgList;

type
   TfProjetPerso = class(TForm)
      myTrayIcon: TTrayIcon;
      bGreen: TBitBtn;
      bRed: TBitBtn;
      bYellow: TBitBtn;
      bOff: TBitBtn;
      pParam: TPanel;
      eUrl: TEdit;
      bValider: TBitBtn;
      lParam: TLabel;
      pActions: TPanel;
      popupMenuTrayIcon: TPopupMenu;
      miParam: TMenuItem;
      miGreen: TMenuItem;
      miRed: TMenuItem;
      miYellow: TMenuItem;
      miOff: TMenuItem;
      N1: TMenuItem;
      miClose: TMenuItem;
      imageList32: TImageList;
      lActions: TLabel;
      imageList16: TImageList;
      miRefresh: TMenuItem;
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
      procedure bValiderClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure bBtnClick(Sender: TObject);
      procedure myTrayIconDblClick(Sender: TObject);
      procedure miCloseClick(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure miRefreshClick(Sender: TObject);
      procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
      procedure llSourcesClick(Sender: TObject);

   const
      // Adresse du fichier de configuration
      CST_CONF_FILE = 'ProjetPersoConf.ini';

      // Gestion des erreurs
      CST_ERROR = 'ERROR';
      CST_ERROR_VALIDATION = 'Problème lors de la communication avec le module';

      // Les différents GPIO pour modifier l'état d'une LED
      CST_GPIO_OFF = '0';
      CST_GPIO_GREEN = '5';
      CST_GPIO_YELLOW = '14';
      CST_GPIO_RED = '4';

      // Les hint suivant l'état de la LED
      CST_HINT_OFF = 'Projet perso - Invisible';
      CST_HINT_GREEN = 'Projet perso - Disponible';
      CST_HINT_RED = 'Projet perso - Absent';
      CST_HINT_YELLOW = 'Projet perso - Occupé';
      CST_HINT_WARN = 'Projet perso - Problème de connexion';

      // Les images suivant l'état de la LED
      CST_IMG_OFF = 0;
      CST_IMG_GREEN = 1;
      CST_IMG_YELLOW = 2;
      CST_IMG_RED = 3;
      CST_IMG_WARN = 5;

      // Le résultat de l'état de la LED
      CST_RESULT_OFF = 'OFF';
      CST_RESULT_GREEN = 'GREEN';
      CST_RESULT_YELLOW = 'YELLOW';
      CST_RESULT_RED = 'RED';

      // Les différentes adresses à contacter sur le module
      CST_URL_READ_REVICE = 'readDeviceName';
      CST_URL_READ_LED = 'readLED';
      CST_URL_SET_GPIO = 'setGPIO?gpio=';

      { const }

   strict private
      FbCanClose: Boolean;

      /// <summary>
      /// Gère l'état des différents boutons d'actions
      /// </summary>
      /// <param name="bState">
      /// Etat à affecter
      /// </param>
      procedure EnableButtons(bState: Boolean);

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
   fProjetPerso: TfProjetPerso;

implementation

{$R *.dfm}

uses IniFiles, IdHTTP, ShellAPI;

// Fonctions permettant de s'abonner au verrouillage / déverrouillage de la session Windows
function WTSRegisterSessionNotification(hWnd: hWnd; dwFlags: DWORD): Boolean;
  stdcall; external 'wtsapi32.dll' name 'WTSRegisterSessionNotification';
function WTSUnRegisterSessionNotification(hWnd: hWnd): Boolean; stdcall;
  external 'wtsapi32.dll' name 'WTSUnRegisterSessionNotification';

procedure TfProjetPerso.bBtnClick(Sender: TObject);
var
   sGPIO: string;
begin
   if (Sender = bOff) or (Sender = miOff) then
      sGPIO := CST_GPIO_OFF
   else if (Sender = bGreen) or (Sender = miGreen) then
      sGPIO := CST_GPIO_GREEN
   else if (Sender = bYellow) or (Sender = miYellow) then
      sGPIO := CST_GPIO_YELLOW
   else if (Sender = bRed) or (Sender = miRed) then
      sGPIO := CST_GPIO_RED;

   UpdateTrayIcon(HttpGet(eUrl.Text + CST_URL_SET_GPIO + sGPIO));
end;

function TfProjetPerso.HttpGet(sUrl: string): string;
var
   HTTP: TidHTTP;
begin
   Result := CST_ERROR;
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

procedure TfProjetPerso.llSourcesClick(Sender: TObject);
begin
   ShellOpen(llSources.Hint);
end;

procedure TfProjetPerso.myTrayIconDblClick(Sender: TObject);
begin
   fProjetPerso.Visible := not fProjetPerso.Visible;
end;

procedure TfProjetPerso.ShellOpen(const FileName, Parameters: string);
begin
   ShellAPI.ShellExecute(0, 'Open', PChar(FileName), PChar(Parameters), nil,
     SW_SHOWNORMAL);
end;

procedure TfProjetPerso.bValiderClick(Sender: TObject);
var
   ifIniFile: TIniFile;
begin
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
   end;

   UpdateTrayIcon;
end;

procedure TfProjetPerso.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   CanClose := FbCanClose;
   if not CanClose then
      fProjetPerso.Visible := False;
end;

procedure TfProjetPerso.FormCreate(Sender: TObject);
var
   ifIniFile: TIniFile;
begin
   FbCanClose := False;

   iHelp.Stretch := True; // to make it as large as Image1
   iHelp.Proportional := True; // to keep width/height ratio
   iHelp.Picture.Bitmap := nil; // clear previous image
   imageList32.GetBitmap(6, iHelp.Picture.Bitmap);

   ifIniFile := TIniFile.Create((ExtractFileDir(ParamStr(0))) + '\' +
     CST_CONF_FILE);
   try
      eUrl.Text := ifIniFile.ReadString('CONF', 'Url', '');
      if ifIniFile.ReadBool('AUTO', 'Session', True) then
         cbWindows.State := cbChecked
      else
         cbWindows.State := cbUnChecked;
      // if ifIniFile.ReadBool('AUTO', 'Teams', True) then
      // cbTeams.State := cbChecked
      // else
      // cbTeams.State := cbUnChecked;
   finally
      ifIniFile.Free;
   end;

   if eUrl.Text <> '' then
      UpdateTrayIcon(HttpGet(eUrl.Text + CST_URL_SET_GPIO + CST_GPIO_GREEN));

   EnableButtons(eUrl.Text <> '');

   // Traiter le masquage de la fiche si tout est ok
   fProjetPerso.Visible := (eUrl.Text = '') and
     (myTrayIcon.IconIndex <> CST_IMG_WARN);
end;

procedure TfProjetPerso.FormDestroy(Sender: TObject);
var
   ifIniFile: TIniFile;
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

procedure TfProjetPerso.miCloseClick(Sender: TObject);
begin
   FbCanClose := True;
   Close;
end;

procedure TfProjetPerso.miRefreshClick(Sender: TObject);
begin
   UpdateTrayIcon;
end;

procedure TfProjetPerso.UpdateTrayIcon(sResult: string = '');
begin
   if sResult = '' then
      sResult := HttpGet(eUrl.Text + CST_URL_READ_LED);

   if sResult = CST_RESULT_OFF then
   begin
      myTrayIcon.IconIndex := CST_IMG_OFF;
      myTrayIcon.Hint := CST_HINT_OFF;
   end
   else if sResult = CST_RESULT_GREEN then
   begin
      myTrayIcon.IconIndex := CST_IMG_GREEN;
      myTrayIcon.Hint := CST_HINT_GREEN;
   end
   else if sResult = CST_RESULT_YELLOW then
   begin
      myTrayIcon.IconIndex := CST_IMG_YELLOW;
      myTrayIcon.Hint := CST_HINT_YELLOW;
   end
   else if sResult = CST_RESULT_RED then
   begin
      myTrayIcon.IconIndex := CST_IMG_RED;
      myTrayIcon.Hint := CST_HINT_RED;
   end
   else
   begin
      myTrayIcon.IconIndex := CST_IMG_WARN;
      myTrayIcon.Hint := CST_HINT_WARN;
   end;
end;

procedure TfProjetPerso.CreateWnd;
begin
   inherited;
   if not WTSRegisterSessionNotification(Handle, NOTIFY_FOR_THIS_SESSION) then
      RaiseLastOSError;
end;

procedure TfProjetPerso.DestroyWindowHandle;
begin
   WTSUnRegisterSessionNotification(Handle);
   inherited;
end;

procedure TfProjetPerso.EnableButtons(bState: Boolean);
begin
   bOff.Enabled := bState;
   bGreen.Enabled := bState;
   bYellow.Enabled := bState;
   bRed.Enabled := bState;

   miOff.Enabled := bState;
   miGreen.Enabled := bState;
   miYellow.Enabled := bState;
   miRed.Enabled := bState;
   miRefresh.Enabled := bState;
end;

procedure TfProjetPerso.WndProc(var Message: TMessage);
begin
   inherited;
   if not(Assigned(cbWindows) and (cbWindows.State = cbUnChecked)) then
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

end.
