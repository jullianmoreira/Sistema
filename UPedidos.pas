unit UPedidos;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Pedido, System.Math,
  ItemPedido, Cliente, Produto, DMMain, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Buttons, Vcl.Grids, Vcl.DBGrids,
  Tipos, Datasnap.DBClient, Utilitario;
const
  INSERIR = 0;
  ATUALIZAR = 1;

type
  TformPedidos = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtPedido_Codigo: TEdit;
    edtCliente_Codigo: TEdit;
    edtCliente_Nome: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    lblCliente_Cidade: TLabel;
    lblCliente_UF: TLabel;
    pnBotoes: TPanel;
    pnMID: TPanel;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    dsItemPedido: TDataSource;
    btSair: TSpeedButton;
    btSalvarPedido: TSpeedButton;
    gbItemProduto: TGroupBox;
    gridItensPedido: TDBGrid;
    Label6: TLabel;
    edtProduto_Codigo: TEdit;
    edtProduto_Nome: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtQuantidade: TEdit;
    edtValor_Unitario: TEdit;
    edtValor_Total: TEdit;
    btNovoProduto: TSpeedButton;
    btRetirar: TSpeedButton;
    btAlterar: TSpeedButton;
    cdsItensPedido: TClientDataSet;
    Label3: TLabel;
    edtPedido_Valor_Total: TEdit;
    cdsItensPedidoproduto_codigo: TIntegerField;
    cdsItensPedidonome: TStringField;
    cdsItensPedidoquantidade: TFloatField;
    cdsItensPedidovalor_unitario: TFloatField;
    cdsItensPedidovalor_total: TFloatField;
    Label10: TLabel;
    procedure edtCliente_CodigoExit(Sender: TObject);
    procedure btSairClick(Sender: TObject);
    procedure MascaraNumero(Sender: TObject; var Key: Char);
    procedure edtQuantidadeChange(Sender: TObject);
    procedure edtValor_UnitarioChange(Sender: TObject);
    procedure edtProduto_CodigoExit(Sender: TObject);
    procedure edtCliente_CodigoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cdsItensPedidoAfterOpen(DataSet: TDataSet);
    procedure edtValor_UnitarioExit(Sender: TObject);
    procedure gridItensPedidoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btNovoProdutoClick(Sender: TObject);
    procedure btAlterarClick(Sender: TObject);
    procedure btRetirarClick(Sender: TObject);
    procedure btSalvarPedidoClick(Sender: TObject);
  private
    { Private declarations }
    Acao : Integer;
    Pedido : TPedido;
    Cliente : TCliente;

    Produto : TProduto;

    ctrCliente : TClienteController;
    ctrProduto : TProdutoController;

    ctrPedido : TPedidoController;
    ctrItemPedido : TItemPedidoController;

    procedure LimparEditsPedido;
    procedure CarregarEditsPedido;

    procedure LimparEditsCliente;
    procedure CarregarEditsCliente;

    procedure LimparEditsProduto;
    procedure CarregarEditsProduto;

    procedure CalcularTotal;
    procedure CarregarDoGrid;

    procedure SalvarPedido;
    procedure LancarItemPedido;
  public
    { Public declarations }
    constructor Criar(_Pedido : TPedido);
  end;

var
  formPedidos: TformPedidos;

implementation

{$R *.dfm}

{ TformPedidos }

procedure TformPedidos.btAlterarClick(Sender: TObject);
begin
  btAlterar.Enabled := false;

  Acao := ATUALIZAR;

  gbItemProduto.Enabled := true;
  edtProduto_Codigo.SetFocus;
  edtProduto_Codigo.SelectAll;
end;

procedure TformPedidos.btNovoProdutoClick(Sender: TObject);
begin
  btNovoProduto.Enabled := false;

  Acao := INSERIR;

  LimparEditsProduto;
  Produto.Codigo := SEM_REGISTRO;
  Produto.Nome := VAZIO;
  Produto.ValorVenda := ZeroValue;

  gbItemProduto.Enabled := true;
  edtProduto_Codigo.SetFocus;
end;

procedure TformPedidos.btRetirarClick(Sender: TObject);
begin
  cdsItensPedido.Delete;
end;

procedure TformPedidos.btSairClick(Sender: TObject);
begin
  ModalResult := mrClose;
end;

procedure TformPedidos.btSalvarPedidoClick(Sender: TObject);
begin
  SalvarPedido;
end;

procedure TformPedidos.CalcularTotal;
var
  Quantidade, Unitario, Total : Extended;
  calcular : Boolean;
begin
  Quantidade := ZeroValue;
  Unitario := ZeroValue;

  calcular := (TryStrToFloat(edtQuantidade.Text, Quantidade)
  and TryStrToFloat(edtValor_Unitario.Text, Unitario));

  if calcular then
    begin
      Total := (Quantidade * Unitario);
      edtValor_Total.Text := FormatFloat(FORMAT_NUMERO, Total);
    end;

