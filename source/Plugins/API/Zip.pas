unit Zip;

interface

uses Classes;

type
   TZip = class(TPersistent)
   private
   protected
   public
     function ZipCompress: Boolean;
     function ZipExtractAll;
   end;


implementation

function TZip.ZipCompress;
begin
  Result := False;
end;

function TZip.ZipExtractAll;
begin
  Result := False;
end;


end.
