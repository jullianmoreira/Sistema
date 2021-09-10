{$M+}
{$TYPEINFO ON}
unit ItemPedido;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB;

type
  TItemPedido = class(TObject)
  private
    FCodigo: Integer;
    FPedido_Codigo: Integer;
    FProduto_Codigo: Integer;
    FData_Criacao: TDateTime;
    FData_Entrega: TDateTime;
    FQuantidade: Extended;
    FValor_Unitario: Extended;
    FValor_Total: Extended;

  published
    property Codigo: Integer read FCodigo write FCodigo;
    property Pedido_Codigo: Integer read FPedido_Codigo write FPedido_Codigo;
    property Produto_Codigo: Integer read FProduto_Codigo write FProduto_Codigo;
    property Data_Criacao: TDateTime read FData_Criacao write FData_Criacao;
    property Data_Entrega: TDateTime read FData_Entrega write FData_Entrega;
    property Quantidade: Extended read FQuantidade write FQuantidade;
    property Valor_Unitario: Extended read FValor_Unitario write FValor_Unitario;
    property Valor_Total: Extended read FValor_Total write FValor_Total;
  end;

  TItemPedidoRepositorio = class(TObject)
    public
      function listar(condicoes : TStringList) : TDataSet;

      function inserirItemPedido(_ItemPedido : TItemPedido) : Boolean;
      function atualizarItemPedido(_ItemPedido : TItemPedido) : Boolean;
      function excluirItemPedido(_ItemPedido : TItemPedido) : Boolean;
  end;

implementation

end.
