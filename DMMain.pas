unit DMMain;

interface

uses
  System.SysUtils, System.Classes, Utilitario, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.VCLUI.Wait, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, Data.DB,
  FireDAC.Comp.Client, Vcl.Dialogs, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, Produto, FireDAC.DApt, FireDAC.Comp.UI;

type
  TconexaoDados = class(TDataModule)
    fdManager: TFDManager;
    fdConexao: TFDConnection;
    linkMySQL: TFDPhysMySQLDriverLink;
    fdComando: TFDCommand;
    fdTransacao: TFDTransaction;
    fdCursor: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Config_Banco : TConfig_Banco;

    function ConectarBanco(banco : String = '') : Boolean;
    function CriarBanco : Boolean;
    function CriarTabelas : Boolean;

    function CriarTabelaPedido : Boolean;
    function CriarTabelaCliente : Boolean;
    function CriarTabelaProduto : Boolean;
    function CriarTableaItemPedido : Boolean;
  public
    { Public declarations }
    StatusConexao : String;

    function TestarConexao(teste : TConfig_Banco) : Boolean;
    function Reconectar(novaConfig : TConfig_Banco) : Boolean;
  end;

var
  conexaoDados: TconexaoDados;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

uses Cliente;

{$R *.dfm}

function TconexaoDados.ConectarBanco(banco : String) : Boolean;
begin
  try
    with fdConexao do
      begin
        Close;
        Params.Clear;
        Params.Add('DriverID=MySQL');
        if not banco.IsEmpty then
          begin
            Params.Add('Database='+Config_Banco.NomeBanco);
          end
        else
          begin
            Params.Add('Database=sys');
          end;
        Params.Add('Server='+Config_Banco.NomeHost);
        Params.Add('Port='+Config_Banco.Porta.ToString);
        Params.Add('User_Name='+Config_Banco.NomeUsuario);
        Params.Add('Password='+Config_Banco.SenhaUsuario);
        Connected := true;
        Result := Connected;
      end;
  except
    on e : exception do
      begin
        Result := false;
        if e.Message.Contains('pedidos') then
          begin
            if CriarBanco then
              begin
                Result := CriarTabelas;
              end
            else
              begin
                Result := false;
              end;
          end;
      end;
  end;
end;

function TconexaoDados.CriarBanco: Boolean;
begin
  Result := false;
  if ConectarBanco then
    begin
      try
        with fdComando do
          begin
            Close;
            SchemaName := 'sys';
            CommandText.Clear;
            CommandText.Add('CREATE DATABASE IF NOT EXISTS `'+Self.Config_Banco.NomeBanco
              +'` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;');
            Execute;
          end;

        Result := CriarTabelas;
      except
        on e : exception do
          begin
            ShowMessage('Nâo foi possível configurar o Banco: "'+Self.Config_Banco.NomeBanco+'".'+#13+
            'Mensagem: '+e.Message);
            Result := false;
          end;
      end;
    end;
end;

function TconexaoDados.CriarTabelaCliente: Boolean;
var
  faker : TFaker;
  cliente : TCliente;
  I : Integer;
begin
  try
    faker := TFaker.Criar;
    with fdComando do
      begin
        Close;
        CommandText.Clear;
        SchemaName := Self.Config_Banco.NomeBanco;
        CommandText.Add('CREATE TABLE IF NOT EXISTS '+Self.Config_Banco.NomeBanco+'.cliente (');
        CommandText.Add('	codigo BIGINT auto_increment NOT NULL,');
        CommandText.Add('	nome varchar(200) NOT NULL,');
        CommandText.Add('	cidade varchar(50) NOT NULL,');
        CommandText.Add('	uf varchar(2) NOT NULL,');
        CommandText.Add('	CONSTRAINT cliente_pk PRIMARY KEY (codigo)');
        CommandText.Add(')');
        CommandText.Add('ENGINE=InnoDB');
        CommandText.Add('DEFAULT CHARSET=utf8mb4');
        CommandText.Add('COLLATE=utf8mb4_general_ci;');

        CommandText.Add('INSERT INTO '+Self.Config_Banco.NomeBanco+'.cliente (nome, cidade, uf) values');
        for I := 0 to (faker.Clientes.Count - 1) do
          begin
            cliente := faker.Clientes.Items[I];
            if I = (faker.Clientes.Count - 1) then
              begin
                CommandText.Add('('+cliente.Nome.QuotedString+','+
                cliente.Cidade.QuotedString+','+
                cliente.UF.QuotedString+');');
              end
            else
              begin
                CommandText.Add('('+cliente.Nome.QuotedString+','+
                cliente.Cidade.QuotedString+','+
                cliente.UF.QuotedString+'),');
              end;
          end;

        Execute;
        Result := true;
      end;
  except
    on e : exception do
      begin
        Result := false;
        ShowMessage('Não foi possível configurar a tabela "Cliente".'+#13+
        'Mensagem: '+e.Message);
        fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroConfigCliente_'+
        FormatDateTime('dd-mm-yyyy hh-mm',now)+'.sql');
      end;
  end;
