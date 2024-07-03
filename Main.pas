unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CustomizeDlg, System.Generics.Collections,
  Vcl.ExtCtrls, Vcl.ComCtrls, OpenFileUnit, System.IOUtils;

type
  TmainForm = class(TForm)
    textBox: TRichEdit;
    leftBtn: TButton;
    rightBtn: TButton;
    newBtn: TButton;
    deleteBtn: TButton;
    saveBtn: TButton;
    openBtn: TButton;
    textFileName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure leftBtnClick(Sender: TObject);
    procedure rightBtnClick(Sender: TObject);
    procedure saveBtnClick(Sender: TObject);
    procedure newBtnClick(Sender: TObject);
    procedure deleteBtnClick(Sender: TObject);
    procedure openBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  files: TList<string>;
  currentFileIndex: integer;
  mainPath: string;
  mainForm: TmainForm;

implementation

{$R *.dfm}

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

procedure showTextFile;
var
  myFile          : TextFile;
  line, fullPath  : string;
  lineCount       : integer;
begin
  if currentFileIndex = -1 then Exit;

  lineCount := 0;
  fullPath := mainPath + files.Items[currentFileIndex];

  mainForm.textBox.Clear;

  if FileExists(fullPath) then
  begin

    AssignFile(myFile, fullPath);
    Reset(myFile);

    while not Eof(myFile) do
    begin
      Readln(myFile, line);

      mainForm.textBox.Lines[lineCount] := line;
      inc(lineCount);
    end;

    mainForm.Caption := getFilenameWithoutTxtPart(files.Items[currentFileIndex]);

    CloseFile(myFile);
  end;
end;

procedure saveFile;
var
  myFile: TextFile;
  fullPath: string;
  i: Integer;
begin
  if currentFileIndex = -1 then Exit;

  fullPath := mainPath + files.Items[currentFileIndex];

  assignFile(myFile, fullPath);
  ReWrite(myFile);

  for i := 0 to mainForm.textBox.Lines.Count - 1 do
  begin
    writeln(myFile, mainForm.textBox.Lines.ToStringArray[i]);
  end;

  CloseFile(myFile);
end;

procedure TmainForm.deleteBtnClick(Sender: TObject);
begin
  if currentFileIndex = -1 then Exit;
  

  // delete file with cmd.exe
  DeleteFile(mainPath + files.Items[currentFileIndex]);

  dec(currentFileIndex);
  showTextFile;
end;

function getFileName(str: string): string;
var
  name: string;
  i: Integer;
begin
  for i := str.LastIndexOf('\') + 1 to str.Length do name := name + str[i];
  Result := name;
end;

procedure TmainForm.FormCreate(Sender: TObject);
var
  SR      : TSearchRec;
  i       : Integer;
  filenames: TArray<string>;
begin
  files := TList<string>.Create;
  currentFileIndex := -1;

  // get to the %appdata%/mejedenu folder also store the path to mainPath
  mainPath := GetEnvironmentVariable('appdata') + '\mejedenu';

  try
    mkdir(mainPath);
  except
  end;

  // get all text files' names and store them to files

  filenames := TDirectory.GetFiles(mainPath);

  for i := 0 to Length(filenames) - 1 do
  begin
    files.Add(getFileName(filenames[i]));
    inc(currentFileIndex);
  end;

  if currentFileIndex <> -1 then currentFileIndex := 0;
  
  showTextFile;
end;

procedure TmainForm.leftBtnClick(Sender: TObject);
begin
  if currentFileIndex > 0 then
  begin
    saveFile;
    dec(currentFileIndex);
    showTextFile;
  end;
end;

procedure TmainForm.newBtnClick(Sender: TObject);
var
  newFileName: string;
begin
  saveFile;

  newFileName := inputBox('A wild InputBox appeared!', 'Name your new file: ', '');

  if newFileName = '' then
  begin
    MessageDlg('There shall be no text file named nothing!', mtWarning, [], 0);
  end;

  currentFileIndex := files.Count;
  files.Add(newFileName + '.txt');
  showTextFile;
  saveFile;

end;

procedure TmainForm.openBtnClick(Sender: TObject);
begin
  openFileForm.showModal;

  saveFile;

  if openFileForm.chosenFileIndex <> -1 then
    currentFileIndex := openFileForm.chosenFileIndex;

  showTextFile;
end;

procedure TmainForm.rightBtnClick(Sender: TObject);
begin
  if currentFileIndex < files.Count-1 then
  begin
    saveFile;
    inc(currentFileIndex);
    showTextFile;
  end;
end;

procedure TmainForm.saveBtnClick(Sender: TObject);
begin
  saveFile;
end;

end.
