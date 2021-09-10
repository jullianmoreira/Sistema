unit DMMain;

interface

uses
  System.SysUtils, System.Classes, Utilitario, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Phys, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.VCLUI.Wait, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, Data.DB,
  FireDAC.Comp.Client, Vcl.Dialogs, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, Produto;

type
  TconexaoDados = class(TDataModule)
    fdManager: TFDManager;
    fdConexao: TFDConnection;
    linkMySQL: TFDPhysMySQLDriverLink;
    fdComando: TFDCommand;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    Config_Banco : TConfig_Banco;

    function ConectarBanco(banco : String = '') : Boolean;
    function CriarBanco : Boolean;
    function CriarTabelas : Boolean;
  public
    { Public declarations }
    StatusConexao : String;
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
            CommandText.Add('CREATE DATABASE IF NOT EXISTS `'+DEFAULT_PROP_NOME_BANCO
              +'` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;');
            Execute;
          end;

        Result := CriarTabelas;
      except
        on e : exception do
          begin
            ShowMessage('Nâo foi possível configurar o Banco: "pedidos".'+#13+
            'Mensagem: '+e.Message);
            Result := false;
          end;
      end;
    end;
end;

function TconexaoDados.CriarTabelas: Boolean;
var
  faker : TFaker;
  cliente : TCliente;
  produto : TProduto;

  I : Integer;
begin
  try
    with fdComando do
      begin
        faker := TFaker.Criar;

        Close;
        CommandText.Clear;
        SchemaName := DEFAULT_PROP_NOME_BANCO;
        CommandText.Add('CREATE TABLE IF NOT EXISTS '+DEFAULT_PROP_NOME_BANCO+'.cliente (');
        CommandText.Add('	codigo BIGINT auto_increment NOT NULL,');
        CommandText.Add('	nome varchar(200) NOT NULL,');
        CommandText.Add('	cidade varchar(50) NOT NULL,');
        CommandText.Add('	uf varchar(2) NOT NULL,');
        CommandText.Add('	CONSTRAINT cliente_pk PRIMARY KEY (codigo)');
        CommandText.Add(')');
        CommandText.Add('ENGINE=InnoDB');
        CommandText.Add('DEFAULT CHARSET=utf8mb4');
        CommandText.Add('COLLATE=utf8mb4_general_ci;');

        CommandText.Add('INSERT INTO '+DEFAULT_PROP_NOME_BANCO+'.cliente (nome, cidade, uf) values');
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

        CommandText.Add('CREATE TABLE IF NOT EXISTS '+DEFAULT_PROP_NOME_BANCO+'.produto (');
        CommandText.Add('  codigo bigint(20) NOT NULL AUTO_INCREMENT,');
        CommandText.Add('  nome varchar(150) NOT NULL,');
        CommandText.Add('  valor_venda double NOT NULL DEFAULT ''0'',');
        CommandText.Add('  PRIMARY KEY (codigo)');
        CommandText.Add(') ENGINE=InnoDB DEFAULT CHARSET=utf8mb4');
        CommandText.Add('COLLATE=utf8mb4_general_ci;');

        CommandText.Add('INSERT INTO '+DEFAULT_PROP_NOME_BANCO+'.produto (nome, valor_venda) values');
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
        Result := ConectarBanco(DEFAULT_PROP_NOME_BANCO);
      end;
  except
    on e : Exception do
      begin
        Result := false;
        ShowMessage('Não foi possível configurar as tabelas "Cliente" e "Produto".'+#13+
        'Mensagem: '+e.Message);
        fdComando.CommandText.SaveToFile(TFuncoes.LocalApp+'ErroConfig_'+
        FormatDateTime('dd-mm-yyyy hh-mm',now)+'.sql');
      end;
  end;
end;

procedure TconexaoDados.DataModuleCreate(Sender: TObject);
var
  conectado : Boolean;
begin
  try
    StatusConexao := 'NÃO CONECTADO';
    Config_Banco := TConfig_Banco.Criar;
    linkMySQL.VendorLib := Config_Banco.LocalDriver+MYSQL_LIB;

    fdManager.Active := true;

    conectado := ConectarBanco(DEFAULT_PROP_NOME_BANCO);
    if conectado then
      begin
        StatusConexao := 'CONECTADO';
      end;

  finally
    FreeAndNil(Config_Banco);
  end;
end;

end.
