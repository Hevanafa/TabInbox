unit Unit1;

{$Mode ObjFPC}
{$H+}
{$J-}

interface

uses
  Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs, StdCtrls,
  UAppContext, UAddURL;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    URLTesterLabel: TLabel;
    TestLabel: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

uses URIParser;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Button1Click(Sender: TObject);
var
  fAddUrl: TForm2;
  uri: TUri;
begin
  try
    fAddUrl := TForm2.Create(Self);
    fAddUrl.ShowModal;

    TestLabel.Caption := getURL;
  finally
    fAddUrl.free
  end;

  uri := ParseURI(getURL);
  if (uri.protocol = 'https') and (uri.host <> '') then
    URLTesterLabel.Caption := 'Valid URL'
  else
    URLTesterLabel.Caption := 'Not a valid URL!';

end;

end.

