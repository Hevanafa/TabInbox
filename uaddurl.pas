unit UAddURL;

{$Mode ObjFPC}
{$H+}
{$J-}

interface

uses
  Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs, StdCtrls,
  LCLType,
  UAppContext;

type

  { TAddURLForm }

  TAddURLForm = class(TForm)
    URLEdit: TEdit;
    Label1: TLabel;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure URLEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private

  public

  end;

var
  Form2: TAddURLForm;

implementation

{$R *.lfm}

{ TAddURLForm }

procedure TAddURLForm.URLEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_RETURN then setURL(URLEdit.text);
  close
end;

procedure TAddURLForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  canclose := false;
  hide
end;

end.

