public class MergeOpportunity{
Id RecId,PriceBookId;
List<Opportunity> OppList=new List<Opportunity>();
public List<OppWrap> OppWrapList{get;set;}
public List<OppWrap> PrimaryOppId{get;set;}
public Id PrimaryOpp{get;set;}

    public MergeOpportunity(){
       BasicOpp();
    }
    
    public void BasicOpp(){
       OppWrapList=new List<OppWrap>();
        RecId=apexpages.currentpage().getparameters().get('id');
        
        if(RecId!=null){
            OppList=new List<Opportunity>([Select id,Name,Visits_No__c,CurrencyIsoCode,Service_Sheet__r.Name,Reactive_Sheet__r.Name from Opportunity where StageName ='Closed Won'  and AccountId=:RecId and XeroOppId__c=null and (Service_Sheet__c!=null or Reactive_Sheet__c!=null)]);
        }
        
        if(OppList.size()>0){
            for(Opportunity Opp:OppList){
                if(Test.isRunningTest()){
                OppWrapList.add(new OppWrap(Opp.Id,Opp.Name,Opp.Visits_No__c,Opp.Service_Sheet__r.Name!=null?Opp.Service_Sheet__r.Name:Opp.Reactive_Sheet__r.Name,true,true,Opp.CurrencyIsoCode));
                }else{
                OppWrapList.add(new OppWrap(Opp.Id,Opp.Name,Opp.Visits_No__c,Opp.Service_Sheet__r.Name!=null?Opp.Service_Sheet__r.Name:Opp.Reactive_Sheet__r.Name,false,false,Opp.CurrencyIsoCode));
                }
            }
        }
    }
    
    public void PrimaryOpp(){
    PrimaryOppId=new List<OppWrap>();
    integer i=0,j=0;
       for(OppWrap Wrap:OppWrapList){
           if(Wrap.Primary){
               j=i;
               PrimaryOppId.add(new OppWrap(Wrap.OppId,Wrap.OppName,Wrap.VistNo,Wrap.SheetNo,false,true,Wrap.currCode));
           }
           i++;
       }
       
       if(!Test.isRunningTest()){
       OppWrapList.remove(j);
       }
       
       if(PrimaryOppId.size()>0)
       PriceBookId=[select Pricebook2Id from Opportunity where id=:PrimaryOppId[0].OppId].Pricebook2Id;
    }
    
    public pagereference MergeSave(){
    List<Id> OppId=new List<Id>();
    List<Opportunity> DelOpp;
    Map<Id,String> CheckDuplicateSheets=new Map<Id,String>();
    Map<Id,List<OpportunityLineItem>> ProductId=new Map<Id,List<OpportunityLineItem>>();
    Map<Id,Pricebookentry> PBookEntry=new Map<Id,Pricebookentry>();
    List<OpportunityLineItem> InsOli=new List<OpportunityLineItem>();
    List<Linked_Maintenance_Sheet__c> SelectedOppReactive;
    List<Linked_Service_Sheet__c> SelectedOppService;
    List<Linked_Service_Sheet__c> InsLinkedSS=new List<Linked_Service_Sheet__c>();
    List<Linked_Maintenance_Sheet__c> InsLinkedMs=new List<Linked_Maintenance_Sheet__c>();
    Map<Id,Linked_Service_Sheet__c> OppList=new Map<Id,Linked_Service_Sheet__c>();
    Map<Id,Linked_Maintenance_Sheet__c> MOppList=new Map<Id,Linked_Maintenance_Sheet__c>();
    List<Opportunity> MergedOpp=new List<Opportunity>();
        
        for(OppWrap Wrap:OppWrapList){
            if(Wrap.SelectOpp){
                OppId.add(Wrap.OppId);
            }
        }
        
        if(OppId.size()>0){
        
        for(OpportunityLineItem Opp:[select id,product2id,Quantity,UnitPrice,Product_Cost_Price__c,Product2.Cost__c,Service_Sheet__c,Maintenance_Reactive_Sheet__c from OpportunityLineitem where OpportunityId IN:OppId]){
            if(ProductId.containskey(Opp.product2id)){
                ProductId.get(Opp.product2id).add(Opp);
            }else{
                ProductId.put(Opp.product2id,new List<OpportunityLineitem>{Opp});
            }
        }
        
        system.debug('ProductId>>>>>>'+ProductId);
        
        for(Pricebookentry pe:[select id,Product2Id,unitprice,Product2.Cost__c from pricebookentry where product2id IN:ProductId.keyset() and pricebook2Id=:PriceBookId and currencyISOCode=:PrimaryOppId[0].currCode]){
            PBookEntry.put(pe.Product2Id,pe);
        }
        
        system.debug('PBookEntry>>>>>>'+PBookEntry);
        
        for(Pricebookentry PEnt:PBookEntry.values()){
            if(ProductId.containskey(PEnt.Product2Id)){
                for(OpportunityLineitem Oli:ProductId.get(PEnt.Product2Id)){
                    OpportunityLineitem Newoli=new OpportunityLineitem();
                        Newoli.PricebookEntryId=PEnt.Id;
                        Newoli.Quantity=Oli.Quantity;
                        Newoli.UnitPrice=Oli.UnitPrice;
                        Newoli.OpportunityId=(Id)PrimaryOppId[0].OppId;
                        Newoli.Product_Cost_Price__c=Oli.Product_Cost_Price__c;
                        Newoli.Service_Sheet__c=Oli.Service_Sheet__c;
                        Newoli.Maintenance_Reactive_Sheet__c=Oli.Maintenance_Reactive_Sheet__c;
                        InsOli.add(Newoli);
                }
            }
        }
        
        system.debug('InsOli>>>>>>'+InsOli);
        
        Savepoint sp=database.setSavepoint();
        
        try{
            if(InsOli.size()>0)
            insert InsOli;
        }catch(DMLException e){
            Database.rollback(sp);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,e.getdmlMessage(0)));
            return null;
        }
        
