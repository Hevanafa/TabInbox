unit UAppContext;

{$Mode ObjFPC}
{$H+}
{$J-}

interface

uses
  Classes, SysUtils;

procedure setURL(const value: string);
function getURL: string;


implementation

var
  currentURL: string;

procedure setURL(const value: string);
begin
  currentURL := value
end;

function getURL: string;
begin
  getURL := currentURL
end;

end.

