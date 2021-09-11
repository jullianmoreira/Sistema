unit UConfigurar_Conexao;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Utilitario;

type
  TformConfigurar_Conexao = class(TForm)
    pnBottom: TPanel;
    btFechar: TSpeedButton;
    btSalvar: TSpeedButton;
    btTestar_Conexao: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtHost: TEdit;
    edtBanco: TEdit;
    edtUsuario: TEdit;
    lblStatus_Conexao: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    edtPorta: TEdit;
    procedure btFecharClick(Sender: TObject);
    procedure btTestar_ConexaoClick(Sender: TObject);
    procedure btSalvarClick(Sender: TObject);
  private
    { Private declarations }
    configBanco : TConfig_Banco;
    procedure checarConexao;
    procedure pegar_dos_edits;

    function testarConexao : Boolean;
  public
    { Public declarations }
    constructor Criar;
  end;

var
  formConfigurar_Conexao: TformConfigurar_Conexao;

implementation

{$R *.dfm}

uses DMMain;

{ TformConfigurar_Conexao }

procedure TformConfigurar_Conexao.btFecharClick(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TformConfigurar_Conexao.btSalvarClick(Sender: TObject);
begin
  btSalvar.Enabled := false;
  pegar_dos_edits;
  if testarConexao then
    begin
      configBanco.Salvar;
      ModalResult := mrOK;
    end
  else
    begin
      ShowMessage('As configurações informadas não são válidas.');
    end;
  btSalvar.Enabled := true;
end;

procedure TformConfigurar_Conexao.btTestar_ConexaoClick(Sender: TObject);
begin
  if testarConexao then
    begin
      ShowMessage('Conectado com sucesso!');
    end;
end;

procedure TformConfigurar_Conexao.checarConexao;
begin
  if conexaoDados.StatusConexao = CONECTADO then
    begin
      lblStatus_Conexao.Caption := CONECTADO;
      lblStatus_Conexao.Font.Color := clGreen;
    end
  else
    begin
      lblStatus_Conexao.Caption := NAO_CONECTADO;
      lblStatus_Conexao.Font.Color := clRed;
    end;
end;

constructor TformConfigurar_Conexao.Criar;
begin
  inherited Create(Application);

  configBanco := TConfig_Banco.Criar;

  edtHost.Text := configBanco.NomeHost;
  edtBanco.Text := configBanco.NomeBanco;
  edtUsuario.Text := configBanco.NomeUsuario;
  edtPorta.Text := configBanco.Porta.ToString;

  checarConexao;

  Self.ShowModal;
end;

procedure TformConfigurar_Conexao.pegar_dos_edits;
begin
  configBanco.NomeBanco := edtBanco.Text;
  configBanco.NomeUsuario := edtUsuario.Text;
  configBanco.NomeHost := edtHost.Text;
  configBanco.Porta := StrToInt(edtPorta.Text);
end;

function TformConfigurar_Conexao.testarConexao: Boolean;
begin
  pegar_dos_edits;
  Result := conexaoDados.TestarConexao(configBanco);
end;

end.
