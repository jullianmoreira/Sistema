{$M+}
{$TYPEINFO ON}
unit Pedido;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB, Utilitario, Tipos,
  FireDAC.Comp.Client, Vcl.Dialogs, IRepositorio;

const
  ENTIDADE = 'Pedido';


type
  {Objeto que representa a tabela "pedido" no banco de dados.
    Este objeto encapsula as funções de validação de dados básica e seus comandos:
    - Insert
    - Update
  }
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

      function ValorTotal_Banco : String;

      constructor Criar;
  end;

  {Repositório de acesso aos dados do Pedido
    Implementado com as funções básicas de listagem, inclusão, atualização e exclusão
  }
  TPedidoRepositorio = class(TInterfacedObject, TIRepositorio)
    public
      function nomeCampoConsulta : String;
      function nomeRepositorio : String;
      {Funções de Consulta}
      function listar(condicoes : TCriterio) : TDataSet;
      function listarPedidosComProdutos(condicoes : TCriterio) : TDataSet;

      {Bonus de conhecimento em SQL e JSON(Montagem manual)}
      function pedidosDashboard : TStringList;

      {Valida se o Pedido possui itens antes de sua exclusão
        Devido à normalização entre as tabelas, não é possível excluir um pedido
        caso o mesmo possua itens. (FK = onDelete(restrict))
      }
      function possuiItens(_Pedido : Integer) : Boolean;

      {Sempre que o repositório for chamado para processar o Pedido, as validações estarão
        ligadas diretamente ao Objeto(Entidade)
      }
      function inserirPedido(_Pedido : TPedido) : Boolean;
      function atualizarPedido(_Pedido : TPedido) : Boolean;
      function excluirPedido(_Pedido : TPedido) : Boolean;

  end;

  TPedidoController = class(TObject)
    private
      repositorio : TIRepositorio;
    public
      constructor Create;
      function listar(condicoes : TCriterio) : TDataSet;
      function salvar(Pedido : TPedido) : Boolean;
      function excluir(Pedido : TPedido) : Boolean;
  end;

implementation

{ TPedidoRepositorio }

uses DMMain;

function TPedidoRepositorio.atualizarPedido(_Pedido: TPedido): Boolean;
begin
  try
    Result := false;
    conexaoDados.fdComando.Close;
    if _Pedido.objetoValido(ATUALIZACAO) then
      begin
        with conexaoDados.fdComando.CommandText do
          begin
            Clear;
            AddStrings(_Pedido.getUpdate);
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
        TErro.Mostrar('Não foi possível atualizar os dados do Pedido!'+#13+
        'Mensagem: '+e.Message);
        conexaoDados.fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroAtualizarPedido.sql');
      end;
  end;
end;

function TPedidoRepositorio.excluirPedido(_Pedido: TPedido): Boolean;
begin
  try
    Result := false;
    conexaoDados.fdComando.Close;
    if _Pedido.objetoValido(EXCLUSAO) then
      begin
        with conexaoDados.fdComando.CommandText do
          begin
            Clear;
            if possuiItens(_Pedido.Codigo) then
              begin
                Add('delete from itempedido where pedido_codigo = '+_Pedido.Codigo.ToString+';');
              end;
            Add('delete from pedido where codigo = '+_Pedido.Codigo.ToString+';');
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
        TErro.Mostrar('Não foi possível excluir o Pedido!'+#13+
        'Mensagem: '+e.Message);
        conexaoDados.fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroExcluirPedido.sql');
      end;
  end;
end;

function TPedidoRepositorio.inserirPedido(_Pedido: TPedido): Boolean;
var
  fdQry : TFDQuery;
begin
  try
    Result := false;
    fdQry := TFDQuery.Create(nil);
    fdQry.Connection := conexaoDados.fdConexao;

    if _Pedido.objetoValido(INCLUSAO) then
      begin
        with fdQry.SQL do
          begin
            Clear;
            AddStrings(_Pedido.getInsert);
          end;

        if fdQry.SQL.Count > ZeroValue then
          begin
            fdQry.Active := true;
            if not fdQry.IsEmpty then
              begin
                _Pedido.Codigo := fdQry.FieldByName('IDPedido').AsInteger;
              end;

            Result := true;
          end;

        FreeAndNil(fdQry);
      end;
  except
    on e : exception do
      begin
        Result := false;
        TErro.Mostrar('Não foi possível inserir os dados do Pedido!'+#13+
        'Mensagem: '+e.Message);
        fdQry.SQL.SaveToFile(TFuncoes.LocalApp+'ErroInserirPedido.sql');
        FreeAndNil(fdQry);
      end;
  end;
