{$M+}
{$TYPEINFO ON}
unit Cliente;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB;

type
  TCliente = class(TObject)
  private
    FCodigo: Integer;
    FNome: String;
    FCidade: String;
    FUF: String;
  published
    property Codigo: Integer read FCodigo write FCodigo;
    property Nome: String read FNome write FNome;
    property Cidade: String read FCidade write FCidade;
    property UF: String read FUF write FUF;

  public
    constructor Criar(_Codigo : Integer = -1; _Nome : String = ''; _Cidade : String = ''; _UF : String = '');

  end;

  TClienteRepositorio = class(TObject)
    public
      function listarCliente(condicoes : TStringList) : TDataSet;
  end;

implementation

{ TCliente }

constructor TCliente.Criar(_Codigo: Integer; _Nome, _Cidade, _UF: String);
begin
  inherited Create;

  Self.Codigo := _Codigo;
  Self.Nome := _Nome;
  Self.Cidade := _Cidade;
  Self.UF := _UF;
end;

{ TClienteRepositorio }

function TClienteRepositorio.listarCliente(condicoes: TStringList): TDataSet;
begin

end;

end.
