unit ProjetPerso.AzureOauth2.Rest;

interface

uses
   System.SysUtils, System.Classes, Rest.Types, Rest.Client,
   Data.Bind.Components, Data.Bind.ObjectScope,
   ProjetPerso.AzureOauth2.Model;

type
   TCallBack = procedure(sString: string) of object;

   TdmAzureOauth2Rest = class(TDataModule)
      RESTClient: TRESTClient;
      RESTTokenRequest: TRESTRequest;
      RESTTokenResponse: TRESTResponse;
      procedure RESTTokenRequestAfterExecute(Sender: TCustomRESTRequest);
   private
      OnRESTTokenRequestAfterExecute: TCallBack;
      { Déclarations privées }
   public
      FConnection: TAzureConnection;

      procedure Init(ACallBack: TCallBack);

      function GetToken: string;
      function Login: string;

      { Déclarations publiques }
   const
      {MESSAGE ERROR'Enter your subscription id and client id below then delete this line'}
      CST_SUBSCRIPTIONID = '';
      CST_CLIENT_ID = '029002a9-e0e7-4abc-b5d9-77309f578cda';
      CST_RESOURCE = 'https://management.core.windows.net/';
      CST_REDIRECTURL = 'http://localhost/';
      CST_AUTHORIZEENDPOINT =
        'https://login.microsoftonline.com/common/oauth2/authorize';
      CST_TOKENENDPOINT =
        'https://login.microsoftonline.com/common/oauth2/token';
      CST_RESTENDPOINT = 'https://management.azure.com';

   end;

var
   dmAzureOauth2Rest: TdmAzureOauth2Rest;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

uses VCL.Controls,
   ProjetPerso.Constantes, ProjetPerso.AzureOauth2.Authorize;

function TdmAzureOauth2Rest.GetToken: string;
begin
   RESTClient.BaseURL := FConnection.TokenEndPoint;

   RESTTokenRequest.Method := TRESTRequestMethod.rmPOST;
   RESTTokenRequest.Params.AddItem('grant_type', 'authorization_code',
     TRESTRequestParameterKind.pkGetOrPost);
   RESTTokenRequest.Params.AddItem('client_id', FConnection.ClientId,
     TRESTRequestParameterKind.pkGetOrPost);
   RESTTokenRequest.Params.AddItem('code', FConnection.AuthCode,
     TRESTRequestParameterKind.pkGetOrPost);
   RESTTokenRequest.Params.AddItem('redirect_uri', FConnection.RedirectURL,
     TRESTRequestParameterKind.pkGetOrPost);
   RESTTokenRequest.Params.AddItem('resource', FConnection.Resource,
     TRESTRequestParameterKind.pkGetOrPost, [poDoNotEncode]);

   RESTTokenRequest.ExecuteAsync;
end;

procedure TdmAzureOauth2Rest.Init(ACallBack: TCallBack);
begin
   OnRESTTokenRequestAfterExecute := ACallBack;

   FConnection := TAzureConnection.Create;
   FConnection.SubscriptionId := CST_SUBSCRIPTIONID;
   FConnection.ClientId := CST_CLIENT_ID;
   FConnection.Resource := CST_RESOURCE;
   FConnection.RedirectURL := CST_REDIRECTURL;
   FConnection.AuthorizeEndPoint := CST_AUTHORIZEENDPOINT;
   FConnection.TokenEndPoint := CST_TOKENENDPOINT;
   FConnection.RESTEndPoint := CST_RESTENDPOINT;
end;

function TdmAzureOauth2Rest.Login: string;
begin
   Result := CST_ERROR;
   fProjetPersoAzureOauth2Authorize.GetAuthToken(FConnection);

   if fProjetPersoAzureOauth2Authorize.ModalResult = mrOk then
   begin
      Result := FConnection.AuthCode;
   end;
end;

procedure TdmAzureOauth2Rest.RESTTokenRequestAfterExecute
  (Sender: TCustomRESTRequest);
begin
   FConnection.AuthToken := RESTTokenResponse.JSONValue.GetValue<String>
     ('access_token');

   if Assigned(OnRESTTokenRequestAfterExecute) then
      OnRESTTokenRequestAfterExecute(FConnection.AuthToken);
end;

end.