end;

function TPedidoRepositorio.listar(condicoes: TCriterio): TDataSet;
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
        Sql.Add('select pedido.codigo, pedido.cliente_codigo, cliente.nome, cliente.cidade, cliente.uf,');
        Sql.Add('pedido.data_criacao, pedido.data_fechamento, pedido.vlr_total,');
        Sql.Add('count(itempedido.codigo) as qtdeitens,');
        Sql.Add('(case when pedido.data_fechamento is null then ''Em Aberto'' else ''Fechado'' end) as Situacao');

        Sql.Add('from pedido inner join cliente on pedido.cliente_codigo = cliente.codigo');
        Sql.Add('            left outer join itempedido on pedido.codigo = itempedido.pedido_codigo');

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

function TPedidoRepositorio.listarPedidosComProdutos(
  condicoes: TCriterio): TDataSet;
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
        Sql.Add('select pedido.codigo, pedido.cliente_codigo, cliente.nome, cliente.cidade, cliente.uf,');
        Sql.Add('pedido.data_criacao, pedido.data_fechamento, pedido.vlr_total,');
        Sql.Add('(case when pedido.data_fechamento is null then ''Em Aberto'' else ''Fechado'' end) as situacao,');
        Sql.Add('itempedido.produto_codigo, produto.nome, produto.valor_venda, itempedido.quantidade,');
        Sql.Add('itempedido.valor_unitario, itempedido.valor_total, itempedido.data_cadastro,');
        Sql.Add('itempedido.data_entrega,');
        Sql.Add('(case when itempedido.data_entrega is null then ''Pendente'' else ''Entregue'' end) as situacao_item');

        Sql.Add('from pedido inner join cliente on pedido.cliente_codigo = cliente.codigo');
        Sql.Add('            left outer join itempedido on pedido.codigo = itempedido.pedido_codigo');
        Sql.Add('            left outer join produto on itempedido.produto_codigo = produto.codigo');

        Sql.AddStrings(condicoes.getCriterios);

        Sql.Add('order by 9, 18');
        Open;
      end;
  except
    on e : exception do
      begin
        Result := TDataSet.Create(nil);
        ShowMessage('Não foi possível listar o Pedido com seus Itens!'+#13+
        'Mensagem: '+e.Message);
        if Assigned(fdQry) then
          begin
            fdQry.SQL.SaveToFile(TFuncoes.LocalApp+'ErroConsultaPedido.sql');
            fdQry.Close;
          end;
      end;

  end;
end;

function TPedidoRepositorio.nomeCampoConsulta: String;
begin
  Result := '';
end;

function TPedidoRepositorio.nomeRepositorio: String;
begin
  Result := ENTIDADE;
end;

function TPedidoRepositorio.pedidosDashboard: TStringList;
const
  PROP_LAYOUT = '"[CAMPO]":[VALOR]';
var
  fdQry : TFDQuery;
  campo : TField;
  icampo : Integer;
  prop : string;
