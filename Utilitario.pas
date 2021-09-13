{$M+}
{$TYPEINFO ON}
unit Utilitario;

interface
  uses System.Classes, System.StrUtils, System.Math, System.SysUtils, System.IniFiles,
  Winapi.Windows, Vcl.Forms, Generics.Collections,

  //Entidades
  Cliente, Produto;

const
  INI_FILE = '\Pedidos.ini';
  DB_CONFIG = 'DB_CONFIG';
  PROP_NOME_BANCO = 'NOME_BANCO';
  PROP_NOME_USUARIO = 'NOME_USUARIO';
  PROP_NOME_HOST = 'NOME_HOST';
  PROP_PORTA = 'PORTA';
  PROP_LOCAL_DRIVER = 'LOCAL_DRIVER';
  DEFAULT_PROP_NOME_BANCO = 'pedidos';
  DEFAULT_PROP_NOME_USUARIO = 'root';
  DEFAULT_PROP_NOME_HOST = 'localhost';
  DEFAULT_PROP_PORTA = 3306;

  INCLUSAO = 'INCLUSAO';
  ATUALIZACAO = 'ATUALIZACAO';
  EXCLUSAO = 'EXCLUSAO';

  PEDIDO_EM_ANDAMENTO = 0;
  ITENS_NAO_ENTREGUES = 1;
  PEDIDOS_CONCLUIDOS = 2;
  ITENS_ENTREGUES = 3;

  CONECTADO = 'CONECTADO';
  NAO_CONECTADO = 'NÃO CONECTADO';

  SENHA_BANCO = 'passwd';

  MYSQL_LIB = 'libmysql.dll';

type


  TFaker = class(TObject)
    private
      FClientes: TList<TCliente>;
      FProdutos: TList<TProduto>;
      procedure AddClientes;
      procedure AddProdutos;
    published
      property Clientes: TList<TCliente> read FClientes write FClientes;
      property Produtos: TList<TProduto> read FProdutos write FProdutos;
    public
      constructor Criar;

  end;

  TFuncoes = class(TObject)
    public
      class function LocalApp(dobrarBarras : Boolean = false) : String;
  end;

  TErro = class(TObject)
    public
      class procedure Mostrar(mensagem : String);
  end;


  TConfig_Banco = class(TObject)
  private
    FNomeBanco: String;
    FNomeUsuario: String;
    FNomeHost: String;
    FSenhaUsuario: string;
    FPorta: Integer;
    FLocalDriver: String;

    procedure InicializarDriver(local : String);
  public
    constructor Criar;
    procedure Salvar;
  published
    property NomeBanco: String read FNomeBanco write FNomeBanco;
    property NomeUsuario: String read FNomeUsuario write FNomeUsuario;
    property NomeHost: String read FNomeHost write FNomeHost;
    property Porta: Integer read FPorta write FPorta;
    property SenhaUsuario: string read FSenhaUsuario write FSenhaUsuario;
    property LocalDriver: String read FLocalDriver write FLocalDriver;

  end;

implementation

uses
  Vcl.Dialogs;

{ TConfig_Banco }

constructor TConfig_Banco.Criar;
var
  iniFile : TIniFile;
  LocalApp, LocalIni, _LocalDriver : String;
