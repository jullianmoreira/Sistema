{$M+}
{$TYPEINFO ON}
unit Produto;

interface
uses System.Classes, System.SysUtils, System.Math;

type
  TProduto = class(TObject)
  private
    FCodigo: Integer;
    FNome: String;
    FValorVenda: Extended;
  published
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: String read FNome write FNome;
    property ValorVenda: Extended read FValorVenda write FValorVenda;
  public
    constructor Criar(_Codigo : Integer = -1; _Nome : String = ''; _ValorVenda : Extended = 0);
    function ValorParaBanco : String;
  end;

implementation

{ TProduto }

constructor TProduto.Criar(_Codigo: Integer; _Nome : String; _ValorVenda: Extended);
begin
  inherited Create;

  Self.Codigo := _Codigo;
  Self.Nome := _Nome;
  Self.ValorVenda := _ValorVenda;
end;

function TProduto.ValorParaBanco: String;
var
  strBanco : String;
begin
  try
    strBanco := FormatFloat('#0.00', Self.ValorVenda);
    Result := strBanco.Replace(',','.');
  except
    Result := '0';
  end;
end;

end.