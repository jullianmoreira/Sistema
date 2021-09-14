object formMain: TformMain
  Left = 0
  Top = 0
  Caption = 'Sistema de Pedidos'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  Menu = menuMain
  OldCreateOrder = False
  WindowState = wsMaximized
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gbInfoBanco: TGroupBox
    Left = 0
    Top = 0
    Width = 635
    Height = 49
    Align = alTop
    Caption = 'Informa'#231#245'es de Conex'#227'o'
    TabOrder = 0
    object lbl_Info_BancoDados: TLabel
      Left = 2
      Top = 15
      Width = 558
      Height = 32
      Align = alClient
      AutoSize = False
      Caption = 'Banco de Dados'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitWidth = 35
      ExplicitHeight = 631
    end
    object btConfigurarBanco: TSpeedButton
      Left = 560
      Top = 15
      Width = 73
      Height = 32
      Action = actionConfigurarBanco
      Align = alRight
      Caption = '&Configurar'
    end
  end
  object gbInfoPedido: TGroupBox
    Left = 0
    Top = 49
    Width = 635
    Height = 147
    Align = alTop
    Caption = 'Informa'#231#245'es dos Pedidos'
    TabOrder = 1
    object pnVisao: TPanel
      Left = 2
      Top = 15
      Width = 223
      Height = 130
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lbl_visao_pos_0: TLabel
        Left = 0
        Top = 25
        Width = 223
        Height = 25
        Align = alTop
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 0
        ExplicitWidth = 207
      end
      object lbl_visao_pos_1: TLabel
        Left = 0
        Top = 50
        Width = 223
        Height = 25
        Align = alTop
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 56
        ExplicitWidth = 207
      end
      object lbl_visao_pos_2: TLabel
        Left = 0
        Top = 75
        Width = 223
        Height = 25
        Align = alTop
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 81
        ExplicitWidth = 207
      end
      object lbl_visao_pos_3: TLabel
        Left = 0
        Top = 100
        Width = 223
        Height = 25
        Align = alTop
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 106
        ExplicitWidth = 207
      end
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 223
        Height = 25
        Align = alTop
        AutoSize = False
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = -9
        ExplicitWidth = 207
      end
    end
    object pnQtde: TPanel
      Left = 225
      Top = 15
      Width = 128
      Height = 130
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 1
      object lbl_qtde_pos_0: TLabel
        Left = 0
        Top = 25
        Width = 128
        Height = 25
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 0
        ExplicitWidth = 207
      end
      object lbl_qtde_pos_1: TLabel
        Left = 0
        Top = 50
        Width = 128
        Height = 25
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 56
        ExplicitWidth = 207
      end
      object lbl_qtde_pos_2: TLabel
        Left = 0
        Top = 75
        Width = 128
        Height = 25
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 81
        ExplicitWidth = 207
      end
      object lbl_qtde_pos_3: TLabel
        Left = 0
        Top = 100
        Width = 128
        Height = 25
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 106
        ExplicitWidth = 207
      end
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 128
        Height = 25
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Qtde'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 6
        ExplicitTop = -6
      end
    end
    object pnValorFaturado: TPanel
      Left = 353
      Top = 15
      Width = 152
      Height = 130
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 2
      object lbl_valor_pos_0: TLabel
        Left = 0
        Top = 25
        Width = 152
        Height = 25
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 0
        ExplicitWidth = 207
      end
      object lbl_valor_pos_1: TLabel
        Left = 0
        Top = 50
        Width = 152
        Height = 25
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 56
        ExplicitWidth = 207
      end
      object lbl_valor_pos_2: TLabel
        Left = 0
        Top = 75
        Width = 152
        Height = 25
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 6
        ExplicitTop = 56
        ExplicitWidth = 128
      end
      object lbl_valor_pos_3: TLabel
        Left = 0
        Top = 100
        Width = 152
        Height = 25
        Align = alTop
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'PEDIDO EM ANDAMENTO'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clGreen
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitTop = 106
        ExplicitWidth = 207
      end
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 152
        Height = 25
        Align = alTop
        Alignment = taCenter
        AutoSize = False
        Caption = 'Valor'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Tahoma'
        Font.Style = []
        ParentFont = False
        Layout = tlCenter
        ExplicitLeft = 6
        ExplicitTop = -6
      end
    end
  end
  object menuMain: TMainMenu
    Left = 520
    Top = 216
    object Funes1: TMenuItem
      Caption = '&Fun'#231#245'es'
      object NovoPedido1: TMenuItem
        Action = actionNovoPedido
      end
      object FecharPedido1: TMenuItem
        Action = actionFecharPedido
      end
      object CancelarPedido1: TMenuItem
        Action = actionCancelarPedido
      end
    end
    object Utilitrios1: TMenuItem
      Caption = '&Utilit'#225'rios'
      object ConfigurarBancodeDados1: TMenuItem
        Action = actionConfigurarBanco
      end
    end
  end
  object actionMain: TActionList
    Left = 560
    Top = 216
    object actionNovoPedido: TAction
      Category = 'Fun'#231#245'es'
      Caption = 'Novo Pedido'
      OnExecute = actionNovoPedidoExecute
    end
    object actionFecharPedido: TAction
      Category = 'Fun'#231#245'es'
      Caption = 'Fechar Pedido'
    end
    object actionCancelarPedido: TAction
      Category = 'Fun'#231#245'es'
      Caption = 'Cancelar Pedido'
    end
    object actionConfigurarBanco: TAction
      Category = 'Utilit'#225'rios'
      Caption = 'Configurar Banco de Dados'
      OnExecute = actionConfigurarBancoExecute
    end
  end
  object loadDashboard: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = loadDashboardTimer
    Left = 480
    Top = 216
  end
end
