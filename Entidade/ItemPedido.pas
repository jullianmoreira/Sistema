{$M+}
{$TYPEINFO ON}
unit ItemPedido;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB, Utilitario, Tipos,
  FireDAC.Comp.Client, IRepositorio;

const
  ENTIDADE = 'Item do Pedido';

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
    function quantidade_Banco : String;
    function valor_unitario_Banco : String;
    function valor_total_Banco : String;

    constructor Criar;
  end;

  TItemPedidoRepositorio = class(TInterfacedObject, TIRepositorio)
    public
      function nomeCampoConsulta : String;
      function nomeRepositorio : String;
      function listar(condicoes : TCriterio) : TDataSet;

      function inserirItemPedido(_ItemPedido : TItemPedido) : Boolean;
      function atualizarItemPedido(_ItemPedido : TItemPedido) : Boolean;
      function excluirItemPedido(_ItemPedido : TItemPedido) : Boolean;
  end;

  TItemPedidoController = class(TObject)
    private
      repositorio : TIRepositorio;
    public
      constructor Create;
      function listar(condicoes : TCriterio) : TDataSet;
      function salvar(item : TItemPedido) : Boolean;
      function excluir(item : TItemPedido) : Boolean;
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
            conexaoDados.fdComando.Execute;
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
            conexaoDados.fdComando.Execute;
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
            conexaoDados.fdComando.Execute;
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

function TItemPedidoRepositorio.nomeCampoConsulta: String;
begin
  Result := '';
end;

function TItemPedidoRepositorio.nomeRepositorio: String;
begin
  Result := 'Item do Pedido';
end;

{ TItemPedido }

constructor TItemPedido.Criar;
begin
  inherited Create;

  Self.Codigo := SEM_REGISTRO;
  Self.Pedido_Codigo := SEM_REGISTRO;
  Self.Produto_Codigo := SEM_REGISTRO;
  Self.Data_Criacao := ZeroValue;
  Self.Data_Entrega := ZeroValue;
  Self.Quantidade := ZeroValue;
  Self.Valor_Unitario := ZeroValue;
  Self.Valor_Total := ZeroValue;
end;

function TItemPedido.getInsert: TStringLIst;
begin
  try
    Result := TStringList.Create;
    Result.Clear;
    with Result do
      begin
        Add('INSERT INTO itempedido (pedido_codigo, produto_codigo, data_cadastro, quantidade, valor_unitario, valor_total)');
        Add('VALUES(');
        Add(Self.Pedido_Codigo.ToString);
        Add(','+Self.Produto_Codigo.ToString);

        if Self.Data_Criacao <> 0 then
          Add(','+FormatDateTime(FORMAT_HORARIO_BANCO,Self.Data_Criacao).QuotedString)
        else
          Add(', CURRENT_TIMESTAMP');

        Add(', '+Self.quantidade_Banco);
        Add(', '+Self.valor_unitario_Banco);
        Add(', '+Self.valor_total_Banco);
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

        if Self.Data_Criacao <> ZeroValue then
          Add(', data_criacao = '+FormatDateTime(FORMAT_HORARIO_BANCO,Self.Data_Criacao).QuotedString);

        if Self.Data_Entrega <> ZeroValue then
          Add(', data_entrega = '+FormatDateTime(FORMAT_HORARIO_BANCO,Self.Data_Entrega).QuotedString);

        Add(', quantidade = '+Self.quantidade_Banco);
        Add(', valor_unitario = '+self.valor_unitario_Banco);
        Add(', valor_total = '+self.valor_total_Banco);
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
      if Self.Codigo < REGISTRO_VALIDO then
        begin
          TErro.Mostrar('Código de Item inválido!');
          Result := false;
          exit;
        end;
    end;

  if (validando = INCLUSAO) or (validando = ATUALIZACAO) then
    begin
      if Self.Pedido_Codigo < REGISTRO_VALIDO then
        begin
          TErro.Mostrar('Código de Pedido inválido!');
          Result := false;
          exit;
        end;

      if Self.Produto_Codigo < REGISTRO_VALIDO then
        begin
          TErro.Mostrar('Código de Produto inválido!');
          Result := false;
          exit;
        end;

      if Self.Quantidade <= ZeroValue then
        begin
          TErro.Mostrar('Quantidade deve ser maior que 0!');
          Result := false;
          exit;
        end;

      if Self.Valor_Unitario <= ZeroValue then
        begin
          TErro.Mostrar('Valor Unitário deve ser maior que 0!');
          Result := false;
          exit;
        end;

      if Self.Valor_Total <= ZeroValue then
        begin
          TErro.Mostrar('Valor Total deve ser maior que 0!');
          Result := false;
          exit;
        end;

    end;

end;

function TItemPedido.quantidade_Banco: String;
begin
  Result := FormatFloat(FORMAT_NUMERO_BANCO,Self.Quantidade).Replace(',','.').QuotedString;
end;

function TItemPedido.valor_total_Banco: String;
begin
  Result := FormatFloat(FORMAT_NUMERO_BANCO,Self.Valor_Total).Replace(',','.').QuotedString
end;

function TItemPedido.valor_unitario_Banco: String;
begin
  Result := FormatFloat(FORMAT_NUMERO_BANCO,Self.Valor_Unitario).Replace(',','.').QuotedString
end;

{ TItemPedidoController }

constructor TItemPedidoController.Create;
begin
  inherited Create;
end;

function TItemPedidoController.excluir(item: TItemPedido): Boolean;
begin
  if item.Codigo <> SEM_REGISTRO then
    begin
      Result := TItemPedidoRepositorio(repositorio).excluirItemPedido(item);
    end;
end;

function TItemPedidoController.listar(condicoes: TCriterio): TDataSet;
begin
  Result := repositorio.listar(condicoes);
end;

function TItemPedidoController.salvar(item: TItemPedido): Boolean;
begin
  if item.Codigo = SEM_REGISTRO then
    Result := TItemPedidoRepositorio(repositorio).inserirItemPedido(item)
  else
    Result := TItemPedidoRepositorio(repositorio).atualizarItemPedido(item);
end;

end.
