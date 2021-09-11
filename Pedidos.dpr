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
  UPedidos in 'UPedidos.pas' {formPedidos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TconexaoDados, conexaoDados);
  Application.CreateForm(TformMain, formMain);
  Application.CreateForm(TformPedidos, formPedidos);
  Application.Run;
end.
