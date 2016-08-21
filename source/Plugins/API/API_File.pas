unit API_File;

interface

uses APIBase, SysUtils, API_Output, Classes, NovusFileUtils;

type
   TAPI_File = class(TAPIBase)
   private
   protected
   public
     constructor Create(aAPI_Output: tAPI_Output); override;
     destructor Destroy; override;

     function IncludeTrailingPathDelimiter(const s: string): String;
     function Exists(const aFilename: String): Boolean;
     function Copy(const aSourceFilename: String; const aDestFilename: String; const aOverWrite : Boolean ): Boolean;
     function Delete(const aFilename: String): Boolean;
     function Move(const aSourceFilename: String; const aDestFilename: String): Boolean;
   end;

implementation

uses System.IOUtils;

constructor TAPI_File.create(aAPI_Output: tAPI_Output);
begin
  Inherited create(aAPI_Output);
end;

destructor TAPI_File.destroy;
begin
end;


function TAPI_File.Exists(const aFilename: String): Boolean;
begin
  Try
    Try
      Result := FileExists(aFilename);
    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_File.Copy(const aSourceFilename: String; const aDestFilename: String; const aOverWrite : Boolean ): Boolean;
begin
  Try
    Try
      TFile.Copy(aSourceFilename, aDestFilename, aOverWrite);

      Result := True;

    Except
      Result := False;

      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_File.IncludeTrailingPathDelimiter(const s: string): String;
begin
  Try
    Try
      Result := SysUtils.IncludeTrailingPathDelimiter(s);

    Except
      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;

function TAPI_File.Delete(const aFilename: String): Boolean;
begin
   Try
    Try
      TFile.Delete(aFilename);

      Result := True;
    Except
      Result := False;

      oAPI_Output.InternalError;
    End;
  Finally

  End;
end;


function TAPI_File.Move(const aSourceFilename: String; const aDestFilename: String): Boolean;
begin
  Try
    Try
      TFile.Move(aSourceFilename,aDestFilename);

      Result := true;
    Except
      Result := False;

      oAPI_Output.InternalError;
    End;
  Finally

  End;



end;

end.
