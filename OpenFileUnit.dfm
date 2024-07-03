object openFileForm: TopenFileForm
  Left = 0
  Top = 0
  BorderStyle = bsSizeToolWin
  Caption = 'Choose your Pokemon ?!'
  ClientHeight = 344
  ClientWidth = 245
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object listBox: TListBox
    Left = 16
    Top = 16
    Width = 209
    Height = 257
    ItemHeight = 15
    TabOrder = 0
  end
  object btn: TButton
    Left = 150
    Top = 296
    Width = 75
    Height = 25
    Caption = 'Choose'
    TabOrder = 1
    OnClick = btnClick
  end
end
