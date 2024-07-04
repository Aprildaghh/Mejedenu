unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CustomizeDlg, System.Generics.Collections,
  Vcl.ExtCtrls, Vcl.ComCtrls, OpenFileUnit, System.IOUtils, System.UITypes, FMX.Types;

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
    procedure textBoxKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TTextFile = class
    filename  : string;
    isSaved   : boolean;
  private
    function getName: string;
    public
      constructor Create(filename: string; isSaved: boolean);
      property Name: string read getName;
  end;

var
  files: TList<TTextFile>;
  currentFileIndex      : integer;
  mainPath              : string;
  mainForm              : TmainForm;

implementation

{$R *.dfm}

function getFilenameFromPath(path: string): string;
var
  i         : Integer;
  tFilename : string;
begin
  tFilename := '';
  for i := path.LastIndexOf('\')+1 to path.Length do tFilename := tFilename + path[i];
  Result := tFilename;
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

procedure showTextFile;
var
  myFile          : TextFile;
  line, fullPath  : string;
  theFile         : TTextFile;
begin
  if currentFileIndex = -1 then Exit;

  theFile := files.Items[currentFileIndex];
  fullPath := mainPath + theFile.filename;

  mainForm.textBox.Clear;
  mainForm.textBox.Refresh;

  if FileExists(fullPath) then
  begin
    AssignFile(myFile, fullPath);
    Reset(myFile);

    while not Eof(myFile) do
    begin
      Readln(myFile, line);

      mainForm.textBox.Lines.Add(line);
    end;

    mainForm.textFileName.Caption := theFile.getName;

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

  fullPath := mainPath + getFilenameFromPath(files.Items[currentFileIndex].filename);

  assignFile(myFile, fullPath);
  ReWrite(myFile);

  for i := 0 to mainForm.textBox.Lines.Count - 1 do
  begin
    writeln(myFile, Utf8String(mainForm.textBox.Lines.ToStringArray[i]));
  end;

  files.Items[currentFileIndex].isSaved := True;
  mainForm.textFileName.Caption := files.Items[currentFileIndex].getName;

  CloseFile(myFile);
end;

procedure TmainForm.deleteBtnClick(Sender: TObject);
begin
  if currentFileIndex = -1 then Exit;

  // ask for confirmation
  if mrCancel = MessageDlg('Are you sure you want to GET RID of this file?', mtConfirmation, [mbOK, mbCancel], 0) then
  begin
    Exit;
  end;
  
  // delete file with cmd.exe
  DeleteFile(mainPath + files.Items[currentFileIndex].filename);

  textBox.Clear;
  textBox.Refresh;
  textFileName.Caption := '';
  
  files.Remove(files.Items[currentFileIndex]);
  dec(currentFileIndex);

  showTextFile;
end;

procedure TmainForm.FormCreate(Sender: TObject);
var
  i           : Integer;
  filenames   : TArray<string>;
begin

  files := TList<TTextFile>.Create;
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
    files.Add(TTextFile.Create(getFilenameFromPath(filenames[i]), True));
    inc(currentFileIndex);
  end;

  if currentFileIndex <> -1 then currentFileIndex := 0;
  
  showTextFile;
end;

procedure TmainForm.leftBtnClick(Sender: TObject);
begin
  if currentFileIndex > 0 then
  begin
    files.Items[currentFileIndex].isSaved := True;
    dec(currentFileIndex);
    showTextFile;
  end;
end;

procedure TmainForm.newBtnClick(Sender: TObject);
var
  newFileName: string;
  i: Integer;
begin
  saveFile;

  newFileName := inputBox('A wild InputBox appeared!', 'Name your new file: ', '');

  for i := 0 to files.Count-1 do
    if files.Items[i].filename = '\' + newFileName + '.txt' then
    begin
      MessageDlg('There shall be no text file named same as another!', mtWarning, [], 0);
      Exit;
    end;

  if newFileName = '' then
  begin
    MessageDlg('There shall be no text file named nothing!', mtWarning, [], 0);
    Exit;
  end;

  mainForm.textBox.Clear;
  mainForm.textBox.Refresh;
  
  currentFileIndex := files.Count;
  files.Add(TTextFile.Create('\' + newFileName + '.txt', False));

  textFileName.Caption := files.Items[currentFileIndex].getName;

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
    files.Items[currentFileIndex].isSaved := True;
    inc(currentFileIndex);
    showTextFile;
  end;
end;

procedure TmainForm.saveBtnClick(Sender: TObject);
begin
  saveFile;
end;

procedure TmainForm.textBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  tFile: TTextFile;
begin
  
  if (Key = vkS) and (Shift = [ssCtrl]) then
  begin
    saveFile;
    Exit;
  end;

  if (Shift = [ssCtrl]) then Exit;

  tFile := files.Items[currentFileIndex];
  tFile.isSaved := False;

  mainForm.textFileName.Caption := getFilenameWithoutTxtPart(tFile.filename) + '*';
    
end;

{ TTextFile }

constructor TTextFile.Create(fileName: string; isSaved: boolean);
begin
  self.filename := filename;
  self.isSaved := isSaved;
end;

function TTextFile.getName: string;
begin
  Result := getFilenameWithoutTxtPart(self.filename);
  if not self.isSaved then Result := Result + '*';
end;

end.
