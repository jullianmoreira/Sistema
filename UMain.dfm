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
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 635
    Height = 89
    Align = alTop
    Caption = 'Informa'#231#245'es Gerais'
    TabOrder = 0
    object lbl_Info_BancoDados: TLabel
      Left = 2
      Top = 15
      Width = 631
      Height = 35
      Align = alTop
      AutoSize = False
      Caption = 'Banco de Dados'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object lbl_Info_Pedidos: TLabel
      Left = 2
      Top = 50
      Width = 631
      Height = 35
      Align = alTop
      AutoSize = False
      Caption = 'Banco de Dados'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      ExplicitTop = 40
    end
  end
  object menuMain: TMainMenu
    Left = 184
    Top = 152
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
    end
  end
  object actionMain: TActionList
    Left = 224
    Top = 152
    object actionNovoPedido: TAction
      Category = 'Fun'#231#245'es'
      Caption = 'Novo Pedido'
    end
    object actionFecharPedido: TAction
      Category = 'Fun'#231#245'es'
      Caption = 'Fechar Pedido'
    end
    object actionCancelarPedido: TAction
      Category = 'Fun'#231#245'es'
      Caption = 'Cancelar Pedido'
    end
    object actionInstalarBanco: TAction
      Category = 'Utilit'#225'rios'
      Caption = 'Instalar Banco de Dados'
    end
  end
end
