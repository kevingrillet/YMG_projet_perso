program ProjetPerso;

uses
  Vcl.Forms,
  ProjetPerso.Main in 'ProjetPerso.Main.pas' {fProjetPersoMain},
  ProjetPerso.Images in 'ProjetPerso.Images.pas' {dmImages: TDataModule},
  ProjetPerso.TrayIcon in 'ProjetPerso.TrayIcon.pas' {dmTrayIcon: TDataModule},
  ProjetPerso.AzureOauth2.Rest in 'ProjetPerso.AzureOauth2.Rest.pas' {dmAzureOauth2Rest: TDataModule},
  ProjetPerso.AzureOauth2.Authorize in 'ProjetPerso.AzureOauth2.Authorize.pas' {fProjetPersoAzureOauth2Authorize},
  ProjetPerso.AzureOauth2.Model in 'ProjetPerso.AzureOauth2.Model.pas',
  ProjetPerso.Constantes in 'ProjetPerso.Constantes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.ShowMainForm := False;
  Application.CreateForm(TdmImages, dmImages);
  Application.CreateForm(TdmTrayIcon, dmTrayIcon);
  Application.CreateForm(TdmAzureOauth2Rest, dmAzureOauth2Rest);
  Application.CreateForm(TfProjetPersoMain, fProjetPersoMain);
  Application.CreateForm(TfProjetPersoAzureOauth2Authorize, fProjetPersoAzureOauth2Authorize);
  Application.Run;
end.
