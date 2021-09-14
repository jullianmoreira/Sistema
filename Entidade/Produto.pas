{$M+}
{$TYPEINFO ON}
unit Produto;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB, IRepositorio, Tipos,
      FireDAC.Comp.Client, Vcl.Grids, Vcl.DBGrids,
      Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Controls, Vcl.Forms, UPesquisa;
const
  ENTIDADE = 'Produto';

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

  TProdutoRepositorio = class(TInterfacedObject, TIRepositorio)
    public
      function nomeCampoConsulta : String;
      function nomeRepositorio : String;
      function listar(condicoes : TCriterio) : TDataSet;
  end;


  TProdutoController = class(TObject)
    private
      repositorio : TIRepositorio;

    public
      constructor Create;
      function Consultar : TProduto;
      function pegarPorCodigo(Codigo : Integer) : TProduto;
  end;

implementation

{ TProduto }

uses DMMain, Utilitario;

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

{ TProdutoRepositorio }

function TProdutoRepositorio.listar(condicoes : TCriterio): TDataSet;
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
        Sql.Add('select produto.codigo, produto.nome, produto.valor_venda');
        Sql.Add('from produto');
        Sql.AddStrings(condicoes.getCriterios);

        Open;
        Result := fdQry;
      end;
  except
    on e : exception do
      begin
        Result := TDataSet.Create(nil);
        TErro.Mostrar('Não foi possível consultar os produtos.'+#13+
        'Mensagem: '+e.Message);
        if Assigned(fdQry) then
          begin
            fdQry.SQL.SaveToFile(TFuncoes.LocalApp+'ErroConsultaProduto.sql');
            FreeAndNil(fdQry);
          end;

      end;
  end;
end;

function TProdutoRepositorio.nomeCampoConsulta: String;
begin
  Result := CAMPO_NOME;
end;

function TProdutoRepositorio.nomeRepositorio: String;
begin
  Result := ENTIDADE;
end;

{ TProdutoController }

function TProdutoController.Consultar: TProduto;
var
  configuracao : TConfigTela;
begin
  try
    Result := TProduto.Criar;
    configuracao := TConfigTela.Create;

    configuracao.Repositorio := Self.repositorio;
    SetLength(configuracao.Colunas, 3);

    configuracao.Colunas[0] := TColumn.Create(nil);
    configuracao.Colunas[0].FieldName := CAMPO_CODIGO;
    configuracao.Colunas[0].Title.Caption := 'Código';
    configuracao.Colunas[0].Title.Alignment := taCenter;
    configuracao.Colunas[0].Width := 75;

    configuracao.Colunas[1] := TColumn.Create(nil);
    configuracao.Colunas[1].FieldName := CAMPO_NOME;
    configuracao.Colunas[1].Title.Caption := 'Nome';
    configuracao.Colunas[1].Title.Alignment := taCenter;
    configuracao.Colunas[1].Width := 280;

    configuracao.Colunas[2] := TColumn.Create(nil);
    configuracao.Colunas[2].FieldName := CAMPO_VALOR_VENDA;
    configuracao.Colunas[2].Title.Caption := 'Vlr. Venda';
    configuracao.Colunas[2].Title.Alignment := taRightJustify;
    configuracao.Colunas[2].Width := 75;

    frmPesquisa := TfrmPesquisa.Criar(configuracao);
    if frmPesquisa.ShowModal = mrOK then
      begin
        if frmPesquisa.Codigo_Selecionado > 0 then
          begin
            Result.Codigo := frmPesquisa.dsPesquisa.DataSet.FieldByName(CAMPO_CODIGO).AsInteger;
            Result.Nome := frmPesquisa.dsPesquisa.DataSet.FieldByName(CAMPO_NOME).AsString;
            Result.ValorVenda := frmPesquisa.dsPesquisa.DataSet.FieldByName(CAMPO_VALOR_VENDA).AsFloat;
          end;
      end;

    FreeAndNil(frmPesquisa);
    FreeAndNil(configuracao);

  except
    on e : exception do
      begin
        Result := TProduto.Criar;
      end;
  end;

end;

constructor TProdutoController.Create;
begin
  inherited;

  repositorio := TProdutoRepositorio.Create;
end;

function TProdutoController.pegarPorCodigo(Codigo: Integer): TProduto;
var
  criterio : TCriterio;
begin
  try
    criterio := TCriterio.Criar;
    criterio.addCondicao(CAMPO_CODIGO,'=',Codigo.ToString);

    Result := TProduto.Create;
    with Self.repositorio.listar(criterio) do
      begin
        if not IsEmpty then
          begin
            Result.Codigo := FieldByName(CAMPO_CODIGO).AsInteger;
            Result.Nome := FieldByName(CAMPO_NOME).AsString;
            Result.ValorVenda := FieldByName(CAMPO_VALOR_VENDA).AsFloat;
          end
        else
          begin
            Result.Codigo := SEM_REGISTRO;
            Result.Nome := VAZIO;
            Result.ValorVenda := ZeroValue;
          end;
      end;
  finally
    FreeAndNil(criterio);
  end;
end;

end.
