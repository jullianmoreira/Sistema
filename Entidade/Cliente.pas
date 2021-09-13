{$M+}
{$TYPEINFO ON}
unit Cliente;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB, IRepositorio, Tipos,
FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Controls, Vcl.Forms;

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

  TClienteRepositorio = class(TInterfacedObject, TIRepositorio)
    public
      function nomeCampoConsulta : String;
      function nomeRepositorio : String;
      function listar(condicoes : TCriterio) : TDataSet;
  end;

  TClienteController = class(TObject)
    public
      function Consultar : TCliente;
  end;

implementation

{ TCliente }

uses DMMain, Utilitario, UPesquisa;

constructor TCliente.Criar(_Codigo: Integer; _Nome, _Cidade, _UF: String);
begin
  inherited Create;

  Self.Codigo := _Codigo;
  Self.Nome := _Nome;
  Self.Cidade := _Cidade;
  Self.UF := _UF;
end;

{ TClienteRepositorio }

function TClienteRepositorio.listar(condicoes: TCriterio): TDataSet;
var
  fdQry : TFDQuery;
begin
  try
    fdQry := TFDQuery.Create(nil);
    fdQry.Connection := conexaoDados.fdConexao;
    with fdQry do
      begin
        Close;
        Sql.Clear;
        Sql.Add('select cliente.codigo, cliente.nome, cliente.cidade, cliente.uf');
        Sql.Add('from cliente');
        Sql.AddStrings(condicoes.getCriterios);

        Open;
        Result := fdQry;
      end;
  except
    on e : exception do
      begin
        Result := TDataSet.Create(nil);
        TErro.Mostrar('Não foi possível consultar os clientes.'+#13+
        'Mensagem: '+e.Message);
        if Assigned(fdQry) then
          begin
            fdQry.SQL.SaveToFile(TFuncoes.LocalApp+'ErroConsultaCliente.sql');
            FreeAndNil(fdQry);
          end;

      end;
  end;
end;

function TClienteRepositorio.nomeCampoConsulta: String;
begin
  Result := 'nome';
end;

function TClienteRepositorio.nomeRepositorio: String;
begin
  Result := 'Cliente';
end;

{ TClienteController }

function TClienteController.Consultar: TCliente;
var
  configuracao : TConfigTela;
begin
  try
    Result := TCliente.Criar;
    configuracao := TConfigTela.Create;

    configuracao.Repositorio := TClienteRepositorio.Create;
    SetLength(configuracao.Colunas, 4);

    configuracao.Colunas[0] := TColumn.Create(nil);
    configuracao.Colunas[0].FieldName := 'codigo';
    configuracao.Colunas[0].Title.Caption := 'Código';
    configuracao.Colunas[0].Title.Alignment := taCenter;
    configuracao.Colunas[0].Width := 75;

    configuracao.Colunas[1] := TColumn.Create(nil);
    configuracao.Colunas[1].FieldName := 'nome';
    configuracao.Colunas[1].Title.Caption := 'Nome';
    configuracao.Colunas[1].Title.Alignment := taCenter;
    configuracao.Colunas[1].Width := 280;

    configuracao.Colunas[2] := TColumn.Create(nil);
    configuracao.Colunas[2].FieldName := 'cidade';
    configuracao.Colunas[2].Title.Caption := 'Cidade';
    configuracao.Colunas[2].Title.Alignment := taCenter;
    configuracao.Colunas[2].Width := 75;

    configuracao.Colunas[3] := TColumn.Create(nil);
    configuracao.Colunas[3].FieldName := 'uf';
    configuracao.Colunas[3].Title.Caption := 'UF';
    configuracao.Colunas[3].Title.Alignment := taCenter;
    configuracao.Colunas[3].Width := 75;

    frmPesquisa := TfrmPesquisa.Criar(configuracao);
    if frmPesquisa.ShowModal = mrOK then
      begin
        Result.Codigo := frmPesquisa.dsPesquisa.DataSet.FieldByName('codigo').AsInteger;
        Result.Nome := frmPesquisa.dsPesquisa.DataSet.FieldByName('nome').AsString;
        Result.Cidade := frmPesquisa.dsPesquisa.DataSet.FieldByName('cidade').AsString;
        Result.UF := frmPesquisa.dsPesquisa.DataSet.FieldByName('uf').AsString;
      end;

    FreeAndNil(frmPesquisa);
    FreeAndNil(configuracao);

  except
    on e : exception do
      begin
        Result := TCliente.Criar;
      end;
  end;
end;

end.
