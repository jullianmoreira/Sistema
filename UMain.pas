unit UMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus, System.Actions,
  Vcl.ActnList;

type
  TformMain = class(TForm)
    GroupBox1: TGroupBox;
    lbl_Info_BancoDados: TLabel;
    lbl_Info_Pedidos: TLabel;
    menuMain: TMainMenu;
    actionMain: TActionList;
    actionNovoPedido: TAction;
    actionFecharPedido: TAction;
    actionCancelarPedido: TAction;
    actionInstalarBanco: TAction;
    Funes1: TMenuItem;
    NovoPedido1: TMenuItem;
    FecharPedido1: TMenuItem;
    CancelarPedido1: TMenuItem;
    Utilitrios1: TMenuItem;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure checarConexao;
  public
    { Public declarations }
  end;

var
  formMain: TformMain;

implementation

{$R *.dfm}

uses DMMain;

{ TformMain }

procedure TformMain.checarConexao;
begin
  lbl_Info_BancoDados.Caption := 'Banco de Dados: '+conexaoDados.StatusConexao;
end;

procedure TformMain.FormShow(Sender: TObject);
begin
  checarConexao;
end;

end.
