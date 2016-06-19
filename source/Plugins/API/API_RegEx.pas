unit API_RegEx;

interface

uses APIBase, SysUtils, MessagesLog, Classes, RegularExpressions;

type
   TAPI_RegEx = class(TAPIBase)
   private
   protected
   public
     constructor Create(aMessagesLog: tMessagesLog); override;
     destructor Destroy; override;

     function Match(aRegEx: String; aText: String;var aMatching: String): boolean;
   end;

implementation

uses System.IOUtils;

constructor TAPI_RegEx.create(aMessagesLog: tMessagesLog);
begin
  Inherited create(aMessagesLog);
end;

destructor TAPI_RegEx.destroy;
begin
end;

function TAPI_RegEx.Match(aRegEx: String; aText: String;var aMatching: String): boolean;
Var
  FRegularExpression : TRegEx;
  FMatch : TMatch;
begin
   Try
    Try
      aMatching := '';

      FRegularExpression.Create(aRegEx);
      FMatch := FRegularExpression.Match(aText);

      Result := FMatch.Success;

      if Result then
         aMatching := FMatch.Value;
    Except
      oMessagesLog.InternalError;
    End;
  Finally
  End;
end;

end.
