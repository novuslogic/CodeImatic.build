
procedure FinishedTasks();
begin
  //output.log('Finished Tasks ...') ;

  //Task.BuildReport;
end;

procedure Test3;
begin
  output.log('Running test3 ...') ;

  RaiseException(erCustomError, 'CustomError RaiseException');
end;


procedure Test2;
begin
  output.log('Running test2 ...') ;
end;


procedure test1;
begin
  output.log('Running test1 ...') ;

end;

Var
  FTaskTest1: tTask;
  FTaskTest2: tTask;
  FTaskTest3: tTask;
begin
  output.log('Sample 8');


  FTaskTest3 := Task.AddTask('test3');
  if Not Assigned(FTaskTest3) then
    RaiseException(erCustomError, 'not assigned FTaskTest3'); 
 

  FTaskTest3.Criteria.Failed.retry := 5;
  FTaskTest3.Criteria.Failed.Skip := true;
  //FTaskTest3.Criteria.Failed.Abort := True;


  FTaskTest2 := Task.AddTask('test2');
  if Not Assigned(FTaskTest2) then
    RaiseException(erCustomError, 'not assigned FTaskTest2'); 
  FTaskTest2.IsDependentOn('test3');

  FTaskTest1 := Task.AddTask('test1');
  if Not Assigned(FTaskTest1) then
    RaiseException(erCustomError, 'not assigned FTaskTest1'); 
  FTaskTest1.IsDependentOn('test2');


  //Task.BeforeTasks  := @FinishedTasks;
  Task.FinishedTasks  := @FinishedTasks;



  if not Task.RunTarget('test1') then 
    RaiseException(erCustomError, 'missing procedure "test1" '); 
   

   


end.
