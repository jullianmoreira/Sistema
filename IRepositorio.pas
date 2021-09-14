unit IRepositorio;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB,
  FireDAC.Comp.Client, Vcl.Dialogs, Tipos;

type
  TIRepositorio = interface
    function nomeCampoConsulta : String;
    function nomeRepositorio : String;
    function listar(condicoes : TCriterio) : TDataSet;
  end;

implementation

end.
