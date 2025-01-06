trigger NewTaskOnOpp on Opportunity (after Insert){

List<Task> tasks = new List<Task>();
    for(opportunity opp : Trigger.New){
        Task t = new Task(
        
		Subject = 'New Task assigned by trigger2',
        WhatId = opp.Id,
        Status = 'Not Started'
        );
		tasks.add(t);
    }    
    insert tasks;
} 