begin
  inherited Create;
  LocalApp := TFuncoes.LocalApp;
  LocalIni := LocalApp+'\'+INI_FILE;
  _LocalDriver := LocalApp;
  try
    if FileExists(LocalIni) then
      begin
        iniFile := TIniFile.Create(LocalIni);

        Self.NomeBanco := iniFile.ReadString(DB_CONFIG, PROP_NOME_BANCO, DEFAULT_PROP_NOME_BANCO);
        Self.NomeUsuario := iniFile.ReadString(DB_CONFIG, PROP_NOME_USUARIO, DEFAULT_PROP_NOME_USUARIO);
        Self.NomeHost := iniFile.ReadString(DB_CONFIG, PROP_NOME_HOST, DEFAULT_PROP_NOME_HOST);
        Self.Porta := iniFile.ReadInteger(DB_CONFIG, PROP_PORTA, DEFAULT_PROP_PORTA);
        Self.LocalDriver := _LocalDriver;
        InicializarDriver(Self.LocalDriver);
        Self.SenhaUsuario := SENHA_BANCO;
      end
    else
      begin
        iniFile := TIniFile.Create(LocalIni);

        iniFile.WriteString(DB_CONFIG, PROP_NOME_BANCO, DEFAULT_PROP_NOME_BANCO);
        iniFile.WriteString(DB_CONFIG, PROP_NOME_USUARIO, DEFAULT_PROP_NOME_USUARIO);
        iniFile.WriteString(DB_CONFIG, PROP_NOME_HOST, DEFAULT_PROP_NOME_HOST);
        iniFile.WriteInteger(DB_CONFIG, PROP_PORTA, DEFAULT_PROP_PORTA);

        Self.NomeBanco := DEFAULT_PROP_NOME_BANCO;
        Self.NomeUsuario := DEFAULT_PROP_NOME_USUARIO;
        Self.NomeHost := DEFAULT_PROP_NOME_HOST;
        Self.Porta := DEFAULT_PROP_PORTA;
        Self.LocalDriver := _LocalDriver;
        InicializarDriver(Self.LocalDriver);

        Self.SenhaUsuario := SENHA_BANCO;

        iniFile.Free;
      end;
  except
    on e : exception do
      begin
        TErro.Mostrar(e.Message);
      end;
  end;

end;

procedure TConfig_Banco.InicializarDriver(local: String);
var
  localArquivo : String;
  arquivo_lib : TFileStream;
  resource_manager : TResourceStream;
begin
  try
    localArquivo := local+MYSQL_LIB;
    if not DirectoryExists(local) then
      begin
        if CreateDir(local) then
          begin
            resource_manager := TResourceStream.Create(HInstance, 'MYSQL_DRIVER', RT_RCDATA);

            arquivo_lib := TFileStream.Create(localArquivo,fmCreate);

            resource_manager.SaveToStream(arquivo_lib);

            arquivo_lib.Free;
            resource_manager.Free;
          end
        else raise Exception.Create('Não foi possível configurar o Driver em: "'+localArquivo+'"');
      end
    else
      begin
        if not FileExists(localArquivo) then
          begin
            resource_manager := TResourceStream.Create(HInstance, 'MYSQL_DRIVER', RT_RCDATA);

            arquivo_lib := TFileStream.Create(localArquivo,fmCreate);

            resource_manager.SaveToStream(arquivo_lib);

            arquivo_lib.Free;
            resource_manager.Free;
          end;
      end;
  except
    on e : Exception do
      begin
        TErro.Mostrar(e.Message);
      end;
  end;
end;

procedure TConfig_Banco.Salvar;
var
  iniFile : TIniFile;
  LocalApp, LocalIni, _LocalDriver : String;
begin
  inherited Create;
  LocalApp := TFuncoes.LocalApp;
  LocalIni := LocalApp+'\'+INI_FILE;
  _LocalDriver := LocalApp;
  try
    if FileExists(LocalIni) then
      begin
        iniFile := TIniFile.Create(LocalIni);

        iniFile.WriteString(DB_CONFIG, PROP_NOME_BANCO, DEFAULT_PROP_NOME_BANCO);
        iniFile.WriteString(DB_CONFIG, PROP_NOME_USUARIO, DEFAULT_PROP_NOME_USUARIO);
        iniFile.WriteString(DB_CONFIG, PROP_NOME_HOST, DEFAULT_PROP_NOME_HOST);
        iniFile.WriteInteger(DB_CONFIG, PROP_PORTA, DEFAULT_PROP_PORTA);

        Self.LocalDriver := _LocalDriver;
        InicializarDriver(Self.LocalDriver);

        Self.SenhaUsuario := SENHA_BANCO;

        iniFile.Free;
      end;
  except
    on e : exception do
      begin
        TErro.Mostrar(e.Message);
      end;
  end;

end;

{ TErro }

class procedure TErro.Mostrar(mensagem: String);
begin
  ShowMessage(mensagem);
end;

{ TFuncoes }

class function TFuncoes.LocalApp(dobrarBarras : Boolean): String;
const
  BARRA = '\';
var
  local : String;
