trigger OpportunityTrigger on Opportunity (after insert,After update,before insert,after delete) {
    
    OpportunityHandler  handle=new OpportunityHandler ();
    
    if(Trigger.isAfter && Trigger.isinsert){
        handle.AfterInsert(Trigger.NewMap);
        
    }
    
    if(Trigger.isBefore && Trigger.isinsert){
        handle.BeforeInsert(Trigger.New);
    }
    
    if(Trigger.isAfter && Trigger.isupdate){
        handle.AfterUpdate(Trigger.NewMap,Trigger.OldMap);
       // handle.UpdateAfter(Trigger.NewMap,Trigger.OldMap);
    }
    
  /* if(Trigger.isAfter && Trigger.isdelete){
        handle.UpdateAfterdel(Trigger.OldMap);
   }*/
}