end;

function TconexaoDados.CriarTabelaPedido: Boolean;
begin
  try
    with fdComando do
      begin
        Close;
        CommandText.Clear;
        SchemaName := Self.Config_Banco.NomeBanco;
        CommandText.Add('CREATE TABLE IF NOT EXISTS '+Self.Config_Banco.NomeBanco+'.pedido (');
        CommandText.Add('	codigo BIGINT auto_increment NOT NULL,');
        CommandText.Add('	cliente_codigo BIGINT NOT NULL,');
        CommandText.Add('	data_criacao TIMESTAMP DEFAULT now() NOT NULL,');
        CommandText.Add('	data_fechamento TIMESTAMP NULL,');
        CommandText.Add('	vlr_total DOUBLE DEFAULT 0 NULL,');
        CommandText.Add('	CONSTRAINT pedido_pk PRIMARY KEY (codigo),');
        CommandText.Add('	CONSTRAINT pedido_fk FOREIGN KEY (cliente_codigo) REFERENCES pedidos.cliente(codigo)');
        CommandText.Add(')');
        CommandText.Add('ENGINE=InnoDB');
        CommandText.Add('DEFAULT CHARSET=utf8mb4');
        CommandText.Add('COLLATE=utf8mb4_general_ci;');

        Execute;
        Result := true;
      end;
  except
    on e : exception do
      begin
        Result := false;
        ShowMessage('Não foi possível configurar a tabela "Pedido".'+#13+
        'Mensagem: '+e.Message);
        fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroConfigPedido_'+
        FormatDateTime('dd-mm-yyyy hh-mm',now)+'.sql');
      end;
  end;
end;

function TconexaoDados.CriarTabelaProduto: Boolean;
var
  faker : TFaker;
  produto : TProduto;
  I : Integer;
begin
  try
    faker := TFaker.Criar;
    with fdComando do
      begin
        Close;
        CommandText.Clear;
        SchemaName := Self.Config_Banco.NomeBanco;
        CommandText.Add('CREATE TABLE IF NOT EXISTS '+Self.Config_Banco.NomeBanco+'.produto (');
        CommandText.Add('  codigo bigint(20) NOT NULL AUTO_INCREMENT,');
        CommandText.Add('  nome varchar(150) NOT NULL,');
        CommandText.Add('  valor_venda double NOT NULL DEFAULT ''0'',');
        CommandText.Add('  PRIMARY KEY (codigo)');
        CommandText.Add(') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
        CommandText.Add('COLLATE=utf8mb4_general_ci;');

        CommandText.Add('INSERT INTO '+Self.Config_Banco.NomeBanco+'.produto (nome, valor_venda) values');
        for I := 0 to (faker.Produtos.Count - 1) do
          begin
            produto := faker.Produtos.Items[I];
            if I = (faker.Produtos.Count - 1) then
              begin
                CommandText.Add('('+produto.Nome.QuotedString+','+
                produto.ValorParaBanco.QuotedString+');');
              end
            else
              begin
                CommandText.Add('('+produto.Nome.QuotedString+','+
                produto.ValorParaBanco.QuotedString+'),');
              end;
          end;

        Execute;
        Result := true;
      end;
  except
    on e : exception do
      begin
        Result := false;
        ShowMessage('Não foi possível configurar a tabela "Produto".'+#13+
        'Mensagem: '+e.Message);
        fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroConfigProduto_'+
        FormatDateTime('dd-mm-yyyy hh-mm',now)+'.sql');
      end;

  end;
end;

function TconexaoDados.CriarTabelas: Boolean;
var
  continuar : Boolean;
begin
  try
    Result := false;
    continuar := CriarTabelaCliente and CriarTabelaProduto;
    if continuar then
      continuar := CriarTabelaPedido;

    if continuar then
      continuar := CriarTableaItemPedido;

    if continuar then
      Result := ConectarBanco(Self.Config_Banco.NomeBanco);

  except
    on e : Exception do
      begin
        Result := false;
        ShowMessage('Não foi possível configurar as tabelas do banco de dados "'+Self.Config_Banco.NomeBanco+'".'+#13+
        'Mensagem: '+e.Message);
        fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroConfig_'+
        FormatDateTime('dd-mm-yyyy hh-mm',now)+'.sql');
      end;
  end;