begin
  try
    Result := TStringList.Create;
    Result.Clear;
    fdQry := TFDQuery.Create(nil);
    fdQry.Connection := conexaoDados.fdConexao;
    with fdQry do
      begin
        Close;
        Sql.Clear;
        Sql.Add('select 1 as ordem, ''ITENS NÃO ENTREGUES'' as visao, count(*) as qtde, coalesce(sum(i.valor_total),0.00) as valor');
        Sql.Add('from itempedido i inner join pedido p on i.pedido_codigo  = p.codigo');
        Sql.Add('where i.data_entrega is null');

        Sql.Add('union all');

        Sql.Add('select 3 as ordem, ''ITENS ENTREGUES'' as visao, count(*) as qtde, coalesce(sum(i.valor_total),0.00) as valor');
        Sql.Add('from itempedido i inner join pedido p on i.pedido_codigo  = p.codigo');
        Sql.Add('where i.data_entrega is not null');

        Sql.Add('union all');

        Sql.Add('select 2 as ordem, ''PEDIDOS CONCLUÍDOS'' as visao, count(*) as qtde, coalesce(sum(p.vlr_total),0.00) as valor');
        Sql.Add('from pedido p');
        Sql.Add('where p.data_fechamento is not null');

        Sql.Add('union all');

        Sql.Add('select 0 as ordem, ''PEDIDOS EM ANDAMENTO'' as visao, count(*) as qtde, coalesce(sum(p.vlr_total),0.00) as valor');
        Sql.Add('from pedido p');
        Sql.Add('where p.data_fechamento is null');

        Sql.Add('order by 1');
        Open;

        if isEmpty then
          begin
            Result.Add('{"dashboard":[]}');
          end
        else
          begin
            Result.Add('{"dashboard":[');
            First;
            while not Eof do
              begin
                Result.Add('{');
                for icampo := 0 to (FieldList.Count-1) do
                  begin
                    campo := Fields[icampo];
                    if campo.DataType = ftString then
                      begin
                        prop := PROP_LAYOUT.Replace('[CAMPO]',campo.FieldName).
                          Replace('[VALOR]','"'+campo.AsString+'"');
                      end
                    else if campo.DataType in [ftInteger,ftLargeint] then
                      begin
                        prop := PROP_LAYOUT.Replace('[CAMPO]',campo.FieldName).
                          Replace('[VALOR]',campo.AsString);
                      end
                    else if campo.DataType = ftFloat then
                      begin
                        prop := PROP_LAYOUT.Replace('[CAMPO]',campo.FieldName).
                          Replace('[VALOR]',FormatFloat('#0.00',campo.AsFloat).Replace(',','.'));
                      end;


                    if icampo < (FieldList.Count-1) then
                      begin
                        Result.Add(prop+',');
                      end
                    else
                      begin
                        Result.Add(prop);
                      end;

                  end;
                Next;
                if Eof then
                  Result.Add('}')
                else
                  Result.Add('},');
              end;
            Result.Add(']}');
          end;
      end;

      FreeAndNil(fdQry);
  except
    on e : exception do
      begin
        Result.Clear;
        Result.Add('{"dashboard":[]}');
        TErro.Mostrar('Não foi possível obter os dados para o Dashboard!'+#13+
        'Mensagem: '+e.Message);
        if Assigned(fdQry) then
          begin
            fdQry.SQL.SaveToFile(TFuncoes.LocalApp+'ErroConsulaDashboard.sql');
            FreeAndNil(fdQry);
          end;
      end;
  end;

end;

function TPedidoRepositorio.possuiItens(_Pedido: Integer): Boolean;
const
  CAMPO_CONS_LOCAL = 'qtde_itens';
var
  fdQry : TFDQuery;
begin
  try
    Result := false;
    fdQry := TFDQuery.Create(nil);
    fdQry.Connection := conexaoDados.fdConexao;
    with fdQry do
      begin
        Close;
        Sql.Clear;
        Sql.Add('select count(*) as '+CAMPO_CONS_LOCAL+' form itempedido');
        Sql.Add('where pedido_codigo = '+_Pedido.ToString);
        Open;

        if IsEmpty then
          begin
            Result := false;
          end
        else
          begin
            if FieldByName(CAMPO_CONS_LOCAL).AsInteger > ZeroValue then
              begin
                Result := true;
              end;
          end;
      end;
  except
    on e : exception do
      begin
        {Para essa validação, em caso de erro, força a exclusão de itens existentes
          antes de excluir o pedido.}
        Result := true;
        //

        TErro.Mostrar('Não foi possível verificar se o Pedido possui itens.'+#13+
        'Mensagem: '+e.Message);
        fdQry.SQL.SaveToFile(TFuncoes.LocalApp+'ErroVerificarItens.sql');
        FreeAndNil(fdQry);
      end;
  end;
end;

{ TPedido }

constructor TPedido.Criar;
begin
  inherited Create;

  Self.Codigo := SEM_REGISTRO;
  Self.Cliente_Codigo := SEM_REGISTRO;
  Self.Data_Criacao := ZeroValue;
  Self.Data_Fechamento := ZeroValue;
  Self.Valor_Total := ZeroValue;
