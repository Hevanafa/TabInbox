unit Unit1;

{$Mode ObjFPC}
{$H+}
{$J-}

interface

uses
  Classes, SysUtils, Forms,
  Controls, Graphics, Dialogs, StdCtrls, ExtCtrls, ComCtrls,
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
    AddURLButton: TButton;
    LoggerMemo: TMemo;
    ListView1: TListView;
    procedure AddURLButtonClick(Sender: TObject);
  private
    fFetchThread: TFetchThread;

    procedure ClearLog;
    procedure WriteLog(const msg: string);

    procedure StartFetchThread;
    procedure LoadHTMLMemo;
  public

  end;


var
  Form1: TForm1;

implementation

uses
  LCLType,
  URIParser, fphttpclient, opensslsockets,
  DOM, DOM_HTML, SAX_HTML;

{$R *.lfm}

{ TForm1 }

procedure TForm1.StartFetchThread;
begin
  LoggerMemo.text := 'Attempting to fetch ' + getURL;
  fFetchThread := TFetchThread.create(@LoadHTMLMemo);
end;

procedure TForm1.LoadHTMLMemo;
var
  doc: THTMLDocument;
  reader: THTMLReader;
  converter: THTMLToDOMConverter;
  stream: TStringStream;
  nodes: TDOMNodeList;

  item: TListItem;
begin
  { LoggerMemo.Text := fFetchThread.HTMLData; }

  doc := THTMLDocument.create;
  reader := THTMLReader.create;
  converter := THTMLToDOMConverter.create(reader, doc);

  stream := TStringStream.create(fFetchThread.HTMLData);
  reader.ParseStream(stream);

  LoggerMemo.text := TTranslateString(doc.Title);

  nodes := doc.GetElementsByTagName('a');
  LoggerMemo.Lines.Add(format('href: %s', [TDOMElement(nodes[0]).GetAttribute('href')]));

  item := ListView1.Items.Add;
  with item do begin
    caption := '';
    SubItems.add(doc.title);
    SubItems.Add(getURL);
    { SubItemImages[]; }
  end;

  stream.free;
  converter.free;
  reader.free;
  doc.free
end;

procedure TForm1.ClearLog;
begin
  LoggerMemo.clear
end;

procedure TForm1.WriteLog(const msg: string);
begin
  LoggerMemo.lines.add(msg)
end;

procedure TForm1.AddURLButtonClick(Sender: TObject);
var
  fAddUrl: TForm2;
  uri: TUri;
  isValid: boolean;
begin
  try
    fAddUrl := TForm2.Create(Self);
    fAddUrl.ShowModal;

    clearLog;
    writeLog(getURL);
  finally
    fAddUrl.free
  end;

  uri := ParseURI(getURL);
  isValid := (uri.protocol = 'https') and (uri.host <> '');
  if isValid then
    writeLog('Valid URL')
  else
    writeLog('Not a valid URL!');

  if isValid then startFetchThread
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

