object mainForm: TmainForm
  Left = 0
  Top = 0
  BorderStyle = bsToolWindow
  Caption = 'Mejedenu'
  ClientHeight = 497
  ClientWidth = 1043
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object textFileName: TLabel
    Left = 8
    Top = 11
    Width = 3
    Height = 15
  end
  object textBox: TRichEdit
    Left = 8
    Top = 32
    Width = 1024
    Height = 409
    BorderWidth = 1
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
    OnKeyDown = textBoxKeyDown
  end
  object leftBtn: TButton
    Left = 8
    Top = 464
    Width = 75
    Height = 25
    Caption = '<'
    TabOrder = 1
    OnClick = leftBtnClick
  end
  object rightBtn: TButton
    Left = 121
    Top = 464
    Width = 75
    Height = 25
    Caption = '>'
    TabOrder = 2
    OnClick = rightBtnClick
  end
  object newBtn: TButton
    Left = 645
    Top = 464
    Width = 75
    Height = 25
    Caption = 'New'
    TabOrder = 3
    OnClick = newBtnClick
  end
  object deleteBtn: TButton
    Left = 749
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Delete'
    TabOrder = 4
    OnClick = deleteBtnClick
  end
  object saveBtn: TButton
    Left = 853
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Save'
    TabOrder = 5
    OnClick = saveBtnClick
  end
  object openBtn: TButton
    Left = 957
    Top = 464
    Width = 75
    Height = 25
    Caption = 'Open'
    TabOrder = 6
    OnClick = openBtnClick
  end
end
