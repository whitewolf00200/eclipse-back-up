public class ServiceController{
      public String TechSign{get;set;} 
      public ID sheetid;
      public Engineer_Checklist__c ss{get;set;}
      public Service_Sheet_STD__c rs{get;set;}
      public Boolean sign{get;set;}
      public ID getsheetid(){ return sheetid; }
      public String Sheettype{get;set;}
      public void setsheetid(ID s){
        sheetid = s;
        ServiceController();
    } 
    
     Public void ServiceController(){
       
            
     try{
          Sheettype=ApexPages.currentPage().getParameters().get('Type');
          system.debug('Sheettype==========='+Sheettype);
          system.debug('sheetid ====='+sheetid );
                     sheetid = ApexPages.currentPage().getParameters().get('id');
          system.debug('sheetid ====='+sheetid );

             ss=[Select id,name,Engineer__r.Signature__c from Engineer_Checklist__c  where id=:sheetid ];
             system.debug('ss======='+ss.Engineer__r.Signature__c);
             if(ss.Engineer__r.Signature__c!=null || !test.isRunningTest()){
                TechSign=ss.Engineer__r.Signature__c.subStringBetween(ss.Engineer__r.Signature__c.contains('src') ? 'src="' : 'href="','"').replaceAll('&amp;','&');
                sign=true;
                system.debug('TechSign======'+TechSign+'>>>>sign====='+sign);
              }
               else{ 
                 sign=false;
                 system.debug('sign====='+sign);
                }
           
                  
         }
         Catch(Exception e){
          system.debug('Problem in gettin image'+ e);
         }  
   }     	

    }