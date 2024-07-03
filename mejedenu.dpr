program mejedenu;

uses
  Vcl.Forms,
  Main in 'Main.pas' {mainForm},
  OpenFileUnit in 'OpenFileUnit.pas' {openFileForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.CreateForm(TopenFileForm, openFileForm);
  Application.Run;
end.
