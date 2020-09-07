program MiniProjet;

uses
  Vcl.Forms,
  uMiniProjet in 'uMiniProjet.pas' {fMiniProjet};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TfMiniProjet, fMiniProjet);
  Application.Run;
end.
