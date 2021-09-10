{$M+}
{$TYPEINFO ON}
unit Pedido;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB;

type
  TPedido = class(TObject)
  private
    FCodigo: Integer;
    FCliente_Codigo: Integer;
    FData_Criacao: TDateTime;
    FData_Fechamento: TDateTime;
    FValor_Total: Extended;
  published
    property Codigo: Integer read FCodigo write FCodigo;
    property Cliente_Codigo: Integer read FCliente_Codigo write FCliente_Codigo;
    property Data_Criacao: TDateTime read FData_Criacao write FData_Criacao;
    property Valor_Total: Extended read FValor_Total write FValor_Total;
    property Data_Fechamento: TDateTime read FData_Fechamento write FData_Fechamento;
  end;

  TPedidoRepositorio = class(TObject)
    public
      function listarPedidos(condicoes : TStringList) : TDataSet;
      function listarPedidosComProdutos(condicoes : TStringList) : TDataSet;
      function pedidosDashboard : TStringList;

      function inserirPedido(_Pedido : TPedido) : Boolean;
      function atualizarPedido(_Pedido : TPedido) : Boolean;
      function excluirPedido(_Pedido : TPedido) : Boolean;
  end;

implementation

{ TPedidoRepositorio }

uses DMMain;

function TPedidoRepositorio.atualizarPedido(_Pedido: TPedido): Boolean;
begin

end;

function TPedidoRepositorio.excluirPedido(_Pedido: TPedido): Boolean;
begin

end;

function TPedidoRepositorio.inserirPedido(_Pedido: TPedido): Boolean;
begin

end;

function TPedidoRepositorio.listarPedidos(condicoes: TStringList): TDataSet;
begin

end;

function TPedidoRepositorio.listarPedidosComProdutos(
  condicoes: TStringList): TDataSet;
begin

end;

function TPedidoRepositorio.pedidosDashboard: TStringList;
begin

end;

end.
