object dmAzureOauth2Rest: TdmAzureOauth2Rest
  OldCreateOrder = False
  Height = 172
  Width = 253
  object RESTClient: TRESTClient
    Params = <>
    Left = 16
    Top = 8
  end
  object RESTTokenRequest: TRESTRequest
    Client = RESTClient
    Params = <>
    Response = RESTTokenResponse
    OnAfterExecute = RESTTokenRequestAfterExecute
    SynchronizedEvents = False
    Left = 40
    Top = 56
  end
  object RESTTokenResponse: TRESTResponse
    Left = 40
    Top = 104
  end
end