end;

function TPedido.getInsert: TStringLIst;
begin
  try
    Result := TStringList.Create;
    Result.Clear;
    with Result do
      begin
        Add('INSERT INTO pedido (cliente_codigo, data_criacao, data_fechamento, vlr_total)');
        Add('VALUES(');
        Add(Self.Cliente_Codigo.ToString);

        if Self.Data_Criacao <> ZeroValue then
          Add(','+FormatDateTime(FORMAT_HORARIO_BANCO,Self.Data_Criacao).QuotedString)
        else
          Add(', CURRENT_TIMESTAMP');

        if Self.Data_Fechamento <> ZeroValue then
          Add(', '+FormatDateTime(FORMAT_HORARIO_BANCO,Self.Data_Criacao).QuotedString)
        else
          Add(', NULL');

        Add(', '+Self.ValorTotal_Banco);
        Add(');');
        Add('SELECT LAST_INSERT_ID() AS IDPedido;');
      end;
  except
    on e : Exception do
      begin
        TErro.Mostrar('Não foi possível montar o comando para Inserir o Pedido: "'+
        Self.Codigo.ToString+'"'+#13+
        'Mensagem: '+e.Message);

        if Assigned(Result) then
          begin
            Result.SaveToFile(TFuncoes.LocalApp+'ErroMontarInsertPedido.sql');
            Result.Clear;
          end;
      end;
  end;
end;

function TPedido.getUpdate: TStringList;
begin
  try
    Result := TStringList.Create;
    Result.Clear;
    with Result do
      begin
        Add('UPDATE pedido SET');
        Add('cliente_codigo = '+Self.Cliente_Codigo.ToString);

        if Self.Data_Criacao <> ZeroValue then
          Add(', data_criacao = '+FormatDateTime(FORMAT_HORARIO_BANCO,Self.Data_Criacao).QuotedString);

        if Self.Data_Fechamento <> ZeroValue then
          Add(', data_fechamento = '+FormatDateTime(FORMAT_HORARIO_BANCO,Self.Data_Fechamento).QuotedString);

        Add(', vlr_total = '+Self.ValorTotal_Banco);
        Add('WHERE codigo = '+Self.Codigo.ToString+';');
      end;
  except
    on e : Exception do
      begin
        TErro.Mostrar('Não foi possível montar o comando para atualizar o Pedido: "'+
        Self.Codigo.ToString+'"'+#13+
        'Mensagem: '+e.Message);

        if Assigned(Result) then
          begin
            Result.SaveToFile(TFuncoes.LocalApp+'ErroMontarUpdatePedido.sql');
            Result.Clear;
          end;
      end;
  end;
end;

function TPedido.objetoValido(validando : String): Boolean;
begin
  Result := true;
  if (validando = ATUALIZACAO) or (validando = EXCLUSAO) then
    begin
      if Self.Codigo < REGISTRO_VALIDO then
        begin
          TErro.Mostrar('Código de Pedido inválido!');
          Result := false;
          exit;
        end;
    end;

  if validando = INCLUSAO then
    begin
      if Self.Cliente_Codigo < REGISTRO_VALIDO then
        begin
          TErro.Mostrar('Código de Cliente inválido!');
          Result := false;
          exit;
        end;
    end;

end;

function TPedido.ValorTotal_Banco: String;
begin
  Result := FormatFloat(FORMAT_NUMERO_BANCO,Self.Valor_Total).Replace(',','.').QuotedString
end;

{ TPedidoController }

constructor TPedidoController.Create;
begin
  inherited Create;
  repositorio := TPedidoRepositorio.Create;
end;

function TPedidoController.excluir(Pedido: TPedido): Boolean;
begin

end;

function TPedidoController.listar(condicoes: TCriterio): TDataSet;
begin
  Result := repositorio.listar(condicoes);
end;

function TPedidoController.salvar(Pedido: TPedido): Boolean;
begin
  if Pedido.Codigo = SEM_REGISTRO then
    Result := TPedidoRepositorio(repositorio).inserirPedido(Pedido)
  else
    Result := TPedidoRepositorio(repositorio).atualizarPedido(Pedido);
end;

end.
