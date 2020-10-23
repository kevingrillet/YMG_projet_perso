unit ProjetPerso.TrayIcon;

interface

uses
   System.SysUtils, System.Classes, Vcl.Menus, Vcl.ExtCtrls,
   ProjetPerso.Images;

const
   // Les hint suivant l'état de la LED
   CST_HINT_OFF = 'Projet perso - Invisible';
   CST_HINT_GREEN = 'Projet perso - Disponible';
   CST_HINT_RED = 'Projet perso - Absent';
   CST_HINT_YELLOW = 'Projet perso - Occupé';
   CST_HINT_WARN = 'Projet perso - Problème de connexion';

type
   TCallBack = procedure(Sender: TObject) of object;

   TdmTrayIcon = class(TDataModule)
      myTrayIcon: TTrayIcon;
      popupMenuTrayIcon: TPopupMenu;
      miGreen: TMenuItem;
      miYellow: TMenuItem;
      miRed: TMenuItem;
      miOff: TMenuItem;
      N1: TMenuItem;
      miParam: TMenuItem;
      miRefresh: TMenuItem;
      miClose: TMenuItem;
   private
      { Déclarations privées }
   public
      procedure EnableButtons(bState: boolean);
      procedure SetAction(ACallBack: TCallBack = nil);
      procedure SetClose(ACallBack: TCallBack = nil);
      procedure SetParam(ACallBack: TCallBack = nil);
      procedure SetRefresh(ACallBack: TCallBack = nil);
      { Déclarations publiques }
   end;

var
   dmTrayIcon: TdmTrayIcon;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}
{ TdmProjetPersoTrayIcon }

procedure TdmTrayIcon.EnableButtons(bState: boolean);
begin
   miOff.Enabled := bState;
   miGreen.Enabled := bState;
   miYellow.Enabled := bState;
   miRed.Enabled := bState;
   miRefresh.Enabled := bState;
end;

procedure TdmTrayIcon.SetAction(ACallBack: TCallBack);
begin
   miOff.OnClick := ACallBack;
   miGreen.OnClick := ACallBack;
   miYellow.OnClick := ACallBack;
   miRed.OnClick := ACallBack;
end;

procedure TdmTrayIcon.SetClose(ACallBack: TCallBack);
begin
   miClose.OnClick := ACallBack;
end;

procedure TdmTrayIcon.SetParam(ACallBack: TCallBack);
begin
   miParam.OnClick := ACallBack;
   myTrayIcon.OnDblClick := ACallBack;
end;

procedure TdmTrayIcon.SetRefresh(ACallBack: TCallBack);
begin
   miRefresh.OnClick := ACallBack;
end;

end.
