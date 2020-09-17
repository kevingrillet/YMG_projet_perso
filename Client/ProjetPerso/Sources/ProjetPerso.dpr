program ProjetPerso;

uses
  Vcl.Forms,
  uProjetPerso in 'uProjetPerso.pas' {fProjetPerso};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TfProjetPerso, fProjetPerso);
  Application.Run;
end.
