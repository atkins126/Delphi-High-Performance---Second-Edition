object frmReadWrite: TfrmReadWrite
  Left = 0
  Top = 0
  Caption = 'Read/Write'
  ClientHeight = 243
  ClientWidth = 685
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 19
  object btnReadWrite: TButton
    Left = 8
    Top = 8
    Width = 193
    Height = 41
    Caption = 'Read/Write'
    TabOrder = 0
    OnClick = btnReadWriteClick
  end
  object ListBox1: TListBox
    Left = 213
    Top = 0
    Width = 472
    Height = 243
    Align = alRight
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 19
    TabOrder = 1
  end
  object btnReadWriteLock: TButton
    Left = 8
    Top = 55
    Width = 193
    Height = 42
    Caption = 'Read/Write with locking'
    TabOrder = 2
    OnClick = btnReadWriteLockClick
  end
  object btnReadWriteInterlocked: TButton
    Left = 8
    Top = 103
    Width = 193
    Height = 42
    Caption = 'R/W with interlocked'
    TabOrder = 3
    OnClick = btnReadWriteInterlockedClick
  end
  object btnReadWriteMREW: TButton
    Left = 8
    Top = 151
    Width = 193
    Height = 42
    Caption = 'Read/Write with MREW'
    TabOrder = 4
    OnClick = btnReadWriteMREWClick
  end
end
