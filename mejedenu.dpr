program mejedenu;

uses
  Vcl.Forms,
  Main in 'Main.pas' {mainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TmainForm, mainForm);
  Application.Run;
end.
