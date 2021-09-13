unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, System.Actions,
  Vcl.ActnList, Vcl.Buttons, Vcl.ExtCtrls, Utilitario, Pedido, JSON,
  UConfigurar_Conexao;

type
  TformMain = class(TForm)
    gbInfoBanco: TGroupBox;
    lbl_Info_BancoDados: TLabel;
    menuMain: TMainMenu;
    actionMain: TActionList;
    actionNovoPedido: TAction;
    actionFecharPedido: TAction;
    actionCancelarPedido: TAction;
    actionConfigurarBanco: TAction;
    Funes1: TMenuItem;
    NovoPedido1: TMenuItem;
    FecharPedido1: TMenuItem;
    CancelarPedido1: TMenuItem;
    Utilitrios1: TMenuItem;
    btConfigurarBanco: TSpeedButton;
    gbInfoPedido: TGroupBox;
    pnVisao: TPanel;
    lbl_visao_pos_0: TLabel;
    lbl_visao_pos_1: TLabel;
    lbl_visao_pos_2: TLabel;
    lbl_visao_pos_3: TLabel;
    pnQtde: TPanel;
    lbl_qtde_pos_0: TLabel;
    lbl_qtde_pos_1: TLabel;
    lbl_qtde_pos_2: TLabel;
    lbl_qtde_pos_3: TLabel;
    pnValorFaturado: TPanel;
    lbl_valor_pos_0: TLabel;
    lbl_valor_pos_1: TLabel;
    lbl_valor_pos_2: TLabel;
    lbl_valor_pos_3: TLabel;
    loadDashboard: TTimer;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    ConfigurarBancodeDados1: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure loadDashboardTimer(Sender: TObject);
    procedure actionConfigurarBancoExecute(Sender: TObject);
  private
    { Private declarations }
    procedure checarConexao;

    procedure limparDashboard;
    procedure carregarDashboard;
  public
    { Public declarations }
  end;

var
  formMain: TformMain;

implementation

{$R *.dfm}

uses DMMain, Cliente;

{ TformMain }

procedure TformMain.actionConfigurarBancoExecute(Sender: TObject);
begin
  try
    formConfigurar_Conexao := TformConfigurar_Conexao.Criar;
  finally
    FreeAndNil(formConfigurar_Conexao);
  end;
end;

procedure TformMain.carregarDashboard;
var
  repositorioPedido : TPedidoRepositorio;
  dashboardData, data : TJSONValue;
  dataArray : TJSONArray;
begin
  limparDashboard;

  repositorioPedido := TPedidoRepositorio.Create;

  dashboardData := TJSONObject.ParseJSONValue(repositorioPedido.pedidosDashboard.Text);

  if dashboardData <> nil then
    begin
      dataArray := dashboardData.GetValue<TJSONArray>('dashboard');
      for data in dataArray do
        begin
          case data.GetValue<Integer>('ordem') of
            PEDIDO_EM_ANDAMENTO : begin
              lbl_visao_pos_0.Caption := data.GetValue<String>('visao');
              lbl_qtde_pos_0.Caption := data.GetValue<Integer>('qtde').ToString;
              lbl_valor_pos_0.Caption := FormatFloat('#,##0.00', data.GetValue<Extended>('valor'));
            end;
            ITENS_NAO_ENTREGUES : begin
              lbl_visao_pos_1.Caption := data.GetValue<String>('visao');
              lbl_qtde_pos_1.Caption := data.GetValue<Integer>('qtde').ToString;
              lbl_valor_pos_1.Caption := FormatFloat('#,##0.00', data.GetValue<Extended>('valor'));
            end;
            PEDIDOS_CONCLUIDOS : begin
              lbl_visao_pos_2.Caption := data.GetValue<String>('visao');
              lbl_qtde_pos_2.Caption := data.GetValue<Integer>('qtde').ToString;
              lbl_valor_pos_2.Caption := FormatFloat('#,##0.00', data.GetValue<Extended>('valor'));
            end;
            ITENS_ENTREGUES : begin
              lbl_visao_pos_3.Caption := data.GetValue<String>('visao');
              lbl_qtde_pos_3.Caption := data.GetValue<Integer>('qtde').ToString;
              lbl_valor_pos_3.Caption := FormatFloat('#,##0.00', data.GetValue<Extended>('valor'));
            end;
          end;

        end;
    end;

  FreeAndNil(repositorioPedido);
  FreeAndNil(dashboardData);
  FreeAndNil(data);
  FreeAndNil(dataArray);
end;

procedure TformMain.checarConexao;
begin
  lbl_Info_BancoDados.Caption := 'Banco de Dados: '+conexaoDados.StatusConexao;
  if conexaoDados.StatusConexao = CONECTADO then
    begin
      lbl_Info_BancoDados.Font.Color := clGreen;
    end
  else
    begin
      lbl_Info_BancoDados.Font.Color := clRed;
    end;

end;

procedure TformMain.FormShow(Sender: TObject);
begin
  checarConexao;
  limparDashboard;
  loadDashboard.Enabled := true;
end;

procedure TformMain.limparDashboard;
begin
  lbl_visao_pos_0.Caption := 'PEDIDOS EM ANDAMENTO';
  lbl_qtde_pos_0.Caption := '0';
  lbl_valor_pos_0.Caption := '0,00';

  lbl_visao_pos_1.Caption := 'ITENS NÃO ENTREGUES';
  lbl_qtde_pos_1.Caption := '0';
  lbl_valor_pos_1.Caption := '0,00';

  lbl_visao_pos_2.Caption := 'PEDIDOS CONCLUÍDOS';
  lbl_qtde_pos_2.Caption := '0';
  lbl_valor_pos_2.Caption := '0,00';

  lbl_visao_pos_3.Caption := 'ITENS ENTREGUES';
  lbl_qtde_pos_3.Caption := '0';
  lbl_valor_pos_3.Caption := '0,00';
end;

procedure TformMain.loadDashboardTimer(Sender: TObject);
begin
  loadDashboard.Enabled := (conexaoDados.StatusConexao = CONECTADO);

  if loadDashboard.Enabled then
    begin
      carregarDashboard;
    end;
end;

end.
