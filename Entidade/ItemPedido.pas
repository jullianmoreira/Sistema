{$M+}
{$TYPEINFO ON}
unit ItemPedido;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB, Utilitario,
  FireDAC.Comp.Client;

type
  {Objeto que representa a tabela "itempedido" no banco de dados.
    Este objeto encapsula as funções de validação de dados básica e seus comandos:
    - Insert
    - Update
  }
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

  public
    { Objeto pode ser validado em 3 tipos de eventos
        - INCLUSAO
        - ATUALIZACAO
        - EXCLUSAO
        Cada evento possui sua particularidade de validação
      }
    function objetoValido(validando : String) : Boolean;
    function getUpdate : TStringList;
    function getInsert : TStringLIst;

    constructor Criar;
  end;

  TItemPedidoRepositorio = class(TObject)
    public
      function listar(condicoes : TCriterio) : TDataSet;

      function inserirItemPedido(_ItemPedido : TItemPedido) : Boolean;
      function atualizarItemPedido(_ItemPedido : TItemPedido) : Boolean;
      function excluirItemPedido(_ItemPedido : TItemPedido) : Boolean;
  end;

implementation

{ TItemPedidoRepositorio }

uses DMMain;

function TItemPedidoRepositorio.atualizarItemPedido(
  _ItemPedido: TItemPedido): Boolean;
begin
  try
    Result := false;
    conexaoDados.fdComando.Close;
    if _ItemPedido.objetoValido(ATUALIZACAO) then
      begin
        with conexaoDados.fdComando.CommandText do
          begin
            Clear;
            AddStrings(_ItemPedido.getUpdate);
          end;

        if conexaoDados.fdComando.CommandText.Count > 0 then
          begin
            conexaoDados.fdTransacao.StartTransaction;
            conexaoDados.fdComando.Execute;
            conexaoDados.fdTransacao.Commit;
            Result := true;
          end;
      end;
  except
    on e : exception do
      begin
        Result := false;
        TErro.Mostrar('Não foi possível atualizar os dados do Item do Pedido!'+#13+
        'Mensagem: '+e.Message);
        conexaoDados.fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroAtualizarItemPedido.sql');
        conexaoDados.fdTransacao.Rollback;

      end;
  end;
end;

function TItemPedidoRepositorio.excluirItemPedido(
  _ItemPedido: TItemPedido): Boolean;
begin
  try
    Result := false;
    conexaoDados.fdComando.Close;
    if _ItemPedido.objetoValido(EXCLUSAO) then
      begin
        with conexaoDados.fdComando.CommandText do
          begin
            Clear;
            Add('delete from itempedido where pedido_codigo = '+_ItemPedido.Codigo.ToString+';');
          end;

        if conexaoDados.fdComando.CommandText.Count > 0 then
          begin
            conexaoDados.fdTransacao.StartTransaction;
            conexaoDados.fdComando.Execute;
            conexaoDados.fdTransacao.Commit;
            Result := true;
          end;
      end;
  except
    on e : exception do
      begin
        Result := false;
        TErro.Mostrar('Não foi possível excluir o Item do Pedido!'+#13+
        'Mensagem: '+e.Message);
        conexaoDados.fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroExcluirItemPedido.sql');
        conexaoDados.fdTransacao.Rollback;
      end;
  end;
end;

function TItemPedidoRepositorio.inserirItemPedido(
  _ItemPedido: TItemPedido): Boolean;
begin
  try
    Result := false;
    conexaoDados.fdComando.Close;
    if _ItemPedido.objetoValido(INCLUSAO) then
      begin
        with conexaoDados.fdComando.CommandText do
          begin
            Clear;
            AddStrings(_ItemPedido.getInsert);
          end;

        if conexaoDados.fdComando.CommandText.Count > 0 then
          begin
            conexaoDados.fdTransacao.StartTransaction;
            conexaoDados.fdComando.Execute;
            conexaoDados.fdTransacao.Commit;
            Result := true;
          end;
      end;
  except
    on e : exception do
      begin
        Result := false;
        TErro.Mostrar('Não foi possível inserir os dados do Item do Pedido!'+#13+
        'Mensagem: '+e.Message);
        conexaoDados.fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroInserirItemPedido.sql');
        conexaoDados.fdTransacao.Rollback;
      end;
  end;
end;

function TItemPedidoRepositorio.listar(condicoes: TCriterio): TDataSet;
var
  fdQry : TFDQuery;
begin
  try
    fdQry := TFDQuery.Create(nil);
    fdQry.Connection := conexaoDados.fdConexao;

    Result := fdQry;

    with fdQry do
      begin
        Close;
        Sql.Clear;
        Sql.Add('select itempedido.codigo, itempedido.produto_codigo, produto.nome, produto.valor_venda, itempedido.quantidade,');
        Sql.Add('itempedido.valor_unitario, itempedido.valor_total, itempedido.data_cadastro,');
        Sql.Add('itempedido.data_entrega,');
        Sql.Add('(case when itempedido.data_entrega is null then ''Pendente'' else ''Entregue'' end) as situacao_item');

        Sql.Add('from itempedido inner join produto on itempedido.produto_codigo = produto.codigo');

        Sql.AddStrings(condicoes.getCriterios);

        Sql.Add('group by pedido.codigo, pedido.cliente_codigo, cliente.nome, cliente.cidade, cliente.uf,');
        Sql.Add('pedido.data_criacao, pedido.data_fechamento, pedido.vlr_total');

        Sql.Add('order by 10');
        Open;
      end;
  except
    on e : exception do
      begin
        Result := TDataSet.Create(nil);
        TErro.Mostrar('Não foi possível listar os Pedidos!'+#13+
        'Mensagem: '+e.Message);
        if Assigned(fdQry) then
          begin
            fdQry.SQL.SaveToFile(TFuncoes.LocalApp+'ErroConsultaPedido.sql');
            fdQry.Close;
          end;
      end;

  end;

