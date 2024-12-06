trigger SupplierProduct on SupplierProduct__c (after insert,after Update) {
      
       SupplierProductHanndler sph=new SupplierProductHanndler();
       
          if (trigger.isAfter && trigger.isInsert){
          
            sph.OnAfterInsert(Trigger.newmap);
       
       }   
       
        if (trigger.isAfter && trigger.isUpdate){
          
            sph.OnAfterUpdate(Trigger.newmap,Trigger.OldMap);
       
       }   
    
    }