unit OpenFileUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TopenFileForm = class(TForm)
    listBox: TListBox;
    btn: TButton;
    procedure FormActivate(Sender: TObject);
    procedure btnClick(Sender: TObject);
    procedure listBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    chosenFileIndex: integer;
  end;

var
  openFileForm: TopenFileForm;

implementation

{$R *.dfm}

uses
  Main, System.UITypes, FMX.Types;

procedure TopenFileForm.btnClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to listBox.Items.Count - 1 do
  begin
    if listBox.Selected[i] then
    begin
      chosenFileIndex := i;
      break;
    end;
  end;
  self.Close;
end;

function getFilenameWithoutTxtPart(str: string): string;
var
  name: string;
  i: Integer;
begin
  for i := str.LastIndexOf('\') + 2 to str.Length do
  begin
    if str[i] = '.' then break;

    name := name + str[i];
  end;

  Result := name;
end;


procedure TopenFileForm.FormActivate(Sender: TObject);
var
  i: Integer;
begin
  chosenFileIndex := -1;
  listBox.Clear;
  for i := 0 to files.Count - 1 do
  begin
    listBox.AddItem(getFilenameWithoutTxtPart(files.Items[i].filename), nil);
  end;

end;

procedure TopenFileForm.listBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = vkReturn then
    btnClick(self);
end;

end.
