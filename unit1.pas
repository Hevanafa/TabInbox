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
  TSimpleCallback = procedure of object;

  { TFetchThread }

  TFetchThread = class(TThread)
  private
    fCallback: TSimpleCallback;
    fHTMLData: string;
  protected
    procedure Execute; override;
  public
    constructor Create(callback: TSimpleCallback);
    property HTMLData: string read fHTMLData;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    HTMLMemo: TMemo;
    URLTesterLabel: TLabel;
    TestLabel: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    fFetchThread: TFetchThread;

    procedure StartFetchThread;
    procedure LoadHTMLMemo;
  public

  end;


var
  Form1: TForm1;

implementation

uses URIParser, fphttpclient, opensslsockets;

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.StartFetchThread;
begin
  HTMLMemo.text := 'Attempting to fetch ' + getURL;
  fFetchThread := TFetchThread.create(@LoadHTMLMemo);
end;

procedure TForm1.LoadHTMLMemo;
begin
  HTMLMemo.Text := fFetchThread.HTMLData;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  fAddUrl: TForm2;
  uri: TUri;
  isValid: boolean;
begin
  try
    fAddUrl := TForm2.Create(Self);
    fAddUrl.ShowModal;

    TestLabel.Caption := getURL;
  finally
    fAddUrl.free
  end;

  uri := ParseURI(getURL);
  isValid := (uri.protocol = 'https') and (uri.host <> '');
  if isValid then
    URLTesterLabel.Caption := 'Valid URL'
  else
    URLTesterLabel.Caption := 'Not a valid URL!';

  startFetchThread
end;

{ TFetchThread }

procedure TFetchThread.Execute;
var
  client: TFPHTTPClient;
  response: string;
begin
  try
    client := TFPHTTPClient.Create(nil);
    response := client.get(getURL);

    fHTMLData := response;

    try
      Synchronize(fCallback)
    finally
    end;
  finally
    client.free;
  end;
end;

constructor TFetchThread.Create(callback: TSimpleCallback);
begin
  inherited create(false);
  FreeOnTerminate := true;
  fCallback := callback;
end;

end.