end;

procedure TformPedidos.CarregarDoGrid;
begin
  with cdsItensPedido do
    begin
      if not IsEmpty then
        begin
          edtProduto_Codigo.Text := cdsItensPedidoproduto_codigo.AsString;
          edtProduto_Nome.Text := cdsItensPedidonome.AsString;
          edtQuantidade.Text := FormatFloat(FORMAT_NUMERO_BANCO, cdsItensPedidoquantidade.AsFloat);
          edtValor_Unitario.Text := FormatFloat(FORMAT_NUMERO_BANCO, cdsItensPedidovalor_unitario.AsFloat);
          edtValor_Total.Text := FormatFloat(FORMAT_NUMERO_BANCO, cdsItensPedidovalor_total.AsFloat);
        end;
    end;

end;

procedure TformPedidos.CarregarEditsCliente;
begin
  edtCliente_Codigo.Text := Cliente.Codigo.ToString;
  edtCliente_Nome.Text := Cliente.Nome;
  lblCliente_Cidade.Caption := cliente.Cidade;
  lblCliente_UF.Caption := Cliente.UF;
end;

procedure TformPedidos.CarregarEditsPedido;
begin
  if Pedido.Codigo <> SEM_REGISTRO then
    begin
      edtPedido_Codigo.Text := Pedido.Codigo.ToString;
      edtPedido_Valor_Total.Text := FormatFloat(FORMAT_NUMERO,Pedido.Valor_Total);
    end;

  if Pedido.Cliente_Codigo <> SEM_REGISTRO then
    begin
      CarregarEditsCliente;
    end;
end;

procedure TformPedidos.CarregarEditsProduto;
begin
  if Produto.Codigo <> SEM_REGISTRO then
    begin
      edtProduto_Codigo.Text := Produto.Codigo.ToString;
      edtProduto_Nome.Text := Produto.Nome;
      edtQuantidade.Text := STR_UM;
      edtValor_Unitario.Text := FormatFloat(FORMAT_NUMERO_BANCO, Produto.ValorVenda);
      edtValor_UnitarioChange(Self);
    end;
end;

procedure TformPedidos.cdsItensPedidoAfterOpen(DataSet: TDataSet);
var
  totalPedido : Extended;
begin
  totalPedido := 0;
  with DataSet do
    begin
      if not IsEmpty then
        begin
          First;
          while not Eof do
            begin
              totalPedido := totalPedido + FieldByName(CAMPO_VALOR_TOTAL).AsFloat;
              Next;
            end;
        end;
    end;

  btAlterar.Enabled := not DataSet.IsEmpty;
  btRetirar.Enabled := not DataSet.IsEmpty;
  edtPedido_Valor_Total.Text := FormatFloat(FORMAT_NUMERO, totalPedido);
end;

constructor TformPedidos.Criar(_Pedido: TPedido);
begin
  Inherited Create(Application);

  ctrCliente := TClienteController.Create;
  ctrProduto := TProdutoController.Create;
  ctrPedido := TPedidoController.Create;
  ctrItemPedido := TItemPedidoController.Create;

  Pedido := _Pedido;
  LimparEditsPedido;

  Produto := TProduto.Criar;


  if Pedido.Codigo <> SEM_REGISTRO then
    begin
      Cliente := ctrCliente.pegarPorCodigo(Pedido.Cliente_Codigo);
      CarregarEditsPedido;
    end
  else
    begin
      Cliente := TCliente.Criar;
    end;

  cdsItensPedido.Open;

  Self.ShowModal;
end;

procedure TformPedidos.edtCliente_CodigoExit(Sender: TObject);
var
  localizado : TCliente;
begin
  if edtCliente_Codigo.Text = VAZIO then
    begin
      localizado := ctrCliente.Consultar;
    end
  else
    begin
      localizado := ctrCliente.pegarPorCodigo(StrToInt(edtCliente_Codigo.Text));
    end;

  Cliente := localizado;
  LimparEditsCliente;
  if Cliente.Codigo <> SEM_REGISTRO then
    CarregarEditsCliente;
end;

procedure TformPedidos.edtCliente_CodigoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  localizado : TCliente;
begin
  if Key = VK_F5 then
    begin
      localizado := ctrCliente.Consultar;
      Cliente := localizado;
      LimparEditsCliente;
      CarregarEditsProduto;
    end;
end;

procedure TformPedidos.edtProduto_CodigoExit(Sender: TObject);
var
  localizado : TProduto;
begin
  if edtProduto_Codigo.Text = VAZIO then
    begin
      localizado := ctrProduto.Consultar;
    end
  else
    begin
      localizado := ctrProduto.pegarPorCodigo(StrToInt(edtProduto_Codigo.Text));
    end;

  Produto := localizado;
  LimparEditsProduto;
  CarregarEditsProduto;
end;

procedure TformPedidos.edtQuantidadeChange(Sender: TObject);
begin
  CalcularTotal;
end;