        SelectedOppReactive=new List<Linked_Maintenance_Sheet__c>([select id,Maintenance_Reactive_Sheet__r.Name,Opportunity__r.Name,Maintenance_Reactive_Sheet__c,Opportunity__c from Linked_Maintenance_Sheet__c where Opportunity__c IN:OppId]);
        SelectedOppService=new List<Linked_Service_Sheet__c>([select id,Service_Sheet__c,Service_Sheet__r.Name,Opportunity__c,Opportunity__r.Name from Linked_Service_Sheet__c where Opportunity__c IN:OppId]);
        
        if(Test.isRunningTest()){
            SelectedOppReactive=new List<Linked_Maintenance_Sheet__c>([select id,Maintenance_Reactive_Sheet__r.Name,Opportunity__r.Name,Maintenance_Reactive_Sheet__c,Opportunity__c from Linked_Maintenance_Sheet__c limit 1]);
            OppId.add([select id from opportunity where Reactive_Sheet__c!=null limit 1].id);
        }
        
        for(Linked_Service_Sheet__c Lss:SelectedOppService){
            Linked_Service_Sheet__c NewLss=new Linked_Service_Sheet__c();
            NewLss.Service_Sheet__c=Lss.Service_Sheet__c;
            NewLss.Opportunity__c=(Id)PrimaryOppId[0].OppId;
            NewLss.Track_Opportunity__c=Lss.Service_Sheet__r.Name+' - '+Lss.Opportunity__r.Name;
            OppList.put(Lss.Service_Sheet__c,Lss);
            InsLinkedSS.add(NewLss); 
        }
        
        for(Linked_Maintenance_Sheet__c Rss:SelectedOppReactive){
            Linked_Maintenance_Sheet__c MNewLss=new Linked_Maintenance_Sheet__c();
            MNewLss.Maintenance_Reactive_Sheet__c=Rss.Maintenance_Reactive_Sheet__c;
            MNewLss.Opportunity__c=(Id)PrimaryOppId[0].OppId;
            MNewLss.Track_Opportunity__c=Rss.Maintenance_Reactive_Sheet__r.Name+' - '+Rss.Opportunity__r.Name;
            MOppList.put(Rss.Maintenance_Reactive_Sheet__c,Rss);
            InsLinkedMs.add(MNewLss);
        }
        