begin
  local := ExtractFileDir(Application.ExeName);
  if dobrarBarras then
    begin
      Result := (local+BARRA).Replace(BARRA,(BARRA+BARRA));
    end
  else
    begin
      Result := (local+BARRA);
    end;
end;

{ TFaker }

procedure TFaker.AddClientes;
begin
  try
    Self.Clientes := TList<TCliente>.Create;

    (*Chamda de método Criar encapsulada para reduzir quantidade de linhas de código
      Esse tipo de chamada também facilita o gerenciamento de memória já que somente ficarão
      alocados na memória referenciando à lista criada e não à variáveis locais da função via pointer.*)
    Self.Clientes.Add(
      TCliente.Criar(-1, 'JOÃO DOS SANTOS', 'IPATINGA', 'MG')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'MARIA DA SILVA', 'SÃO PAULO', 'SP')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'ANTÔNIO DA SILVA', 'CORITIBA', 'PR')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'MARIA ABADIA', 'ILHEUS', 'BA')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'DELICIA MINEIRA', 'MACAPA', 'AP')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'CARLOS ALBERTO', 'BRASILIA', 'DF')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'MARCOS MORELLO', 'UBERLANDIA', 'MG')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'MIRANDA DA SILVA', 'BOITUVA', 'SP')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'MARLEI DOS SANTOS', 'BELO HORIZONTE', 'MG')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'SALVIO ABADIO', 'MONTE CARMELO', 'MG')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'JOANA SOARES COSTA', 'ARAGUARI', 'MG')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'JULLIAN MOREIRA', 'GOIÂNIA', 'GO')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'RHEYLA MOREIRA', 'ITUMBIARA', 'GO')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'ABADIO DE JESUS', 'FRUTAL', 'MG')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'JESUS DOS SANTOS', 'SÃO CARLOS', 'SP')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'CARME LUCIA BARROSO', 'ITU', 'SP')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'DOUGLAS ROBERTO', 'PASSO FUNDO', 'RS')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'ROSEMEIRE AUGUSTA', 'NATAL', 'RN')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'HELENA BRANDÃO', 'VITÓRIA', 'ES')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'NAYARA MARIA', 'RIO DE JANEIRO', 'RJ')
    );

    Self.Clientes.Add(
      TCliente.Criar(-1, 'ANDRÉIA NASCIMENTO', 'FRANCA', 'SP')
    );


  except
    on e : exception do
      begin
        ShowMessage('Não foi possível criar os clientes fakes.'+#13+
        'Mensagem: '+e.Message);
      end;
  end;

end;

procedure TFaker.AddProdutos;
begin
  try
    Self.Produtos := TList<TProduto>.Create;

    Self.Produtos.Add(
      TProduto.Criar(-1, 'BALINHA MENTA', 1.25)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'COCA-COLA 2L', 3.25)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'ÁGUA 500ML - SEM GÁS', 1.8)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'ÁGUA 500ML - COM GÁS', 10.69)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'SABÃO EM PÓ 20KG', 80.98)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'MOUSE', 5.98)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'TECLADO', 7.98)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'BOMBOM SONHO DE VALSA', 0.98)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'RODO POLITRIZ 40CM', 9.99)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'CARNE BOVINA - ACÉM - PCT 1KG', 6.87)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'CARNE BOVINA - CONTRA FILÉ - PCT 1KG', 8.98)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'CARNE SUÍNA - PERNIL - PCT 1KG', 25.98)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'CARNE BOVINA - LOMBO - PCT 1KG', 28.97)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'MANDIOCA DA ROÇA CX', 37.91)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'TOMATE CX', 97.64)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'ABOBRINHA MENINA KG', 11.98)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'LARANJA GRAÚDA KG', 9.65)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'MELANCIA PC', 3.65)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'PICOLÉ DE FRUTA', 4.87)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'PICOLÉ DE LEITE', 1.98)
    );

    Self.Produtos.Add(
      TProduto.Criar(-1, 'CERVEJA SKOL CX12', 9.74)
    );


  except
    on e : exception do
      begin
        ShowMessage('Não foi possível criar os clientes fakes.'+#13+
        'Mensagem: '+e.Message);
      end;
  end;
end;

constructor TFaker.Criar;
begin
  inherited Create;

  AddClientes;
  AddProdutos
end;



end.