procedure TformPedidos.edtValor_UnitarioChange(Sender: TObject);
begin
  CalcularTotal;
end;

procedure TformPedidos.edtValor_UnitarioExit(Sender: TObject);
begin
  LancarItemPedido;
end;

procedure TformPedidos.gridItensPedidoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    begin
      CarregarDoGrid;
      btAlterar.Click;
    end;
end;

procedure TformPedidos.LancarItemPedido;
begin
  try
    cdsItensPedido.Open;

    case Acao of
      INSERIR : cdsItensPedido.Append;
      ATUALIZAR : cdsItensPedido.Edit;
    end;
    cdsItensPedidoproduto_codigo.Value := StrToInt(edtProduto_Codigo.Text);
    cdsItensPedidonome.Value := edtProduto_Nome.Text;
    cdsItensPedidoquantidade.Value := StrToFloat(edtQuantidade.Text);
    cdsItensPedidovalor_unitario.Value := StrToFloat(edtValor_Unitario.Text);
    cdsItensPedidovalor_total.Value := StrToFloat(edtValor_Total.Text);

    cdsItensPedido.Post;
    cdsItensPedido.Close;
    cdsItensPedido.Open;

  finally
    case Acao of
      INSERIR : begin
          btNovoProduto.Enabled := true;
          LimparEditsProduto;
      end;
    end;

    gbItemProduto.Enabled := false;

    Produto.Codigo := SEM_REGISTRO;
    Produto.Nome := VAZIO;
    Produto.ValorVenda := ZeroValue;

    Acao := SEM_REGISTRO;
  end;
end;

procedure TformPedidos.LimparEditsCliente;
begin
  edtCliente_Codigo.Text := VAZIO;
  edtCliente_Nome.Text := VAZIO;
  lblCliente_Cidade.Caption := VAZIO;
  lblCliente_UF.Caption := VAZIO;
end;

procedure TformPedidos.LimparEditsPedido;
begin
  edtPedido_Codigo.Clear;
  edtPedido_Valor_Total.Clear;
end;

procedure TformPedidos.LimparEditsProduto;
begin
  edtProduto_Codigo.Clear;
  edtProduto_Nome.Clear;
  edtQuantidade.Clear;
  edtValor_Unitario.Clear;
  edtValor_Total.Clear;
end;

procedure TformPedidos.MascaraNumero(Sender: TObject; var Key: Char);
begin
  if not ((Key in ['0'..'9']) or
          (Key in [
                    Char(VK_RETURN),
                    ',',
                    Char(VK_DELETE),
                    Char(VK_TAB),
                    Char(VK_BACK)
                  ]
          )) then
    Key := #0;
end;

procedure TformPedidos.SalvarPedido;
var
  itemPedido : TItemPedido;
  fechar : Boolean;
begin
  try
    btSalvarPedido.Enabled := false;
    fechar := true;
    conexaoDados.fdTransacao.Options.AutoCommit := false;

    conexaoDados.fdTransacao.StartTransaction;

    if edtPedido_Codigo.Text = VAZIO then
      Pedido.Codigo := SEM_REGISTRO;
    Pedido.Cliente_Codigo := StrToInt(edtCliente_Codigo.Text);
    Pedido.Data_Criacao := Now;
    Pedido.Valor_Total := StrToFloat(StringReplace(edtPedido_Valor_Total.Text,'.','',[rfReplaceAll]));

    if ctrPedido.salvar(Pedido) then
      begin
        with cdsItensPedido do
          begin
            First;
            while not Eof do
              begin
                itemPedido := TItemPedido.Criar;
                itemPedido.Codigo := SEM_REGISTRO;
                itemPedido.Pedido_Codigo := Pedido.Codigo;
                itemPedido.Produto_Codigo := cdsItensPedidoproduto_codigo.Value;
                itemPedido.Data_Criacao := now;
                itemPedido.Data_Entrega := ZeroValue;
                itemPedido.Quantidade := cdsItensPedidoquantidade.Value;
                itemPedido.Valor_Unitario := cdsItensPedidovalor_unitario.Value;
                itemPedido.Valor_Total := cdsItensPedidovalor_total.Value;

                if ctrItemPedido.salvar(itemPedido) then
                  begin
                    FreeAndNil(itemPedido);
                    Next;
                  end
                else
                  begin
                    fechar := false;
                    conexaoDados.fdTransacao.Rollback;
                    Break;
                  end;
              end;
          end;
      end
    else
      begin
        fechar := false;
        conexaoDados.fdTransacao.Rollback;
      end;

    if fechar then
      begin
        conexaoDados.fdTransacao.Commit;
        ModalResult := mrOk;
      end;
  except
    on e : exception do
      begin
        TErro.Mostrar('Não foi possível salvar o pedido.'+#13+
        'Mensagem: '+e.Message);
        conexaoDados.fdTransacao.Rollback;
        btSalvarPedido.Enabled := true;
      end;

  end;

end;

end.
