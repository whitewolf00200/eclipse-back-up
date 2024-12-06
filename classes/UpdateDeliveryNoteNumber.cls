public class UpdateDeliveryNoteNumber{

    public ID Delnoteid;
    public Delivery_Note__c note{get;set;}
    public SalesOrder__c salesorder{get;set;}
    public String delnumber{get;set;}
    public String delname{get;set;}
    public String QuoteNo{get;set;}
    public Opportunity opp;
    public List<OpportunityLineitem> Oli{get;set;}  
    public List<OpportunityLineitem> Olii{get;set;}  
    public String[] SheetNo{get;set;}
    public List<Wrapp> Wlist{get;set;}
    public Boolean sheeton{get;set;}
    public Boolean Nosheet{get;set;}
    public String PriSheet{get;set;}
    public String Asset{get;set;}
    public Date Service{get;set;}
    public set<String>Prijoin{get;set;}
    public Boolean Primatch{get;set;}
    


    public ID getDelnoteid()
    {
    system.debug('getDelnoteid==========='+Delnoteid);
    return Delnoteid;
    
    }
    
    public void setDelnoteid(ID Delnoteids){
        if(Delnoteids != null){
            Delnoteid = Delnoteids;
            system.debug('setDelnoteid==========='+Delnoteid);
            UpdateOppDelNoteNumber();
            load();
         }
    }

    public void UpdateOppDelNoteNumber(){
        try{
            note = [select id,name,Delivery_Note_Number__c,createddate,Opportunity__c from Delivery_Note__c where Opportunity__c =:Delnoteid order by createddate desc limit 1];
            if(note.Opportunity__c != Null){
                delname = note.name;
                delnumber = note.Delivery_Note_Number__c;
            }
        }catch(Exception e){}
        
        
        
        try{
            if(Delnoteid!= Null){
                QuoteNo=[select QuoteNumber from Quote where OpportunityId=:Delnoteid order by createddate desc limit 1].QuoteNumber;   
            }
        }catch(Exception e){}
        
    }
    
    public void load() {
    sheeton=false;
    Nosheet=false;
    Primatch=false;   
    
    OpportunityLineItem temp=null;
    Oli=new List<OpportunityLineitem>();
    Olii=new List<OpportunityLineitem>();
    for(OpportunityLineItem opl: [Select id,OpportunityId,vat_rate__c,Description,SalesDescription__c,Extended_Sales_Description__c,Opportunity.Reactive_Sheet__r.name,Opportunity.Service_Sheet__r.name,Opportunity.Reactive_Sheet__c,
														 Opportunity.Service_Sheet__c,Service_Sheet__r.name,Maintenance_Reactive_Sheet__r.name,Quantity,Product2.name,Maintenance_Reactive_Sheet__c,Service_Sheet__c ,Product2.Stock_Unit__c,UnitPrice,TotalPrice,Opportunity.VAT_Rate__c,Service_Sheet__r.Visit__r.Asset__r.Name,Opportunity.ModxInvoice__c,
                                                         Opportunity.Reactive_Sheet__r.Visit__r.Asset__r.Name,Opportunity.Service_Sheet__r.Visit__r.Asset__r.Name,Show_Description__c,Line_Item_Description__c,Product2Id,Product2.Extended_Sales_Description__c,Product2.Sales_Description__c,Opportunity.Service_Sheet__r.Visit__r.Actual_Service_Date__c,Opportunity.Reactive_Sheet__r.Visit__r.Actual_Service_Date__c 
                                                         From OpportunityLineitem 
                                                         Where OpportunityId =:Delnoteid order by SortOrder,Pricebookentry.product2.Name]){
        
            if(opl.Product2Id!=System.Label.Carriage){
               Oli.add(opl);
            }
            else{
              temp=opl;
            }
         
         
         system.debug('Oli=========='+Oli);      
     }  
     
     if(temp!=null){
       Oli.add(temp);
     }                                        
                                                         
   for(OpportunityLineItem opl :[Select id,OpportunityId,vat_rate__c,Description,SalesDescription__c,Extended_Sales_Description__c,Opportunity.Reactive_Sheet__r.name,Opportunity.Service_Sheet__r.name,Opportunity.Reactive_Sheet__c,
														 Opportunity.Service_Sheet__c,Service_Sheet__r.name,Maintenance_Reactive_Sheet__r.name,Quantity,Product2.name,Maintenance_Reactive_Sheet__c,Service_Sheet__c ,Product2.Stock_Unit__c,UnitPrice,TotalPrice,Opportunity.VAT_Rate__c,Service_Sheet__r.Visit__r.Asset__r.Name,Opportunity.ModxInvoice__c,
                                                         Opportunity.Reactive_Sheet__r.Visit__r.Asset__r.Name,Opportunity.Service_Sheet__r.Visit__r.Asset__r.Name,Show_Description__c,Line_Item_Description__c,Product2Id,Product2.Extended_Sales_Description__c,Product2.Sales_Description__c,Opportunity.Service_Sheet__r.Visit__r.Actual_Service_Date__c,Opportunity.Reactive_Sheet__r.Visit__r.Actual_Service_Date__c 
                                                         From OpportunityLineitem 
                                                         Where OpportunityId=:Delnoteid AND Service_Sheet__r.name=null
                                                         AND Maintenance_Reactive_Sheet__r.name=null order by SortOrder,Pricebookentry.product2.Name]){
            
         
            if(opl.Product2Id!=System.Label.Carriage){
               Olii.add(opl);
            }
            else{
              temp=opl;
            }
         
         
         system.debug('Olii=========='+Olii);                                             
                                                         
    }                                                       
          
     if(temp!=null){
       Olii.add(temp);
     } 
             
     
     if(Olii.size()>0){
     Nosheet=true;
     for(OpportunityLineitem ol:Olii)
     {
     

     if(ol.Opportunity.Reactive_Sheet__r.name!=null)
     {
     PriSheet=ol.Opportunity.Reactive_Sheet__r.name;
     
     Asset=ol.Opportunity.Reactive_Sheet__r.Visit__r.Asset__r.Name;
     Service=ol.Opportunity.Reactive_Sheet__r.Visit__r.Actual_Service_Date__c;
     
     }
      else if(ol.Opportunity.Service_Sheet__r.name!=null)
      {
      PriSheet=ol.Opportunity.Service_Sheet__r.name;
      Asset=ol.Opportunity.Service_Sheet__r.Visit__r.Asset__r.Name;
      Service=ol.Opportunity.Service_Sheet__r.Visit__r.Actual_Service_Date__c;
      
      }
     }   
     
     }
     system.debug('PriSheet=========='+PriSheet);
     system.debug('Asset========'+Asset);
     system.debug('Nosheet=========='+Nosheet);                                            
    // dynamically create set of unique Sheet no from query
    Set<String> Sheetset= new Set<String>();
    for (OpportunityLineitem o : Oli){
   
   
       if(o.Service_Sheet__c !=null){     
      Sheetset.add(o.Service_Sheet__r.name);
       }
        else if(o.Maintenance_Reactive_Sheet__c!=null){
        Sheetset.add(o.Maintenance_Reactive_Sheet__r.name);
        }
     }
       system.debug('Sheetset=========='+Sheetset);
    // convert the set into a string array  
    SheetNo= new String[Sheetset.size()];
    Integer i = 0;
    for (String sheet: Sheetset) { 
      SheetNo[i] = sheet;
      i++;
    }

    Wlist=new List<Wrapp>();
  for(Engineer_Checklist__c eng:[Select id,name,Visit__r.Actual_Service_Date__c,Visit__r.Asset__r.Name from Engineer_Checklist__c where name IN:Sheetset]){
  Wlist.add(new Wrapp(eng.name,eng.Visit__r.Asset__r.Name,eng.Visit__r.Actual_Service_Date__c));
   system.debug('Wlistserv======='+Wlist);
   sheeton=true;
   
  } 
    
    
    for(Service_Sheet_STD__c rea:[Select id,name,Visit__r.Actual_Service_Date__c,Visit__r.Asset__r.Name from Service_Sheet_STD__c  where name IN:Sheetset]){
    Wlist.add(new Wrapp(rea.name,rea.Visit__r.Asset__r.Name,rea.Visit__r.Actual_Service_Date__c));
    system.debug('Wlistreact======='+Wlist);
    sheeton=true;
    }
    system.debug('Wlist======='+Wlist);
    system.debug('sheeton=========='+sheeton);
    
    for(Wrapp wp:Wlist){
    if(wp.SNo==PriSheet){
    Primatch=true;
    }
    
    }
    system.debug('primatch======='+primatch);
  }
  public class Wrapp{
  public String SNo {get;set;}
  public String Asset{get;set;}
  public Date Servi{get;set;}
  
  public Wrapp(String SNo,String Asset,Date Servi){
  
  this.SNo=SNo ;
  this.Asset=Asset;
  this.Servi=Servi;
  
  }
  }
  
}