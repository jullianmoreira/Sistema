object conexaoDados: TconexaoDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 341
  Width = 515
  object fdManager: TFDManager
    FormatOptions.AssignedValues = [fvMapRules]
    FormatOptions.OwnMapRules = True
    FormatOptions.MapRules = <>
    Active = True
    Left = 216
    Top = 16
  end
  object fdConexao: TFDConnection
    LoginPrompt = False
    Left = 216
    Top = 64
  end
  object linkMySQL: TFDPhysMySQLDriverLink
    Left = 312
    Top = 16
  end
  object fdComando: TFDCommand
    Connection = fdConexao
    Left = 72
    Top = 40
  end
end
