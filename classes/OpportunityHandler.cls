public class OpportunityHandler {
     RecordType oppRecId=[SELECT Id FROM RecordType WHERE DeveloperName = 'To_Invoice' limit 1];     
     Id toInvoiceOpp=oppRecId.id;
     public void AfterUpdate(Map<id,Opportunity> newMap,Map<id,Opportunity> oldMap){
        ShowDescUpdate(newMap,oldMap);     
        
           insertInvTransaction(newMap,oldMap);       
        
           deleteInvTransaction(newMap,oldMap);
     }
    
    public void AfterInsert(Map<id,Opportunity> newMap){
        InsertOli(newMap);
        UpdateOppStatus(newMap);
        
        
    }
    
    public void BeforeInsert(List<Opportunity> NewList){
        PricebookUpdate(NewList);
        InsertAutoNumber(NewList);
    }
    
    /*==============================================================================
Method Name: UpdateOppStatus
Description: Update Opportunity status as moved to invoice
Created date: 31.10.17
================================================================================*/    
   public void UpdateOppStatus(Map<Id,Opportunity> newMap){
    List<Id> salesid=new List<Id>();
    List<Id> oppid=new List<Id>();
    List<Opportunity> opplist=new List<Opportunity>();
      
      for(Opportunity opp:newMap.values()){
         if(opp.Sales_Order__c!=null){
           salesid.add( opp.Sales_Order__c);
         }
      }
      if(salesid.size()>0){
          for(SalesOrder__c so:[Select id,Opportunity__c from SalesOrder__c where id IN:salesid]){
             oppid.add(so.Opportunity__c );
          }
       }
       if(oppid.size()>0){   
          for(Opportunity opp:[Select id,Sales_Order__c,StageName from opportunity where id IN:oppid]){
              opp.StageName='Moved to Invoice';
              opplist.add(opp);
              system.debug('opplist======='+opplist);
          }
       }
      
       if(opplist.size()>0){
         update opplist;
       }
      
   }
    
   /*  =================================================
   Method Name:InsertAutoNumber
   Description:Insert custom auto number based on record type
   Created date:22.07.17
   ===================================================== */ 
     public void InsertAutoNumber(List<Opportunity> NewList){
         Decimal c=0,d=0;
        Id InvoiceRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (To Invoice)').getRecordTypeId();
        Id SheetsRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Invoice (Sheets)').getRecordTypeId();
        Id SalesRecTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Sales').getRecordTypeId();
        list<opportunity> ll=[select id,InvNumber__c,Invoice_Number__c from opportunity where recordtypeid=: SalesRecTypeId and InvNumber__c!=null order by CreatedDate desc limit 1];
        list<opportunity> lo=[select id,InvNumber__c,Invoice_Number__c from opportunity where (recordtypeid=: InvoiceRecTypeId or recordtypeid=: SheetsRecTypeId) and InvNumber__c!=null order by CreatedDate desc limit 1];
        
        if(lo.size()>0)
            c=lo[0].InvNumber__c;
        else c=-1;
    
        if(ll.size()>0)
            d=ll[0].InvNumber__c;
        else d=-1;  
    
            system.debug('c>>>'+c);
            system.debug('d>>>'+d);
    
        for(Opportunity op:NewList)
        {
          if(c!=null)
          {
          if(op.recordTypeID==InvoiceRecTypeId || op.recordTypeID==SheetsRecTypeId)
          {
           c=c+1;
               op.InvNumber__c=c;
           if(c<10)
               op.Invoice_Number__c='INV - 0000'+string.valueof(c);
           else if(c<100)
               op.Invoice_Number__c='INV - 000'+string.valueof(c);
           else if(c<1000)
               op.Invoice_Number__c='INV - 00'+string.valueof(c);
           else if(c<10000)
               op.Invoice_Number__c='INV - 0'+string.valueof(c);
           else if(c<100000)
               op.Invoice_Number__c='INV - '+string.valueof(c);
               system.debug('op.InvNumber__c>>>'+op.InvNumber__c);
          }
          }
          
          if(d!=null)
          {
              if(op.recordTypeID==SalesRecTypeId)
              {
                   d=d+1;
                   op.InvNumber__c=d;
                   if(d<10)
                       op.Invoice_Number__c='0000'+string.valueof(d);
                   else if(d<100)
                       op.Invoice_Number__c='000'+string.valueof(d);
                   else if(d<1000)
                       op.Invoice_Number__c='00'+string.valueof(d);
                   else if(d<10000)
                       op.Invoice_Number__c='0'+string.valueof(d);
                   else if(d<100000)
                       op.Invoice_Number__c=string.valueof(d);
                       system.debug('op.InvNumber__c>>>'+op.InvNumber__c);
              }    
          }
        } 
 }  
    
/*==============================================================================
Method Name: ShowDescUpdate
Description: Update Show Description based on Parent Show Descripton Field
Created date: 14-07-2017
================================================================================*/

public void ShowDescUpdate(Map<id,Opportunity> newMap,Map<id,Opportunity> oldMap){
List<Id> OppIds=new List<Id>();
List<OpportunityLineItem > UpdateOli=new List<OpportunityLineItem >();
       
    for(Opportunity opp:newMap.values()){
          if(opp.Show_Description__c!=oldMap.get(opp.id).Show_Description__c){
              OppIds.add(opp.id);
          }
    }
    
    if(OppIds.size()>0){
        for(OpportunityLineItem  Oli:[Select id,Show_Description__c,Opportunity.Show_Description__c,OpportunityId from OpportunityLineItem where OpportunityId IN:OppIds]){
            Oli.Show_Description__c=Oli.Opportunity.Show_Description__c;
            UpdateOli.add(Oli);
        }
    }      
    
    if(UpdateOli.size()>0){
       update UpdateOli;
    }  
}

/*==============================================================================
Method Name: InsertOli
Description: Insert Opportunity Line Item when select sales order
Created date: 14-07-2017
================================================================================*/    
public void InsertOli(Map<id,Opportunity> newMap){
List<Id> SaleIds=new List<Id>();
List<Id> Pricebookids=new List<Id>();
List<Id> ProductIds=new List<Id>();
List<String> CurrencyCode=new List<String>();
Map<String,Map<Id,Pricebookentry>> PeEntry=new Map<String,Map<Id,Pricebookentry>>();
Map<Id,List<SalesOrderLineItems__c>> SalesOliMap=new Map<Id,List<SalesOrderLineItems__c>>();
List<OpportunityLineItem> NewOli=new List<OpportunityLineItem>();
Map<Id,Pricebookentry> InnerMap=new Map<Id,Pricebookentry>();
String Comp;
Warehouse__c wh=[Select id,name from Warehouse__c where default__c=true limit 1];

    for(Opportunity Opp:newMap.values()){
        if(Opp.Sales_Order__c!=null){
            SaleIds.add(Opp.Sales_Order__c);
            Pricebookids.add(opp.Pricebook2Id);
            CurrencyCode.add(opp.CurrencyIsoCode);
        }
    }
    
    if(SaleIds.size()>0){
        for(SalesOrderLineItems__c SalesOli:[select id,Product__r.Sales_Description__c,Product__r.Extended_Sales_Description__c,Sales_Order__c,Quantity__c,Sales_Description__c,Extended_Sales_Description__c,Product__c,Price__c from SalesOrderLineItems__c where Sales_Order__c IN:SaleIds]){
            if(SalesOliMap.containskey(SalesOli.Sales_Order__c)){
                SalesOliMap.get(SalesOli.Sales_Order__c).add(SalesOli);
                ProductIds.add(SalesOli.Product__c);
            }else{
                SalesOliMap.put(SalesOli.Sales_Order__c,new List<SalesOrderLineItems__c>{SalesOli});
                ProductIds.add(SalesOli.Product__c);
            }
        }
    }
    
    if(ProductIds.size()>0 && Pricebookids.size()>0){
        for(Pricebookentry Pe:[select id,Unitprice,Product2id,CurrencyIsoCode,pricebook2id from pricebookentry where product2id IN:ProductIds and Pricebook2Id IN:PricebookIds and CurrencyIsoCode IN:CurrencyCode]){
            Comp=pe.CurrencyIsoCode+String.valueof(Pe.pricebook2Id);
            if(PeEntry.containskey(Comp)){
                PeEntry.get(Comp).put(Pe.product2id,pe);
            }else{
                PeEntry.put(Comp, new Map<Id,Pricebookentry>{Pe.product2id =>pe});
            }
        }
    }
    
    for(Opportunity Opp:newMap.values()){
        Comp=Opp.CurrencyIsoCode+String.valueof(Opp.Pricebook2Id);
        InnerMap=new Map<Id,Pricebookentry>();
        InnerMap=PeEntry.get(Comp);
        system.debug('InnerMap============'+InnerMap);
        if(Opp.Sales_Order__c!=null && SalesOliMap.containskey(Opp.Sales_Order__c)){
            for(SalesOrderLineItems__c SalesOli:SalesOliMap.get(Opp.Sales_Order__c)){
            system.debug('SalesOli============'+SalesOli);
                if(InnerMap.size()>0 && InnerMap.containskey(SalesOli.Product__c)){
                    OpportunityLineItem OppnewOli=new OpportunityLineItem();
                    OppnewOli.OpportunityId=Opp.id;
                    OppnewOli.Extended_Sales_Description__c=SalesOli.Extended_Sales_Description__c!=null?SalesOli.Extended_Sales_Description__c:SalesOli.Product__r.Extended_Sales_Description__c;
                    OppnewOli.SalesDescription__c=SalesOli.Sales_Description__c!=null?SalesOli.Sales_Description__c:SalesOli.Product__r.Sales_Description__c;
                    OppnewOli.UnitPrice=SalesOli.Price__c!=null?SalesOli.Price__c:0;
                    OppnewOli.Quantity=SalesOli.Quantity__c;
                    OppnewOli.Pricebookentryid=InnerMap.get(SalesOli.Product__c).id;
                    OppnewOli.warehouse__c=wh.id;
                    system.debug('OppnewOli.Pricebookentryid================'+OppnewOli.Pricebookentryid);
                    NewOli.add(OppnewOli);
                }
            }
        }
    }
    
    if(NewOli.size()>0){
        insert NewOli;
    }
}

/*==============================================================================
Method Name: PricebookUpdate
Description: Update Opportunity Pricebook for selected Account
Created date: 14-07-2017
================================================================================*/    
public void PricebookUpdate(List<Opportunity> NewList){
Map<Id,Id> PriceBookIds=new Map<Id,Id>();
List<Id> AccIds=new List<Id>();

    for(Opportunity opp:NewList){
     system.debug('NewList>>>>>'+NewList);
        if(opp.AccountId!=null && opp.Service_Sheet__c==null && opp.Reactive_Sheet__c==null && !opp.isClone()){
            AccIds.add(opp.AccountId);
             system.debug('AccIds>>>>>'+AccIds);
        }
       
    }
    
    if(AccIds.size()>0){
        for(Account Acc:[select id,Price_Book__c from Account where id IN:AccIds and Price_Book__c!=null]){
            PriceBookIds.put(Acc.Id,Acc.Price_Book__c);
            system.debug('PriceBookIds>>>>>>>>'+PriceBookIds);
        }
    }
    
    for(Opportunity opp:NewList){
        if(opp.AccountId!=null && opp.Service_Sheet__c==null && opp.Reactive_Sheet__c==null && PriceBookIds.containskey(opp.AccountId) && !opp.isClone()){
            opp.Pricebook2Id=PriceBookIds.get(opp.AccountId);
            system.debug(' opp.Pricebook2Id============='+ opp.Pricebook2Id);
        }
    }
}


public void insertInvTransaction(Map<Id,Opportunity> newMap,Map<Id,Opportunity> OldMap){
        
        
         List<id> oppIds=new List<id>();
         Map<Id,OpportunityLineItem> opltmMap=new Map<Id,OpportunityLineItem>();
         Set<Id> oplProductId=new Set<Id>();
         Set<Id> oplWarehouse=new Set<Id>();
         List<Id> oplProductIdList;
         List<Id> oplWarehousList;     
         set<Inventory_Transaction__c> insertInvTran=new set<Inventory_Transaction__c>();
         list<Inventory_Transaction__c> insertInvTranlist=new list<Inventory_Transaction__c>();     
         Map<id,Inventory__c> availableInvOplMap=new Map<Id,Inventory__c>();  
         Map<id,Inventory__c> nonAvailableInvOplMap=new Map<Id,Inventory__c>();
         for(Opportunity op:NewMap.values()){
            if(op.StageName!=OldMap.get(op.id).StageName && op.StageName=='Sent' && op.RecordTypeid==toInvoiceOpp){
               oppIds.add(op.id);
             }
            
        }
           if(oppIds.size()>0){
                for(OpportunityLineItem opl:[Select Id,name,Product2.id,OpportunityId,Product2.name,Quantity,Warehouse__c,Opportunity.Account.name from OpportunityLineItem where OpportunityId=:oppIds]){
                    opltmMap.put(opl.id,opl);
                    oplProductId.add(opl.product2.id);
                    oplWarehouse.add(opl.Warehouse__c);                   
                }   
                oplProductIdList=new List<Id>(oplProductId);
                oplWarehousList=new List<Id>(oplWarehouse);
                           
                
            }
            SYSTEM.DEBUG('---oldmap-keyset--'+opltmMap.keyset());
            SYSTEM.DEBUG('---oldmap-keyset--'+opltmMap.values());
            
            if(opltmMap.size()>0){
                    for(Inventory__c inv:[Select id,name,Product__c,Warehouse__c from Inventory__c where Product__c=:oplProductIdList and Warehouse__c =:oplWarehousList]){
                        For(OpportunityLineItem opl:opltmMap.values()){
                               system.debug(inv);
                               system.debug(opl);
                           if(opl.product2.id==inv.Product__c && opl.Warehouse__c==inv.Warehouse__c){
                               Inventory_Transaction__c invTrans=new Inventory_Transaction__c();
                               invTrans.name=inv.name;
                               invTrans.Inventory__c=inv.id;
                               invTrans.Qty__c=opl.Quantity;
                               invTrans.OpportunityLineItemId__c=opl.id;
                               invTrans.Opportunity_Product_Name__c=opl.product2.Name;
                               invTrans.Transaction_Type__c='Delivered';
                               invTrans.Who_Bought__c=opl.opportunity.Account.Name;
                               invTrans.Items__c=opl.Product2.Id;
                               insertInvTran.add(invTrans);                          
                               availableInvOplMap.put(opl.id,inv);
                               
                           }
                        }
                    }
                    system.debug(availableInvOplMap);
                    
                    for(OpportunityLineItem opl:opltmMap.values()){
                        if(!availableInvOplMap.containsKey(opl.id)){
                             Inventory__c inv=new Inventory__c();
                             inv.product__c=opl.Product2.id;
                             inv.Warehouse__c=opl.warehouse__c;
                             nonAvailableInvOplMap.put(opl.id,inv);
                        }
                    
                    }
                    
                    system.debug(nonAvailableInvOplMap);
                    try{
                            if(nonAvailableInvOplMap.size()>0){                               
                                insert nonAvailableInvOplMap.values();
                             }
                             for(OpportunityLineItem opl:opltmMap.values()){
                                  system.debug(nonAvailableInvOplMap.values());
                                 if(nonAvailableInvOplMap.containsKey(opl.id)){                                 
                                   
                                   Inventory_Transaction__c invTrans=new Inventory_Transaction__c();
                                   invTrans.name=nonAvailableInvOplMap.get(opl.id).name;
                                   invTrans.Inventory__c=nonAvailableInvOplMap.get(opl.id).id;
                                   invTrans.Qty__c=opl.Quantity;
                                   invTrans.OpportunityLineItemId__c=opl.id;
                                   invTrans.Opportunity_Product_Name__c=opl.product2.Name;
                                   invTrans.Transaction_Type__c='Delivered';
                                   invTrans.Who_Bought__c=opl.opportunity.Account.Name;
                                   invTrans.Items__c=opl.Product2.Id;
                                   insertInvTran.add(invTrans);                          
                                   
                                 
                                 }
                             }
                             
                             if(insertInvTran.size()>0){
                             
                             insertInvTranlist.addall(insertInvTran);
                                 insert insertInvTranlist;
                             
                                 
                             }
                     }
                     catch(Exception e){
                        System.debug(e);
                     }
                     
             }
        
            
         
        
        
    }//method
    
    
    public void deleteInvTransaction(Map<Id,Opportunity> NewMap,Map<Id,Opportunity> oldMap){
       List<Inventory_Transaction__c> deleteTrans=new List<Inventory_Transaction__c>(); 
        List<Id> listPartsId=new List<Id>();
        List<Id> WarehouseId=new List<Id>();
        List<Id> opIds=new List<Id>();
        
        for(Opportunity op:NewMap.values()){            
            if(op.StageName!=OldMap.get(op.id).StageName && OldMap.get(op.id).StageName=='Sent' && op.RecordTypeid==toInvoiceOpp){
              opIds.add(op.id);
                           
            }
        }
        
        if(opIds.size()>0){
               for(OpportunityLineItem opl:[Select Id,name,Product2.id,Warehouse__c from OpportunityLineItem  where OpportunityId=:opIds]){
                         listPartsId.add(opl.id);
                         WarehouseId.add(opl.warehouse__c);
               }
       }
              if(listPartsId.size()>0){
                  for(Inventory_Transaction__c invTrans:[Select id,name,OpportunityLineItemId__c,Inventory__c,Inventory__r.Warehouse__c from Inventory_Transaction__c  where OpportunityLineItemId__c=:listPartsId and Inventory__r.Warehouse__c=:WarehouseId]){
                    deleteTrans.add(invTrans);
                  }
              }
              
              
          Try{
             if(deleteTrans.size()>0)
              Delete deleteTrans;
              
           }
           Catch(Exception e){
              for(Opportunity opp:newMap.values()){
                   Opp.addError(e.getMessage());
              }
           
          }
    }

    
 /*==============================================================================
Method Name: opportunity rollup
Description: Update Opportunity invoice amount for selected Account
Created date: 21-09-2022
================================================================================   
public void UpdateAfter(Map<Id,Opportunity> NewMap,Map<Id,Opportunity> oldMap){
    System.debug('inside method');  
    
   list<Opportunity> opplst = [SELECT Id,name,StageName,Invoice_Date__c,Total_Sales_Price__c  from opportunity where Invoice_Date__c = LAST_N_MONTHS:12];
                  
          Set<Id> accIds = New Set<Id>();
                       Double Amount;   
              for(Opportunity opp : NewMap.values()){
            if(  opp.Total_Sales_Price__c != null && opp.Total_Sales_Price__c !=  oldMap.get(opp.Id).Total_Sales_Price__c && opp.StageName == 'Closed Won' || opp.StageName == 'Sent' )
            {                    
                accIds.add(opp.AccountId);
                 
                Amount = opp.Total_Sales_Price__c;
                
                system.debug('Amount'+Amount);
            }       
              }   
            List<Account> acctList = New List<Account>();
            list<Account> acct = New list<Account>();
            acctList  = [SELECT id,invoice_12_Month_total__c from Account where id =:accIds];  
                  for(Account acc :acctList)
                  {
                    system.debug('acc.invoice_12_Month_total__c'+acc.invoice_12_Month_total__c);
                          acc.invoice_12_Month_total__c += Amount;
                          acct.add(acc); 
                      system.debug('Amount'+Amount);
                    
                  } 
                 if(acct.size() > 0 ){
                       update acct;
                     system.debug('acct'+acct);
                  }
}
   // isdelete after update===========>  
     
    
 public void UpdateAfterdel(Map<Id,Opportunity> oldMap){       
    list<Opportunity> oppdel = [SELECT Id,name,StageName,Invoice_Date__c,Total_Sales_Price__c from opportunity where Invoice_Date__c = LAST_N_MONTHS:12];
                  
          Set<Id> accdel = New Set<Id>();
                       Double Amountdel;   
              for(Opportunity opp : oldMap.values()){
            if(opp.Total_Sales_Price__c != Null)
            {                    
                accdel.add(opp.AccountId);
                Amountdel =opp.Total_Sales_Price__c;
                system.debug('Amountdel'+Amountdel);
            }       
              }   
            List<Account> acctListdel = New List<Account>();
            list<Account> acctdel = New list<Account>();
            acctListdel  = [SELECT id,invoice_12_Month_total__c from Account where id =:accdel];  
               //  List<Opportunity Product> opptprd =  New list<Opportunity Product>();
                 //  opptprd = [Select id,Discount__c from Opportunity Product];
                
             for(Account acc :acctListdel)
                  {
                          system.debug('acc.invoice_12_Month_total__c'+acc.invoice_12_Month_total__c);
                          acc.invoice_12_Month_total__c =  acc.invoice_12_Month_total__c - Amountdel;
                          acctdel.add(acc);
                      
                  } 
                 if(acctdel.size() > 0 ){
                       update acctdel;
                     system.debug('acctdel'+acctdel);
                  }
    
    
  }  */
}