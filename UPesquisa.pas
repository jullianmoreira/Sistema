unit UPesquisa;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.ExtCtrls, Vcl.StdCtrls, IRepositorio, Vcl.Buttons, Tipos;

type
  TConfigTela = class
    Repositorio : TIRepositorio;
    Colunas : TArray<TColumn>;
  end;

  TfrmPesquisa = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    edtNomeConsulta: TEdit;
    Panel1: TPanel;
    gridPesquisa: TDBGrid;
    lblRepositorio: TLabel;
    btSelecionar: TSpeedButton;
    btFechar: TSpeedButton;
    dsPesquisa: TDataSource;
    procedure edtNomeConsultaChange(Sender: TObject);
  private
    { Private declarations }
    config_local : TConfigTela;

    procedure ConfigurarGrid;

    procedure Consultar;
  public
    { Public declarations }
    constructor Criar(configuracao : TConfigTela);
  end;

var
  frmPesquisa: TfrmPesquisa;

implementation

{$R *.dfm}

{ TfrmPesquisa }

procedure TfrmPesquisa.ConfigurarGrid;
var
  I: Integer;
begin
  gridPesquisa.Columns.Clear;
  for I := Low(Self.config_local.Colunas) to High(Self.config_local.Colunas) do
    begin
      gridPesquisa.Columns.Add;
      gridPesquisa.Columns.Items[I].FieldName := Self.config_local.Colunas[I].FieldName;
      gridPesquisa.Columns.Items[I].Title := Self.config_local.Colunas[I].Title;
      gridPesquisa.Columns.Items[I].Width := Self.config_local.Colunas[I].Width;
    end;
end;

procedure TfrmPesquisa.Consultar;
var
  criterios : TCriterio;
begin
  criterios := TCriterio.Criar;
  criterios.limparCondicoes;

  criterios.addCondicao(
    Self.config_local.Repositorio.nomeCampoConsulta,
    'like',
    QuotedStr('%'+edtNomeConsulta.Text+'%')
  );

  dsPesquisa.DataSet := Self.config_local.Repositorio.listar(criterios);
end;

constructor TfrmPesquisa.Criar(configuracao: TConfigTela);
begin
  inherited Create(Application);

  Self.config_local := configuracao;

  lblRepositorio.Caption := Self.config_local.Repositorio.nomeRepositorio;

  ConfigurarGrid;

end;

procedure TfrmPesquisa.edtNomeConsultaChange(Sender: TObject);
begin
  Consultar;
end;

end.
