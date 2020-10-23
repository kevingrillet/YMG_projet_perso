object dmTrayIcon: TdmTrayIcon
  OldCreateOrder = False
  Height = 150
  Width = 215
  object myTrayIcon: TTrayIcon
    Hint = 'Projet perso'
    PopupMenu = popupMenuTrayIcon
    Visible = True
    Left = 39
    Top = 16
  end
  object popupMenuTrayIcon: TPopupMenu
    Images = dmImages.imageList32
    Left = 135
    Top = 16
    object miGreen: TMenuItem
      Caption = 'Disponible'
      ImageIndex = 1
    end
    object miYellow: TMenuItem
      Caption = 'Absent'
      ImageIndex = 2
    end
    object miRed: TMenuItem
      Caption = 'Occup'#233
      ImageIndex = 3
    end
    object miOff: TMenuItem
      Caption = 'Invisible'
      ImageIndex = 0
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object miParam: TMenuItem
      Caption = 'Param'#232'tres'
      ImageIndex = 4
    end
    object miRefresh: TMenuItem
      Caption = 'Actualiser'
      ImageIndex = 8
    end
    object miClose: TMenuItem
      Caption = 'Fermer'
      ImageIndex = 7
    end
  end
end
