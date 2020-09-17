unit uProjetPerso;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics,
   Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons,
   Vcl.ExtCtrls,
   Vcl.Menus, System.ImageList, Vcl.ImgList;

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
      pInfos: TPanel;
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
      Label1: TLabel;
      procedure bValiderClick(Sender: TObject);
      procedure FormCreate(Sender: TObject);
      procedure bBtnClick(Sender: TObject);
      procedure myTrayIconDblClick(Sender: TObject);
      procedure miCloseClick(Sender: TObject);
      procedure FormDestroy(Sender: TObject);
      procedure miRefreshClick(Sender: TObject);

   private
      procedure EnableButtons(bState: boolean);

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
      /// Permet de mettre à jour l'image du TrayIcon en fonction de la LED allumée.
      /// </summary>
      /// <param name="sResult">
      /// Etat de la LED que l'on souhaite afficher : [OFF, GREEN, RED, YELLOW]
      /// </param>
      /// <remarks>
      /// Si sResultat est vide, on va récupérer la valeur de la LED actuellement active sur le module.
      /// Si sResultat est non conforme, on affiche un icone Warning
      /// </remarks>
      procedure UpdateTrayIcon(sResult: string = '');

      { Déclarations privées }

   protected
      procedure CreateWnd; override;
      procedure DestroyWindowHandle; override;
      procedure WndProc(var Message: TMessage); override;

   Const
      CST_IMG_OFF = 0;
      CST_IMG_GREEN = 1;
      CST_IMG_YELLOW = 2;
      CST_IMG_RED = 3;
      CST_IMG_WARN = 5;
      CST_IMG_ICON = 7;

      CST_GPIO_OFF = '0';
      CST_GPIO_GREEN = '5';
      CST_GPIO_YELLOW = '14';
      CST_GPIO_RED = '4';

      CST_RESULT_OFF = 'OFF';
      CST_RESULT_GREEN = 'GREEN';
      CST_RESULT_YELLOW = 'YELLOW';
      CST_RESULT_RED = 'RED';

      CST_URL_READ_REVICE = 'readDeviceName';
      CST_URL_READ_LED = 'readLED';
      CST_URL_SET_GPIO = 'setGPIO?gpio=';

      CST_CONF_FILE = 'ProjetPersoConf.ini';
   public
      { Déclarations publiques }

   end;

var
   fProjetPerso: TfProjetPerso;

implementation

{$R *.dfm}

uses IniFiles, IdHTTP;

// Fonctions permettant de s'abonner au verrouillage / déverrouillage de la session Windows
function WTSRegisterSessionNotification(hWnd: hWnd; dwFlags: DWORD): boolean;
  stdcall; external 'wtsapi32.dll' name 'WTSRegisterSessionNotification';
function WTSUnRegisterSessionNotification(hWnd: hWnd): boolean; stdcall;
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
   Result := 'ERROR';
   HTTP := TidHTTP.Create(nil);
   try
      HTTP.ConnectTimeout := 1000;
      try
         Result := HTTP.Get(sUrl);
      except
      end;
   finally
      FreeAndNil(HTTP);
   end;
end;

procedure TfProjetPerso.myTrayIconDblClick(Sender: TObject);
begin
   fProjetPerso.Visible := not fProjetPerso.Visible;
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
         FileSetAttr(ifIniFile.FileName, faHidden);
      finally
         ifIniFile.Free;
      end;

      EnableButtons(True);
   end
   else
   begin
      EnableButtons(False);
      showmessage('Problème lors de la communication avec le module');
   end;

   UpdateTrayIcon;
end;

procedure TfProjetPerso.FormCreate(Sender: TObject);
var
   myIcon: TIcon;
   ifIniFile: TIniFile;
begin
   imageList32.GetIcon(7, myIcon); 
   fProjetPerso.Icon := myIcon; 
   myIcon.Free;
   

   ifIniFile := TIniFile.Create((ExtractFileDir(ParamStr(0))) + '\' +
     CST_CONF_FILE);
   try
      eUrl.Text := ifIniFile.ReadString('CONF', 'Url', '');
      if ifIniFile.ReadBool('AUTO', 'Session', True) then
         cbWindows.State := cbChecked
      else
         cbWindows.State := cbUnChecked;
//      if ifIniFile.ReadBool('AUTO', 'Teams', True) then
//         cbTeams.State := cbChecked
//      else
//         cbTeams.State := cbUnChecked;
   finally
      ifIniFile.Free;
   end;

   if eUrl.Text <> '' then
      UpdateTrayIcon(HttpGet(eUrl.Text + CST_URL_SET_GPIO + CST_GPIO_GREEN));

   EnableButtons(eUrl.Text <> '');

   // Traiter le masquage de la fiche si tt ok
   fProjetPerso.Visible := eUrl.Text = '';
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
      myTrayIcon.Hint := 'Projet perso - Invisible';
   end
   else if sResult = CST_RESULT_GREEN then
   begin
      myTrayIcon.IconIndex := CST_IMG_GREEN;
      myTrayIcon.Hint := 'Projet perso - Disponible';
   end
   else if sResult = CST_RESULT_YELLOW then
   begin
      myTrayIcon.IconIndex := CST_IMG_YELLOW;
      myTrayIcon.Hint := 'Projet perso - Absent';
   end
   else if sResult = CST_RESULT_RED then
   begin
      myTrayIcon.IconIndex := CST_IMG_RED;
      myTrayIcon.Hint := 'Projet perso - Occupé';
   end
   else
   begin
      myTrayIcon.IconIndex := CST_IMG_WARN;
      myTrayIcon.Hint := 'Projet perso - Problème de connexion';
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

procedure TfProjetPerso.EnableButtons(bState: boolean);
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