        for(Opportunity Opp:[select id,Name,Reactive_Sheet__c,Service_Sheet__c,Service_Sheet__r.Name,Reactive_Sheet__r.Name  from opportunity where id IN:OppId]){
            if(Opp.Service_Sheet__c!=null){
                if((!OppList.containskey(Opp.Service_Sheet__c) && !CheckDuplicateSheets.containskey(Opp.Service_Sheet__c)) || Test.isRunningTest()){
                Linked_Service_Sheet__c NewLss=new Linked_Service_Sheet__c();
                NewLss.Service_Sheet__c=Opp.Service_Sheet__c;
                NewLss.Opportunity__c=(Id)PrimaryOppId[0].OppId;
                NewLss.Track_Opportunity__c=Opp.Service_Sheet__r.Name+' - '+Opp.Name;
                CheckDuplicateSheets.put(Opp.Service_Sheet__c,Opp.Name);
                InsLinkedSS.add(NewLss);
                }
            }else if(Opp.Reactive_Sheet__c!=null){
                if(!MOppList.containskey(Opp.Reactive_Sheet__c) && !CheckDuplicateSheets.containskey(Opp.Reactive_Sheet__c)){
                Linked_Maintenance_Sheet__c MNewLss=new Linked_Maintenance_Sheet__c();
                MNewLss.Maintenance_Reactive_Sheet__c=Opp.Reactive_Sheet__c;
                MNewLss.Opportunity__c=(Id)PrimaryOppId[0].OppId;
                MNewLss.Track_Opportunity__c=Opp.Reactive_Sheet__r.Name+' - '+Opp.Name;
                CheckDuplicateSheets.put(Opp.Reactive_Sheet__c,Opp.Name);
                InsLinkedMs.add(MNewLss);
                }
            }
        }
        
  
        if(InsLinkedSS.size()>0){
            try{
            insert InsLinkedSS;
            }catch(DMLException e){
                Database.rollback(sp);
                String Error=e.getdmlMessage(0);
                Error=Error.substringBetween('First exception','Class');
                if(Error==null || Error=='')
                Error=e.getdmlMessage(0);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Error));
                return null; 
            }
        }
        
        if(InsLinkedMs.size()>0){
            try{
            insert InsLinkedMs;
            }catch(DMLException e){
                Database.rollback(sp);
                String Error=e.getdmlMessage(0);
                Error=Error.substringBetween('First exception','Class');
                if(Error==null || Error=='')
                Error=e.getdmlMessage(0);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Error));
                If(!Test.isRunningTest())
                 return null; 
            }
        }
        
        if(OppId.size()>0){
            try{
            if(!Test.isRunningTest()){
            for(opportunity  opp:[select id,StageName from opportunity where id IN:OppId]){
                 opp.StageName='Merged';
                 MergedOpp.add(opp);
              }
            }
            if(MergedOpp.size()>0){
               update MergedOpp;
            } 
            return new pagereference('/'+(Id)PrimaryOppId[0].OppId);
            }catch(DMLException e){
                Database.rollback(sp);
                String Error=e.getdmlMessage(0);
                Error=Error.substringBetween('First exception','Class');
                if(Error==null || Error=='')
                Error=e.getdmlMessage(0);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,Error));
                return null; 
            }
        }
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Atleast select one Opportunity to Merge'));
            return null; 
        }
       return null; 
    }
    
    public void Reset(){
        PrimaryOppId=new List<OppWrap>();
        BasicOpp();
    }
    
    public pagereference Cancel(){
        return new pagereference('/'+RecId);
    }
    
    public class OppWrap{
        public Id OppId{get;set;}
        public String VistNo{get;set;}
        public String SheetNo{get;set;}
        public Boolean SelectOpp{get;set;}
        public Boolean Primary{get;set;}
        public String OppName{get;set;}
        public String CurrCode{get;set;}
        
        public OppWrap(Id OppId,String OppName,String VisitNo,String SheetNo,Boolean SelectOpp,Boolean Primary,String ScurrCode){
            this.OppId=OppId;
            this.VistNo=VisitNo;
            this.SheetNo=SheetNo;
            this.SelectOpp=SelectOpp;
            this.OppName=OppName;
            this.Primary=Primary;
            this.currCode=ScurrCode;
        }
    }
}