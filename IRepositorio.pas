unit IRepositorio;

interface
uses System.Classes, System.SysUtils, System.Math, Data.DB,
  FireDAC.Comp.Client, Vcl.Dialogs, Tipos;

type
  TIRepositorio = interface['{BB7BAC3C-AD14-4400-B95B-CFEC49C1F246}']
    function nomeCampoConsulta : String;
    function nomeRepositorio : String;
    function listar(condicoes : TCriterio) : TDataSet;
  end;

implementation

end.
