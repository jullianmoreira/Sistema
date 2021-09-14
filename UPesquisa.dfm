object frmPesquisa: TfrmPesquisa
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pesquisar'
  ClientHeight = 344
  ClientWidth = 518
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 518
    Height = 65
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 3
      Width = 123
      Height = 13
      Caption = 'Voc'#234' est'#225' localizando em:'
    end
    object lblRepositorio: TLabel
      Left = 145
      Top = 3
      Width = 3
      Height = 13
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtNomeConsulta: TEdit
      Left = 18
      Top = 22
      Width = 487
      Height = 21
      TabOrder = 0
      OnChange = edtNomeConsultaChange
      OnKeyDown = edtNomeConsultaKeyDown
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 309
    Width = 518
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btSelecionar: TSpeedButton
      Left = 384
      Top = 6
      Width = 55
      Height = 22
      Caption = 'Selecionar'
      OnClick = btSelecionarClick
    end
    object btFechar: TSpeedButton
      Left = 445
      Top = 6
      Width = 60
      Height = 22
      Caption = 'Fechar'
      OnClick = btFecharClick
    end
  end
  object gridPesquisa: TDBGrid
    Left = 0
    Top = 65
    Width = 518
    Height = 244
    Align = alClient
    DataSource = dsPesquisa
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDblClick = gridPesquisaDblClick
    OnKeyDown = gridPesquisaKeyDown
  end
  object dsPesquisa: TDataSource
    Left = 368
    Top = 216
  end
end
