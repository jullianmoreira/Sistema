program Pedidos;



{$R *.dres}

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {formMain},
  Cliente in 'Entidade\Cliente.pas',
  Produto in 'Entidade\Produto.pas',
  Pedido in 'Entidade\Pedido.pas',
  ItemPedido in 'Entidade\ItemPedido.pas',
  Utilitario in 'Utilitario.pas',
  DMMain in 'DMMain.pas' {conexaoDados: TDataModule},
  UConfigurar_Conexao in 'UConfigurar_Conexao.pas' {formConfigurar_Conexao},
  UPedidos in 'UPedidos.pas' {formPedidos},
  IRepositorio in 'IRepositorio.pas',
  Tipos in 'Tipos.pas',
  UPesquisa in 'UPesquisa.pas' {frmPesquisa};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TconexaoDados, conexaoDados);
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
