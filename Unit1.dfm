object Form1: TForm1
  Left = 291
  Top = 271
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Form1'
  ClientHeight = 589
  ClientWidth = 900
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 680
    Top = 8
    Width = 74
    Height = 13
    Caption = 'Enter element :'
  end
  object lbl2: TLabel
    Left = 16
    Top = 488
    Width = 16
    Height = 13
    Caption = 'lbl2'
  end
  object btn1: TButton
    Left = 680
    Top = 32
    Width = 201
    Height = 41
    Caption = 'Draw Tree'
    TabOrder = 0
    OnClick = btn1Click
  end
  object btn2: TButton
    Left = 680
    Top = 80
    Width = 201
    Height = 41
    Caption = 'Add To Tree'
    TabOrder = 1
    OnClick = btn2Click
  end
  object btn3: TButton
    Left = 680
    Top = 224
    Width = 201
    Height = 41
    Caption = 'Reset'
    TabOrder = 2
    OnClick = btn3Click
  end
  object tv1: TTreeView
    Left = 0
    Top = 8
    Width = 657
    Height = 569
    Indent = 19
    ReadOnly = True
    ShowButtons = False
    ShowLines = False
    ShowRoot = False
    SortType = stData
    TabOrder = 3
    Visible = False
  end
  object btn4: TButton
    Left = 680
    Top = 272
    Width = 201
    Height = 41
    Caption = 'Direct'
    TabOrder = 4
    OnClick = btn4Click
  end
  object Button1: TButton
    Left = 680
    Top = 320
    Width = 201
    Height = 41
    Caption = 'Reverse'
    TabOrder = 5
    OnClick = Button1Click
  end
  object btn5: TButton
    Left = 680
    Top = 368
    Width = 201
    Height = 41
    Caption = 'Simmetric'
    TabOrder = 6
    OnClick = btn5Click
  end
  object btn6: TButton
    Left = 680
    Top = 128
    Width = 201
    Height = 41
    Caption = 'Delete from tree'
    TabOrder = 7
    OnClick = btn6Click
  end
  object btn7: TButton
    Left = 680
    Top = 528
    Width = 201
    Height = 41
    Caption = 'Insertion'
    Font.Charset = BALTIC_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 8
    OnClick = btn7Click
  end
  object edt1: TEdit
    Left = 760
    Top = 8
    Width = 33
    Height = 21
    TabOrder = 9
    Text = 'edt1'
  end
  object btn8: TButton
    Left = 680
    Top = 176
    Width = 201
    Height = 41
    Caption = 'Find'
    TabOrder = 10
    OnClick = btn8Click
  end
end
