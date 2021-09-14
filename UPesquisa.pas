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
    procedure btFecharClick(Sender: TObject);
    procedure gridPesquisaDblClick(Sender: TObject);
    procedure btSelecionarClick(Sender: TObject);
    procedure edtNomeConsultaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure gridPesquisaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    config_local : TConfigTela;

    procedure ConfigurarGrid;

    procedure Consultar;

    procedure Selecionar;
  public
    { Public declarations }
    Codigo_Selecionado : Integer;
    constructor Criar(configuracao : TConfigTela);
  end;

var
  frmPesquisa: TfrmPesquisa;

implementation

{$R *.dfm}

{ TfrmPesquisa }

procedure TfrmPesquisa.btFecharClick(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TfrmPesquisa.btSelecionarClick(Sender: TObject);
begin
  Selecionar;
end;

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

procedure TfrmPesquisa.edtNomeConsultaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key in [VK_RETURN, VK_DOWN] then
    begin
      if not dsPesquisa.DataSet.IsEmpty then
        begin
          gridPesquisa.SetFocus;
        end;
    end;
end;

procedure TfrmPesquisa.gridPesquisaDblClick(Sender: TObject);
begin
  Selecionar;
end;

procedure TfrmPesquisa.gridPesquisaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    Selecionar;
end;

procedure TfrmPesquisa.Selecionar;
begin
  if dsPesquisa.DataSet.IsEmpty then
    Codigo_Selecionado := -1
  else
    Codigo_Selecionado := dsPesquisa.DataSet.FieldByName('codigo').AsInteger;

  ModalResult := mrOK;
end;

end.
