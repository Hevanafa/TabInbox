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

  { TForm2 }

  TForm2 = class(TForm)
    AcceptButton: TButton;
    URLEdit: TEdit;
    Label1: TLabel;
    procedure AcceptButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure URLEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private

  public

  end;

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.URLEditKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_RETURN then begin
    setURL(URLEdit.text);
    ModalResult := mrOk;
    close
  end;
end;

procedure TForm2.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if ModalResult <> mrOK then
    ModalResult := mrCancel;

  CanClose := true
end;

procedure TForm2.FormShow(Sender: TObject);
begin
end;

procedure TForm2.AcceptButtonClick(Sender: TObject);
begin
  { ModalResult := mrOK; } { This is already set in the designer view }
  setURL(URLEdit.text)
end;

end.

