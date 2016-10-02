unit API_Path;

interface

uses APIBase, SysUtils, API_Output, Classes, IOUtils;

type
   TAPI_Path = class(TAPIBase)
   private
   protected
   public
     constructor Create(aAPI_Output: tAPI_Output); override;
     destructor Destroy; override;
     function Combine(const aPath1, aPath2: string): string;
     function GetFullPath(const aPath: string): string;
     function GetFileName(const aFileName: string): string;
     function GetDirectoryName(aFileName: string): string;
     function GetExtension(const aFileName: string): string;
     function GetFileNameWithoutExtension(const aFileName: string): string;
   end;


implementation


constructor TAPI_Path.create(aAPI_Output: tAPI_Output);
begin
  Inherited create(aAPI_Output);
end;

destructor TAPI_Path.destroy;
begin
  Inherited

end;

function TAPI_Path.Combine(const aPath1, aPath2: string): string;
begin
  Try
    Try
      Result := TPath.Combine(aPath1, aPath2);
    Except
      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;

function TAPI_Path.GetFullPath(const aPath: string): string;
begin
  Try
    Try
      Result := TPath.GetFullPath(aPath);
    Except
      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;

function TAPI_Path.GetFileName(const aFileName: string): string;
begin
  Try
    Try
      Result := TPath.GetFileName(aFileName);
    Except
      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;

function TAPI_Path.GetDirectoryName(aFileName: string): string;
begin
  Try
    Try
      Result := TPath.GetDirectoryName(aFileName);
    Except
      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;

function TAPI_Path.GetExtension(const aFileName: string): string;
begin
  Try
    Try
      Result := TPath.GetExtension(aFileName);
    Except
      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;

function TAPI_Path.GetFileNameWithoutExtension(const aFileName: string): string;
begin
  Try
    Try
      Result := TPath.GetFileNameWithoutExtension(aFileName);
    Except
      oAPI_Output.InternalError;
    End;
  Finally
  End;
end;



end.
