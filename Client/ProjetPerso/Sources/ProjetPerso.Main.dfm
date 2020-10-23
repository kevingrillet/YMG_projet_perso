object fProjetPersoMain: TfProjetPersoMain
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Projet perso'
  ClientHeight = 269
  ClientWidth = 567
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lParam: TLabel
    Left = 0
    Top = 0
    Width = 567
    Height = 16
    Align = alTop
    Caption = 'Param'#232'tres'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 76
  end
  object pFooter: TPanel
    Left = 0
    Top = 247
    Width = 567
    Height = 22
    Align = alBottom
    BevelEdges = [beBottom]
    BevelOuter = bvNone
    TabOrder = 0
    object lSources: TLabel
      AlignWithMargins = True
      Left = 22
      Top = 3
      Width = 129
      Height = 16
      Align = alLeft
      Caption = 'Sources et documentation:'
      ExplicitHeight = 13
    end
    object iHelp: TImage
      AlignWithMargins = True
      Left = 1
      Top = 1
      Width = 17
      Height = 20
      Margins.Left = 1
      Margins.Top = 1
      Margins.Right = 1
      Margins.Bottom = 1
      Align = alLeft
      ExplicitLeft = 2
      ExplicitTop = 2
      ExplicitHeight = 17
    end
    object llSources: TLinkLabel
      AlignWithMargins = True
      Left = 157
      Top = 3
      Width = 407
      Height = 16
      Hint = 'https://github.com/kevingrillet/YMG_projet_perso'
      Align = alClient
      Caption = '<a>https://github.com/kevingrillet/YMG_projet_perso</a>'
      Color = clBtnFace
      ParentColor = False
      TabOrder = 0
      OnClick = llSourcesClick
      ExplicitWidth = 242
      ExplicitHeight = 17
    end
  end
  object pLog: TPanel
    Left = 364
    Top = 16
    Width = 203
    Height = 231
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object reLog: TRichEdit
      AlignWithMargins = True
      Left = 3
      Top = 44
      Width = 197
      Height = 184
      Align = alClient
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Zoom = 100
    end
    object pLogParam: TPanel
      Left = 0
      Top = 0
      Width = 203
      Height = 41
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object lLog: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 197
        Height = 13
        Align = alTop
        Caption = 'Log'
        ExplicitWidth = 17
      end
      object llLog: TLinkLabel
        AlignWithMargins = True
        Left = 71
        Top = 22
        Width = 129
        Height = 16
        Align = alClient
        Caption = 'Fichier non cr'#233#233
        TabOrder = 0
        ExplicitWidth = 80
        ExplicitHeight = 17
      end
      object cbLog: TCheckBox
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 62
        Height = 16
        Align = alLeft
        Caption = 'Activer'
        TabOrder = 1
      end
    end
  end
  object pParam: TPanel
    Left = 0
    Top = 16
    Width = 364
    Height = 231
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pParam'
    ShowCaption = False
    TabOrder = 2
    object pActions: TPanel
      Left = 0
      Top = 48
      Width = 364
      Height = 48
      Align = alTop
      BevelEdges = [beBottom]
      BevelOuter = bvNone
      TabOrder = 0
      object lActions: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 358
        Height = 13
        Align = alTop
        Caption = 'Actions'
        ExplicitWidth = 35
      end
      object fpActions: TFlowPanel
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 358
        Height = 29
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object bOff: TButton
          AlignWithMargins = True
          Left = 2
          Top = 2
          Width = 85
          Height = 25
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'Invisible'
          ImageIndex = 0
          Images = dmImages.imageList32
          TabOrder = 0
          OnClick = bBtnClick
        end
        object bGreen: TButton
          AlignWithMargins = True
          Left = 91
          Top = 2
          Width = 85
          Height = 25
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'Disponible'
          ImageIndex = 1
          Images = dmImages.imageList32
          TabOrder = 1
          OnClick = bBtnClick
        end
        object bYellow: TButton
          AlignWithMargins = True
          Left = 180
          Top = 2
          Width = 85
          Height = 25
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'Absent'
          ImageIndex = 2
          Images = dmImages.imageList32
          TabOrder = 2
          OnClick = bBtnClick
        end
        object bRed: TButton
          AlignWithMargins = True
          Left = 269
          Top = 2
          Width = 85
          Height = 25
          Margins.Left = 2
          Margins.Top = 2
          Margins.Right = 2
          Margins.Bottom = 2
          Caption = 'Occup'#233
          ImageIndex = 3
          Images = dmImages.imageList32
          TabOrder = 3
          OnClick = bBtnClick
        end
      end
    end
    object pAuto: TPanel
      Left = 0
      Top = 96
      Width = 364
      Height = 48
      Align = alTop
      BevelEdges = [beBottom]
      BevelOuter = bvNone
      TabOrder = 1
      object lAuto: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 358
        Height = 13
        Align = alTop
        Caption = 'Actions automatiques'
        ExplicitWidth = 103
      end
      object fpAuto: TFlowPanel
        AlignWithMargins = True
        Left = 3
        Top = 19
        Width = 358
        Height = 29
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 0
        object cbWindows: TCheckBox
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 170
          Height = 17
          Caption = 'Session Windows'
          TabOrder = 0
        end
        object cbTeams: TCheckBox
          AlignWithMargins = True
          Left = 179
          Top = 3
          Width = 170
          Height = 17
          Caption = 'Teams'
          Enabled = False
          TabOrder = 1
          OnClick = cbTeamsClick
        end
      end
    end
    object pAdresse: TPanel
      Left = 0
      Top = 0
      Width = 364
      Height = 48
      Align = alTop
      BevelEdges = [beBottom]
      BevelOuter = bvNone
      TabOrder = 2
      object lAdresse: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 358
        Height = 13
        Align = alTop
        Caption = 'Adresse du module'
        ExplicitWidth = 91
      end
      object eUrl: TEdit
        AlignWithMargins = True
        Left = 3
        Top = 22
        Width = 264
        Height = 23
        Align = alClient
        TabOrder = 0
        ExplicitHeight = 21
      end
      object bValider: TButton
        AlignWithMargins = True
        Left = 272
        Top = 21
        Width = 85
        Height = 25
        Margins.Left = 2
        Margins.Top = 2
        Margins.Right = 7
        Margins.Bottom = 2
        Align = alRight
        Caption = 'Valider'
        ImageIndex = 0
        Images = dmImages.imageList16
        TabOrder = 1
        OnClick = bValiderClick
      end
    end
    object pTeams: TPanel
      Left = 0
      Top = 144
      Width = 364
      Height = 87
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 3
      object lTeams: TLabel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 358
        Height = 13
        Align = alTop
        Caption = 'Teams'
        ExplicitWidth = 31
      end
      object fbLogin: TFlowPanel
        Left = 0
        Top = 19
        Width = 364
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        TabOrder = 0
        object bLogin: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Connexion'
          Enabled = False
          TabOrder = 0
          OnClick = bLoginClick
        end
        object lLogin: TLabel
          AlignWithMargins = True
          Left = 84
          Top = 9
          Width = 66
          Height = 13
          Margins.Top = 9
          Caption = 'Non connect'#233
        end
      end
      object fbToken: TFlowPanel
        Left = 0
        Top = 49
        Width = 364
        Height = 30
        Align = alTop
        BevelOuter = bvNone
        Caption = 'fbToken'
        TabOrder = 1
        object bGetToken: TButton
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 75
          Height = 25
          Caption = 'Token'
          Enabled = False
          TabOrder = 0
          OnClick = bGetTokenClick
        end
        object eToken: TEdit
          AlignWithMargins = True
          Left = 84
          Top = 4
          Width = 270
          Height = 21
          Margins.Top = 4
          Enabled = False
          TabOrder = 1
        end
      end
    end
  end
end
