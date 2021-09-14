unit Tipos;

interface
uses System.Classes, System.StrUtils, System.Math, System.SysUtils, System.IniFiles,
  Winapi.Windows, Vcl.Forms, Generics.Collections;

const
  VAZIO = '';
  SEM_REGISTRO = -1;
  REGISTRO_VALIDO = 1;
  STR_UM = '1';
  FORMAT_NUMERO = '#,##0.00';
  FORMAT_HORARIO_BANCO = 'yyyy-mm-dd hh:mm:ss';
  FORMAT_NUMERO_BANCO = '#0.00';

  CAMPO_CODIGO = 'codigo';
  CAMPO_NOME = 'nome';
  CAMPO_CIDADE = 'cidade';
  CAMPO_UF = 'uf';

  CAMPO_VALOR_VENDA = 'valor_venda';
  CAMPO_QUANTIDADE = 'quantidade';
  CAMPO_VALOR_UNITARIO = 'valor_unitario';
  CAMPO_VALOR_TOTAL = 'valor_total';

type
    TCriterio = class(TObject)
    private
      FCampos : TArray<String>;
      FCondicao : TArray<String>;
      FValor : TArray<String>;
      FJuncao : TArray<String>;

      TamanhoAtual : Integer;

    public
      Agrupamento : String;
      Ordem : String;
      constructor Criar;

      procedure addCondicao(Campo, Condicao, Valor : String; Juncao : String = '');
      procedure limparCondicoes;
      procedure limparCondicao(Campo : String); overload;
      procedure limparCondicao(Posicao : Integer); overload;

      function getCriterios : TStringList;
  end;

implementation

{ TCriterio }

procedure TCriterio.addCondicao(Campo, Condicao, Valor, Juncao: String);
var
  pos : Integer;
begin
  Inc(TamanhoAtual);
  pos := (TamanhoAtual - 1);

  SetLength(Self.FCampos, TamanhoAtual);
  SetLength(Self.FCondicao, TamanhoAtual);
  SetLength(Self.FValor, TamanhoAtual);
  SetLength(Self.FJuncao, TamanhoAtual);

  Self.FCampos[pos] := Campo;
  Self.FCondicao[pos] := Condicao;
  Self.FValor[pos] := Valor;
  Self.FJuncao[pos] := Juncao;
end;

constructor TCriterio.Criar;
begin
  inherited Create;

  SetLength(Self.FCampos, 0);
  SetLength(Self.FCondicao, 0);
  SetLength(Self.FValor, 0);
  SetLength(Self.FJuncao, 0);

  TamanhoAtual := 0;
end;

function TCriterio.getCriterios: TStringList;
var
  i : Integer;
  Clause : String;
begin
  Result := TStringList.Create;
  Result.Clear;
  Clause := 'WHERE ';
  for i := 0 to (TamanhoAtual-1) do
    begin
      if Self.FCampos[i] <> '' then
        begin
          Result.Add(Clause + Self.FCampos[i]+' '+Self.FCondicao[i]+' '+Self.FValor[i]);

          if Self.FJuncao[i] <> '' then
            Clause := Self.FJuncao[i]
          else
            Clause := 'AND ';
        end;
    end;

  if Agrupamento <> '' then
    Result.Add('GROUP BY '+Agrupamento);

  if Ordem <> '' then
    Result.Add('ORDER BY '+Ordem);
end;

procedure TCriterio.limparCondicao(Posicao: Integer);
begin
  if (Posicao < TamanhoAtual) and (Posicao > -1) then
    begin
      Self.FCampos[Posicao] := '';
      Self.FCondicao[Posicao] := '';
      Self.FValor[Posicao] := '';
      Self.FJuncao[Posicao] := '';
    end;
end;

procedure TCriterio.limparCondicao(Campo: String);
var
  I: Integer;
begin
  for I := Low(Self.FCampos) to High(Self.FCampos) do
    begin
      if Self.FCampos[I] = Campo then
        begin
          Self.FCampos[I] := '';
          Self.FCondicao[I] := '';
          Self.FValor[I] := '';
          Self.FJuncao[I] := '';
        end;
    end;
end;

procedure TCriterio.limparCondicoes;
var
  I: Integer;
begin

  for I := (TamanhoAtual-1) downto 0 do
    begin
      Self.FCampos[I] := '';
      Self.FCondicao[I] := '';
      Self.FValor[I] := '';
      Self.FJuncao[I] := '';
    end;

  TamanhoAtual := 0;
  SetLength(Self.FCampos, 0);
  SetLength(Self.FCondicao, 0);
  SetLength(Self.FValor, 0);
  SetLength(Self.FJuncao, 0);
end;

end.
