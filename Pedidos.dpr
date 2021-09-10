program Pedidos;



{$R *.dres}

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {formMain},
  Cliente in 'Entidade\Cliente.pas',
  Produto in 'Entidade\Produto.pas',
  Pedido in 'Entidade\Pedido.pas',
  ItensPedido in 'Entidade\ItensPedido.pas',
  Utilitario in 'Utilitario.pas',
  DMMain in 'DMMain.pas' {conexaoDados: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TconexaoDados, conexaoDados);
  Application.CreateForm(TformMain, formMain);
  Application.Run;
end.
