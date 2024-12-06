public class InvoiceDue{
    List<Account> Acc;
    List<Opportunity > opp;
    public Boolean duecheck{get;set;}
    public List<wrapper> DueOpp{get;set;}
    public String Acid;
    public InvoiceDue(ApexPages.StandardController controller) {
      Acid=  ApexPages.CurrentPage().getParameters().get('id');
      DueOpp=new List<wrapper>();
      duecheck=false;
       
       for(Account Acc: [select Name,id,Due_Days__c,(select name,Amount_Due__c,stagename,Opportunity_Number_new__c,Due_Date__c,Amount_Paid__c from Opportunities where stagename!='Cancelled' and stagename!='Merged') from Account where id=:Acid])
       {
        
         for(Opportunity opp:Acc.Opportunities){
            Date today= system.today();
            Integer numberDaysDue=0;
           if(opp.Amount_Due__c!=null && opp.Amount_Due__c!=0 && opp.Due_Date__c < system.today())
           {
                numberDaysDue = opp.Due_Date__c.daysBetween(today);
                system.debug('numberDaysDue ======='+numberDaysDue+'>>>>>>>>opp='+opp.id );
           
         
           if(numberDaysDue >= Acc.Due_Days__c){
                DueOpp.add(new wrapper(opp.Name,numberDaysDue ,opp.Amount_Due__c,opp.Opportunity_Number_new__c));
                duecheck=true;
           }
          } 
        }
      }
        
   }
     public class wrapper{
     public Integer days{get;set;}
     public String name{get;set;}
     public Decimal amount{get;set;}
     public String invno{get;set;}
     wrapper(String name,Integer days,Decimal amount,String invno){
         this.name=name;
         this.days=days;
         this.amount=amount;
         this.invno=invno;
     }
     
     }   
    
 }