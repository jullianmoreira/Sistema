object formPedidos: TformPedidos
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMaximize]
  BorderStyle = bsSingle
  Caption = 'Pedidos - Lan'#231'amento de Pedidos'
  ClientHeight = 474
  ClientWidth = 632
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 0
    Top = 0
    Width = 632
    Height = 81
    Align = alTop
    Caption = 'Dados do Pedido'
    TabOrder = 0
    ExplicitWidth = 635
    object Label1: TLabel
      Left = 24
      Top = 13
      Width = 49
      Height = 16
      Caption = 'N'#250'mero'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label2: TLabel
      Left = 104
      Top = 13
      Width = 44
      Height = 16
      Caption = 'Cliente'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label4: TLabel
      Left = 167
      Top = 62
      Width = 37
      Height = 13
      Caption = 'Cidade:'
    end
    object Label5: TLabel
      Left = 474
      Top = 62
      Width = 17
      Height = 13
      Caption = 'UF:'
    end
    object lblCliente_Cidade: TLabel
      Left = 210
      Top = 62
      Width = 223
      Height = 13
      AutoSize = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblCliente_UF: TLabel
      Left = 497
      Top = 62
      Width = 17
      Height = 13
      Caption = 'UF:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object edtPedido_Codigo: TEdit
      Left = 24
      Top = 35
      Width = 74
      Height = 21
      Alignment = taCenter
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object edtCliente_Codigo: TEdit
      Left = 104
      Top = 35
      Width = 57
      Height = 21
      Hint = 'Pressione F5 para tela de consulta'
      NumbersOnly = True
      TabOrder = 1
      OnExit = edtCliente_CodigoExit
      OnKeyDown = edtCliente_CodigoKeyDown
    end
    object edtCliente_Nome: TEdit
      Left = 167
      Top = 35
      Width = 347
      Height = 21
      DoubleBuffered = True
      Enabled = False
      ParentDoubleBuffered = False
      TabOrder = 2
    end
  end
  object pnBotoes: TPanel
    Left = 0
    Top = 433
    Width = 632
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitLeft = 192
    ExplicitTop = 248
    ExplicitWidth = 185
    DesignSize = (
      632
      41)
    object btSair: TSpeedButton
      Left = 568
      Top = 6
      Width = 57
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Sair'
      OnClick = btSairClick
    end
    object btSalvarPedido: TSpeedButton
      Left = 505
      Top = 6
      Width = 57
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = 'Salvar'
      OnClick = btSalvarPedidoClick
    end
    object Label3: TLabel
      Left = 3
      Top = 7
      Width = 70
      Height = 16
      Caption = 'Valor Total'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label10: TLabel
      Left = 256
      Top = 6
      Width = 165
      Height = 13
      Caption = 'Pressione F5 para tela de consulta'
    end
    object edtPedido_Valor_Total: TEdit
      Left = 79
      Top = 6
      Width = 105
      Height = 21
      Alignment = taRightJustify
      Enabled = False
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
  end
  object pnMID: TPanel
    Left = 0
    Top = 81
    Width = 632
    Height = 352
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitLeft = 144
    ExplicitTop = 168
    ExplicitWidth = 185
    ExplicitHeight = 41
    object GroupBox2: TGroupBox
      Left = 0
      Top = 0
      Width = 65
      Height = 352
      Align = alLeft
      Caption = 'A'#231#245'es'
      TabOrder = 0
      object btNovoProduto: TSpeedButton
        Left = 3
        Top = 20
        Width = 56
        Height = 22
        Caption = 'INCLUIR'
        OnClick = btNovoProdutoClick
      end
      object btRetirar: TSpeedButton
        Left = 3
        Top = 76
        Width = 56
        Height = 22
        Caption = 'RETIRAR'
        OnClick = btRetirarClick
      end
      object btAlterar: TSpeedButton
        Left = 3
        Top = 48
        Width = 56
        Height = 22
        Caption = 'ALTERAR'
        OnClick = btAlterarClick
      end
    end
    object GroupBox3: TGroupBox
      Left = 65
      Top = 0
      Width = 567
      Height = 352
      Align = alClient
      Caption = 'Itens do Pedido'
      TabOrder = 1
      ExplicitLeft = 272
      ExplicitTop = 120
      ExplicitWidth = 185
      ExplicitHeight = 105
      object gbItemProduto: TGroupBox
        Left = 2
        Top = 15
        Width = 563
        Height = 66
        Align = alTop
        Enabled = False
        TabOrder = 0
        ExplicitWidth = 543
        object Label6: TLabel
          Left = 4
          Top = 5
          Width = 52
          Height = 16
          Caption = 'Produto'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label7: TLabel
          Left = 339
          Top = 5
          Width = 31
          Height = 16
          Caption = 'Qtde'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label8: TLabel
          Left = 397
          Top = 5
          Width = 29
          Height = 16
          Caption = 'Unit.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label9: TLabel
          Left = 463
          Top = 5
          Width = 32
          Height = 16
          Caption = 'Total'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object edtProduto_Codigo: TEdit
          Left = 4
          Top = 27
          Width = 57
          Height = 21
          NumbersOnly = True
          TabOrder = 0
          OnExit = edtProduto_CodigoExit
        end
        object edtProduto_Nome: TEdit
          Left = 67
          Top = 27
          Width = 266
          Height = 21
          DoubleBuffered = True
          Enabled = False
          ParentDoubleBuffered = False
          TabOrder = 1
        end
        object edtQuantidade: TEdit
          Left = 339
          Top = 27
          Width = 52
          Height = 21
          TabOrder = 2
          OnChange = edtQuantidadeChange
          OnKeyPress = MascaraNumero
        end
        object edtValor_Unitario: TEdit
          Left = 397
          Top = 27
          Width = 60
          Height = 21
          TabOrder = 3
          OnChange = edtValor_UnitarioChange
          OnExit = edtValor_UnitarioExit
          OnKeyPress = MascaraNumero
        end
        object edtValor_Total: TEdit
          Left = 463
          Top = 27
          Width = 70
          Height = 21
          Enabled = False
          TabOrder = 4
          OnKeyPress = MascaraNumero
        end
      end
      object gridItensPedido: TDBGrid
        Left = 2
        Top = 81
        Width = 563
        Height = 269
        Align = alClient
        DataSource = dsItemPedido
        Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
        TabOrder = 1
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnKeyDown = gridItensPedidoKeyDown
        Columns = <
          item
            Expanded = False
            FieldName = 'produto_codigo'
            Title.Alignment = taCenter
            Title.Caption = 'C'#243'd. Produto'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nome'
            Title.Alignment = taCenter
            Title.Caption = 'Produto'
            Width = 250
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'quantidade'
            Title.Alignment = taCenter
            Title.Caption = 'Qtde'
            Width = 70
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'valor_unitario'
            Title.Alignment = taCenter
            Title.Caption = 'Vlr. Unit'#225'rio'
            Width = 80
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'valor_total'
            Title.Alignment = taCenter
            Title.Caption = 'Vlr. Total'
            Width = 80
            Visible = True
          end>
      end
    end
  end
  object dsItemPedido: TDataSource
    DataSet = cdsItensPedido
    Left = 162
    Top = 345
  end
  object cdsItensPedido: TClientDataSet
    PersistDataPacket.Data = {
      880000009619E0BD01000000180000000500000000000300000088000E70726F
      6475746F5F636F6469676F0400010000000000046E6F6D650200490000000100
      05574944544802000200FF000A7175616E74696461646508000400000000000E
      76616C6F725F756E69746172696F08000400000000000B76616C6F725F746F74
      616C08000400000000000000}
    Active = True
    Aggregates = <>
    Params = <>
    AfterOpen = cdsItensPedidoAfterOpen
    Left = 201
    Top = 345
    object cdsItensPedidoproduto_codigo: TIntegerField
      FieldName = 'produto_codigo'
    end
    object cdsItensPedidonome: TStringField
      FieldName = 'nome'
      Size = 255
    end
    object cdsItensPedidoquantidade: TFloatField
      FieldName = 'quantidade'
    end
    object cdsItensPedidovalor_unitario: TFloatField
      FieldName = 'valor_unitario'
    end
    object cdsItensPedidovalor_total: TFloatField
      FieldName = 'valor_total'
    end
  end
end