end;

function TconexaoDados.CriarTableaItemPedido: Boolean;
begin
  try
    with fdComando do
      begin
        Close;
        CommandText.Clear;
        SchemaName := Self.Config_Banco.NomeBanco;
        CommandText.Add('CREATE TABLE IF NOT EXISTS '+Self.Config_Banco.NomeBanco+'.itempedido (');
        CommandText.Add('	codigo BIGINT auto_increment NOT NULL,');
        CommandText.Add('	pedido_codigo BIGINT NOT NULL,');
        CommandText.Add('	produto_codigo BIGINT NOT NULL,');
        CommandText.Add('	quantidade DOUBLE DEFAULT 1 NOT NULL,');
        CommandText.Add('	valor_unitario DOUBLE DEFAULT 0 NOT NULL,');
        CommandText.Add('	valor_total DOUBLE DEFAULT 0 NOT NULL,');
        CommandText.Add('	data_cadastro TIMESTAMP DEFAULT now() NOT NULL,');
        CommandText.Add('	data_entrega TIMESTAMP NULL,');
        CommandText.Add('	CONSTRAINT itempedido_pk PRIMARY KEY (codigo),');
        CommandText.Add('	CONSTRAINT itempedido_fk FOREIGN KEY (pedido_codigo) REFERENCES pedidos.pedido(codigo),');
        CommandText.Add('	CONSTRAINT itempedido_fk_1 FOREIGN KEY (produto_codigo) REFERENCES pedidos.produto(codigo)');
        CommandText.Add(')');
        CommandText.Add('ENGINE=InnoDB');
        CommandText.Add('DEFAULT CHARSET=utf8mb4');
        CommandText.Add('COLLATE=utf8mb4_general_ci;');

        Execute;
        Result := true;
      end;
  except
    on e : exception do
      begin
        Result := false;
        ShowMessage('Não foi possível configurar a tabela "ItemPedido".'+#13+
        'Mensagem: '+e.Message);
        fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroConfigPedido_'+
        FormatDateTime('dd-mm-yyyy hh-mm',now)+'.sql');
      end;
  end;
(*
*)
end;

procedure TconexaoDados.DataModuleCreate(Sender: TObject);
var
  _conectado : Boolean;
begin
  try
    StatusConexao := NAO_CONECTADO;
    Config_Banco := TConfig_Banco.Criar;
    linkMySQL.VendorLib := Config_Banco.LocalDriver+MYSQL_LIB;

    fdManager.Active := true;

    _conectado := ConectarBanco(DEFAULT_PROP_NOME_BANCO);
    if _conectado then
      begin
        StatusConexao := CONECTADO;
      end;

  finally
    FreeAndNil(Config_Banco);
  end;
end;

function TconexaoDados.Reconectar(novaConfig: TConfig_Banco): Boolean;
begin
  Self.Config_Banco.NomeBanco := novaConfig.NomeBanco;
  Self.Config_Banco.NomeUsuario := novaConfig.NomeUsuario;
  Self.Config_Banco.NomeHost := novaConfig.NomeHost;
  Self.Config_Banco.Porta  := novaConfig.Porta;

  Result := ConectarBanco(novaConfig.NomeBanco);
end;

function TconexaoDados.TestarConexao(teste: TConfig_Banco): Boolean;
var
  fdConexao_Teste : TFDConnection;
begin
  try
    fdConexao_Teste := TFDConnection.Create(Self);

    with fdConexao_Teste do
      begin
        Close;
        LoginPrompt := false;
        Params.Clear;
        Params.Add('DriverID=MySQL');
        Params.Add('Database='+teste.NomeBanco);
        Params.Add('Server='+teste.NomeHost);
        Params.Add('Port='+teste.Porta.ToString);
        Params.Add('User_Name='+teste.NomeUsuario);
        Params.Add('Password='+teste.SenhaUsuario);
        Connected := true;
        Result := Connected;

        Connected := false;
      end;


    FreeAndNil(fdConexao_Teste);
  except
    on e : exception do
      begin
        Result := false;
        TErro.Mostrar('Erro ao tentar conectar no banco com as configurações informadas.'+#13+
        'Mensagem: '+e.Message);
        FreeAndNil(fdConexao_Teste);
      end;
  end;
end;

end.
