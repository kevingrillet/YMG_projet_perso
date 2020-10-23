unit ProjetPerso.AzureOauth2.Authorize;

interface

uses
   Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
   System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
   Vcl.OleCtrls, SHDocVw,
   ProjetPerso.AzureOauth2.Model;

type
   TfProjetPersoAzureOauth2Authorize = class(TForm)
      WebBrowser: TWebBrowser;
    procedure WebBrowserDocumentComplete(ASender: TObject; const pDisp: IDispatch; const URL: OleVariant);
   private
      FConnection: TAzureConnection;
      { Déclarations privées }
   public
      { Déclarations publiques }
      procedure GetAuthToken(AConnection: TAzureConnection);
   end;

var
   fProjetPersoAzureOauth2Authorize: TfProjetPersoAzureOauth2Authorize;

implementation

{$R *.dfm}

uses
   System.NetEncoding, System.Net.URLClient;

procedure TfProjetPersoAzureOauth2Authorize.GetAuthToken
  (AConnection: TAzureConnection);
var
   LURL: string;
begin
   FConnection := AConnection;

   LURL := FConnection.AuthorizeEndPoint + '?client_id=' + FConnection.ClientId
     + '&response_type=code' + '&redirect_uri=' + TNetEncoding.URL.Encode
     (FConnection.RedirectURL) + '&response_mode=query' + '&scope=openid' +
     '&state=1' + '&resource=' + TNetEncoding.URL.Encode(FConnection.Resource);

   WebBrowser.Navigate(LURL);

   ShowModal;
   BringToFront;
end;

procedure TfProjetPersoAzureOauth2Authorize.WebBrowserDocumentComplete(ASender: TObject; const pDisp: IDispatch;
  const URL: OleVariant);
var
   LURI: TURI;
   LParam: TNameValuePair;
   LError: string;
   LErrorDescription: string;
   LMessage: string;
begin
   if String(URL).StartsWith(FConnection.RedirectURL) then
   begin
      LURI := TURI.Create(URL);

      for LParam in LURI.Params do
      begin
         if LParam.Name = 'code' then
         begin
            WebBrowser.Stop;

            FConnection.AuthCode := LParam.Value;
            ModalResult := mrOk;
            Hide;
            Exit;
         end
         else if LParam.Name = 'error' then
         begin
            LError := LParam.Value;
            LErrorDescription := LURI.ParameterByName['error_description'];
            LMessage := Format('Error: %s (%s)', [LErrorDescription, LError]);

            ShowMessage(LMessage);

            ModalResult := mrCancel;
            Hide;
            Exit;
         end;

      end;
   end;
end;

end.
