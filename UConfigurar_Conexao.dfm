object formConfigurar_Conexao: TformConfigurar_Conexao
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Pedidos - Configurar Conex'#227'o'
  ClientHeight = 199
  ClientWidth = 455
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 11
    Width = 43
    Height = 19
    Caption = 'Host:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 16
    Top = 44
    Width = 55
    Height = 19
    Caption = 'Banco:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 16
    Top = 74
    Width = 68
    Height = 19
    Caption = 'Usu'#225'rio:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblStatus_Conexao: TLabel
    Left = 16
    Top = 107
    Width = 159
    Height = 19
    Caption = 'Status da Conex'#227'o:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label4: TLabel
    Left = 0
    Top = 135
    Width = 455
    Height = 14
    Align = alBottom
    Alignment = taCenter
    Caption = 
      '* Obrigat'#243'rio configurar a senha "passwd" para o usu'#225'rio informa' +
      'do'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 367
  end
  object Label5: TLabel
    Left = 295
    Top = 11
    Width = 51
    Height = 19
    Caption = 'Porta:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pnBottom: TPanel
    Left = 0
    Top = 149
    Width = 455
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      455
      50)
    object btFechar: TSpeedButton
      Left = 362
      Top = 10
      Width = 80
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = '&Fechar'
      OnClick = btFecharClick
      ExplicitLeft = 552
    end
    object btSalvar: TSpeedButton
      Left = 276
      Top = 10
      Width = 80
      Height = 30
      Anchors = [akRight, akBottom]
      Caption = '&Salvar'
      OnClick = btSalvarClick
      ExplicitLeft = 466
    end
    object btTestar_Conexao: TSpeedButton
      Left = 16
      Top = 10
      Width = 80
      Height = 30
      Caption = '&Testar'
      OnClick = btTestar_ConexaoClick
    end
  end
  object edtHost: TEdit
    Left = 90
    Top = 8
    Width = 199
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
  object edtBanco: TEdit
    Left = 90
    Top = 41
    Width = 352
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object edtUsuario: TEdit
    Left = 90
    Top = 74
    Width = 352
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object edtPorta: TEdit
    Left = 352
    Top = 8
    Width = 90
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    NumbersOnly = True
    ParentFont = False
    TabOrder = 4
  end
end