end;

{ TItemPedido }

constructor TItemPedido.Criar;
begin
  inherited Create;

  Self.Codigo := -1;
  Self.Pedido_Codigo := -1;
  Self.Produto_Codigo := -1;
  Self.Data_Criacao := 0;
  Self.Data_Entrega := 0;
  Self.Quantidade := 0;
  Self.Valor_Unitario := 0;
  Self.Valor_Total := 0;
end;

function TItemPedido.getInsert: TStringLIst;
begin
  try
    Result := TStringList.Create;
    Result.Clear;
    with Result do
      begin
        Add('INSERT INTO itempedido (pedido_codigo, produto_codigo, data_criacao, quantidade, valor_unitario, valor_total)');
        Add('VALUES(');
        Add(Self.Pedido_Codigo.ToString);
        Add(','+Self.Produto_Codigo.ToString);

        if Self.Data_Criacao <> 0 then
          Add(','+FormatDateTime('yyyy-mm-dd hh:mm:ss',Self.Data_Criacao).QuotedString)
        else
          Add(', CURRENT_TIMESTAMP');

        Add(', '+FormatFloat('#0.00',Self.Quantidade).Replace(',','.').QuotedString);
        Add(', '+FormatFloat('#0.00',Self.Valor_Unitario).Replace(',','.').QuotedString);
        Add(', '+FormatFloat('#0.00',Self.Valor_Total).Replace(',','.').QuotedString);
        Add(');');
      end;
  except
    on e : Exception do
      begin
        TErro.Mostrar('Não foi possível montar o comando para Inserir o Pedido: "'+
        Self.Codigo.ToString+'"'+#13+
        'Mensagem: '+e.Message);

        if Assigned(Result) then
          begin
            Result.SaveToFile(TFuncoes.LocalApp+'ErroMontarInsertItemPedido.sql');
            Result.Clear;
          end;
      end;
  end;
end;

function TItemPedido.getUpdate: TStringList;
begin
  try
    Result := TStringList.Create;
    Result.Clear;
    with Result do
      begin
        Add('UPDATE itempedido SET');
        Add('pedido_codigo = '+Self.Pedido_Codigo.ToString);
        Add(', produto_codigo = '+Self.Produto_Codigo.ToString);

        if Self.Data_Criacao <> 0 then
          Add(', data_criacao = '+FormatDateTime('yyyy-mm-dd hh:mm:ss',Self.Data_Criacao).QuotedString);

        if Self.Data_Entrega <> 0 then
          Add(', data_entrega = '+FormatDateTime('yyyy-mm-dd hh:mm:ss',Self.Data_Entrega).QuotedString);

        Add(', quantidade = '+FormatFloat('#0.00',Self.Quantidade).Replace(',','.').QuotedString);
        Add(', valor_unitario = '+FormatFloat('#0.00',Self.Valor_Unitario).Replace(',','.').QuotedString);
        Add(', valor_total = '+FormatFloat('#0.00',Self.Valor_Total).Replace(',','.').QuotedString);
        Add('WHERE codigo = '+Self.Codigo.ToString+';');
      end;
  except
    on e : Exception do
      begin
        TErro.Mostrar('Não foi possível montar o comando para atualizar o Item do Pedido: "'+
        Self.Codigo.ToString+'"'+#13+
        'Mensagem: '+e.Message);

        if Assigned(Result) then
          begin
            Result.SaveToFile(TFuncoes.LocalApp+'ErroMontarUpdateItemPedido.sql');
            Result.Clear;
          end;
      end;
  end;
end;

function TItemPedido.objetoValido(validando: String): Boolean;
begin
  Result := true;
  if (validando = ATUALIZACAO) or (validando = EXCLUSAO) then
    begin
      if Self.Codigo < 1 then
        begin
          TErro.Mostrar('Código de Item inválido!');
          Result := false;
          exit;
        end;
    end;

  if (validando = INCLUSAO) or (validando = ATUALIZACAO) then
    begin
      if Self.Pedido_Codigo < 1 then
        begin
          TErro.Mostrar('Código de Pedido inválido!');
          Result := false;
          exit;
        end;

      if Self.Produto_Codigo < 1 then
        begin
          TErro.Mostrar('Código de Produto inválido!');
          Result := false;
          exit;
        end;

      if Self.Quantidade <= 0 then
        begin
          TErro.Mostrar('Quantidade deve ser maior que 0!');
          Result := false;
          exit;
        end;

      if Self.Valor_Unitario <= 0 then
        begin
          TErro.Mostrar('Valor Unitário deve ser maior que 0!');
          Result := false;
          exit;
        end;

      if Self.Valor_Total <= 0 then
        begin
          TErro.Mostrar('Valor Total deve ser maior que 0!');
          Result := false;
          exit;
        end;

    end;

end;

end.
