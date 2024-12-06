/*============================================================================================================
*Class Name     : AccountTriggerHandler
*Description    : All the implementations related to Opportunity Triggers should be handled here
*Company        : Puthuvannam Technology Solutions
*Date           : 23th May, 2014
*Version        : 1.0
*Change History : Initial Trigger Handler
*Methods        : public void OnAfterUpdate(Map<id,Account> accountNewMap)
                  Private void UpdateServiceContactField(map<id,Account> accMap)
                  Private void updateAccountCheckStatusField(List<Account> newList)
                 
*============================================================================================================*/

public class AccountTriggerHandler{


/*====================================================

*Method Name     : OnAfterUpdate
*Description     : Handle the after update operation
*Arguments       : new map list
====================================================*/

    public void OnAfterUpdate(Map<id,Account> accountNewMap,Map<id,Account> accountOldMap){
    system.debug('<<<accountNewMap123>>'+accountNewMap); 
        if(RecursiveHandler.runOnce()){
                //Call UpdatePriceListdate Class
                UpdatePriceListDate(accountNewMap.values(),accountOldMap);
                
            }
        if(RecursiveHandler.runACC_USCTOnce()){
             UpdateServiceContactField(accountNewMap,accountOldMap);
         }
         if(RecursiveHandler.runOnce1()){
                //Call AccountCheckStatusFile Method   
                updateAccountCheckStatusField(accountNewMap,accountOldMap);
                CurrencyType(accountNewMap,accountOldMap); 
           }  
 
    }
    public void OnBeforeInsert(List<Account> NewList){
     UpdatePriceBookBefore(NewList);
    
    }
 
    
    public void OnBeforeUpdate(Map<id,Account> NewMap,Map<id,Account> OldMap){
     UpdatePriceBook(NewMap);
    }
    

/*====================================================
*Method Name     : CurrencyType
*Description     : Update Currency type for supplier product
*Arguments       : new Map list
====================================================*/   

    Public void CurrencyType(Map<id,Account> Newmap,Map<id,Account> Oldmap){
      List<Id> accid=new List<Id>();
      List<SupplierProduct__c > sprd=new List<SupplierProduct__c >();
      for(Account acc:Newmap.values()){
        if(acc.CurrencyIsoCode!=Oldmap.get(acc.id).CurrencyIsoCode){
           accid.add(acc.id);
        }
      }
      if(accid.size()>0){
           List<SupplierProduct__c > supplier=new List<SupplierProduct__c >([Select id,CurrencyIsoCode,Supplier__c,Supplier__r.CurrencyIsoCode from SupplierProduct__c where Supplier__c IN:accid]);
          
           for(SupplierProduct__c sp:supplier){
              sp.CurrencyIsoCode=sp.Supplier__r.CurrencyIsoCode;
              sprd.add(sp);
           }
      }
      if(sprd.size()>0){
         update sprd;
      }
    }

 
/*====================================================
*Method Name     : UpdatePriceBook
*Description     : Update pricebook of Account
*Arguments       : new Map list
====================================================*/    
 
    Private void UpdatePriceBook(Map<id,Account> NewMap){
 
    for(Account ac:NewMap.values()){
    
      if(PriceBook__c.getInstance('BN Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('BN Zone D').Id__c;
       }

       else if(PriceBook__c.getInstance('AL Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('AL Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('BR Zone B').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('BR Zone B').Id__c;
       }
       
       else if(PriceBook__c.getInstance('Central London (E,EC,WC,W)').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('Central London (E,EC,WC,W)').Id__c;
       }
       
       else if(PriceBook__c.getInstance('CM Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('CM Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('CR Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('CR Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('CT Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('CT Zone C').Id__c;
       }
       
       else if (PriceBook__c.getInstance('CN Zone D').Region__c == ac.Region__c) { 
       ac.Price_Book__c = PriceBook__c.getInstance('CN Zone D').Id__c; 
        } 
       
       else if(PriceBook__c.getInstance('CO Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('CO Zone D').Id__c;
       }

       else if(PriceBook__c.getInstance('DA Zone A').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('DA Zone A').Id__c;
       }
       
       else if(PriceBook__c.getInstance('EN Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('EN Zone C').Id__c;
       }

       else if(PriceBook__c.getInstance('GU Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('GU Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('HA Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('HA Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('HP Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('HP Zone D').Id__c;
       }
       
       
       else if(PriceBook__c.getInstance('IG Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('IG Zone C').Id__c;
       }

       else if(PriceBook__c.getInstance('IP Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('IP Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('KT Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('KT Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('LU Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('LU Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('ME Zone B').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('ME Zone B').Id__c;
       }
       
       else if(PriceBook__c.getInstance('MK Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('MK Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('NL').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('NL').Id__c;
       }
       
       
       else if(PriceBook__c.getInstance('North London (NW,N,EN)').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('North London (NW,N,EN)').Id__c;
       }
       
       else if(PriceBook__c.getInstance('NW and N Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('NW and N Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('OX Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('OX Zone D').Id__c;
       }

       else if(PriceBook__c.getInstance('Other').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('Other').Id__c;
       }
       
       else if(PriceBook__c.getInstance('PO Zone E').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('PO Zone E').Id__c;
       }
       
       else if(PriceBook__c.getInstance('RG Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('RG Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('RH Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('RH Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('RM Zone B').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('RM Zone B').Id__c;
       }
       
       else if(PriceBook__c.getInstance('S- Scotland').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('S- Scotland').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SE Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SE Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SG').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SG').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SL Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SL Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SM Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SM Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SO Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SO Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SS Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SS Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SW Zone C&D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SW Zone C&D').Id__c;
       }
       
       
       else if(PriceBook__c.getInstance('TN Zone B & C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('TN Zone B & C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('TW Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('TW Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('UB Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('UB Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('WF (NHS)').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('WF (NHS)').Id__c;
       }

       else if(PriceBook__c.getInstance('WD Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('WD Zone D').Id__c;
       }

       else if(PriceBook__c.getInstance('E Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('E Zone C').Id__c;
       }

       else{
       ac.Price_Book__c=PriceBook__c.getInstance('Standard').Id__c;
       }
      
       system.debug('<<<updated region>>>>>>>>>'+ac.Region__c+ 'updated  pricebook ============='+ac.Price_Book__c); 
    }
     
  }  


/*====================================================
*Method Name     : UpdatePriceBookBefore
*Description     : Update pricebook of Account
*Arguments       : new Account list
====================================================*/    
     Private void UpdatePriceBookBefore(List<Account> NewMap){
    
    for(Account ac:NewMap){
       
       if(!Test.isRunningTest() == false){ 
      if(PriceBook__c.getInstance('BN Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('BN Zone D').Id__c;
       }

       else if(PriceBook__c.getInstance('AL Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('AL Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('BR Zone B').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('BR Zone B').Id__c;
       }
       
       else if(PriceBook__c.getInstance('Central London (E,EC,WC,W)').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('Central London (E,EC,WC,W)').Id__c;
       }
       
       else if(PriceBook__c.getInstance('CM Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('CM Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('CR Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('CR Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('CT Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('CT Zone C').Id__c;
       }
       

       else if (PriceBook__c.getInstance('CN Zone D').Region__c == ac.Region__c) { 
       ac.Price_Book__c = PriceBook__c.getInstance('CN Zone D').Id__c; 
       } 
  
       else if(PriceBook__c.getInstance('CO Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('CO Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('DA Zone A').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('DA Zone A').Id__c;
       }
       
       else if(PriceBook__c.getInstance('EN Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('EN Zone C').Id__c;
       }

       else if(PriceBook__c.getInstance('GU Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('GU Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('HA Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('HA Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('HP Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('HP Zone D').Id__c;
       }
       
       
       else if(PriceBook__c.getInstance('IG Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('IG Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('IP Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('IP Zone D').Id__c;
       }       

       else if(PriceBook__c.getInstance('KT Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('KT Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('LU Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('LU Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('ME Zone B').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('ME Zone B').Id__c;
       }
       
       else if(PriceBook__c.getInstance('MK Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('MK Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('NL').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('NL').Id__c;
       }
       
       
       else if(PriceBook__c.getInstance('North London (NW,N,EN)').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('North London (NW,N,EN)').Id__c;
       }
       
       else if(PriceBook__c.getInstance('NW and N Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('NW and N Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('OX Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('OX Zone D').Id__c;
       }

       else if(PriceBook__c.getInstance('Other').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('Other').Id__c;
       }
       
       else if(PriceBook__c.getInstance('PO Zone E').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('PO Zone E').Id__c;
       }
       
       else if(PriceBook__c.getInstance('RG Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('RG Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('RH Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('RH Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('RM Zone B').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('RM Zone B').Id__c;
       }
       
       else if(PriceBook__c.getInstance('S- Scotland').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('S- Scotland').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SE Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SE Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SG').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SG').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SL Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SL Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SM Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SM Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SO Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SO Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SS Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SS Zone C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('SW Zone C&D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('SW Zone C&D').Id__c;
       }
       
        else if(PriceBook__c.getInstance('TN Zone B & C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('TN Zone B & C').Id__c;
       }
       
       else if(PriceBook__c.getInstance('TW Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('TW Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('UB Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('UB Zone D').Id__c;
       }
       
       else if(PriceBook__c.getInstance('WF (NHS)').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('WF (NHS)').Id__c;
       }

       else if(PriceBook__c.getInstance('WD Zone D').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('WD Zone D').Id__c;
       }
		
	   else if(PriceBook__c.getInstance('E Zone C').Region__c==ac.Region__c){
       ac.Price_Book__c=PriceBook__c.getInstance('E Zone C').Id__c;
       }
    
     
       else{
       ac.Price_Book__c=PriceBook__c.getInstance('Standard').Id__c;
       }
        }else{
           ac.Price_Book__c=null;
       } 
      
       system.debug('<<<updated region>>>>>>>>>'+ac.Region__c+ 'updated  pricebook ============='+ac.Price_Book__c); 
    }
     
  } 


/*====================================================
*Method Name     : UpdateAmsecLogo
*Description     : Update the Logo to Invoice.
*Arguments       : new Account list
====================================================*/    
/*
    Private void UpdateAmsecLogo(map<id,Account> accMap){
    system.debug('<<<beforeaccMap>>'+accMap); 
    List<string> accIds = new List<string>();
    List<opportunity> OpportunityLists = new List<opportunity>();
    List<opportunity> UpdateOppLists = new List<opportunity>();
    
    
    for(Account acc:accMap.values()){
      if(acc.Invoice_Layout__c == 'Amsec'){
        accIds.add(acc.id);
      }
    }
    system.debug('<<<beforaccIds>>'+accIds); 
    
    OpportunityLists= [Select id,AmsecAvailable__c,AccountId
                                      FROM opportunity 
                                      where Accountid IN :accIds];
                                      
    system.debug('<<<beforopportunityLists>>'+opportunityLists.size());                                
    for(opportunity opp:opportunityLists){
           opp.AmsecAvailable__c = true;
           system.debug('<<<opp:opportunityLists>>'+opp.name);
           UpdateOppLists.add(opp);
    }
    
    If(UpdateOppLists != null){
     system.debug('<<<UpdateOppLists >>'+UpdateOppLists.size());   
       update UpdateOppLists;
    }
    
    } 
*/
   
/*====================================================
*Method Name     : UpdateServiceContactField
*Description     : Update the Service Contact Filed.
*Arguments       : new Account list
====================================================*/    

    Private void UpdateServiceContactField(map<id,Account> accMap,Map<id,Account> accountOldMap){
        //Variable Declaration
        List<id> accountIds=new List<id>();
        for(Account acc:accMap.values()){
            accountIds.add(acc.Id);
        }
        //to get a list of SiteContracts 
        List<SiteContracts__c> siteContractList=[select id,site__c,Contact__c from SiteContracts__c where Site__c IN:accountIds];
        for(SiteContracts__c  site :siteContractList){
            //assign Account service contact Field to Site contract Service Contact Field
            site.Contact__c =accMap.get(site.site__c).TEST_Service_Contact__c;
        }
        update siteContractList;    //update the SiteContracts
    }
    
/*====================================================
*Method Name     : updateAccountCheckStatusField
*Description     : Update the Check Filed.
*Arguments       : new Account list
====================================================*/    
    Private void updateAccountCheckStatusField(map<id,Account> newList,Map<id,Account> accountOldMap){
        //Variable Declaration
        List<string> accountids = new List<string>();
        List<AggregateResult> aggList = New List<AggregateResult> ();
        List<opportunity> reqOpplists = new List<opportunity>();
        List<string> OppIds = new List<String>();        
        
        Map<DateTime,id> AccMap=new Map<DateTime,id>(); 
         
        aggList = [SELECT AccountId,max(CreatedDate ) 
                   FROM opportunity 
                   WHERE  AccountId IN :newList.keyset() 
                   group by AccountId];
        for (AggregateResult ar : aggList)  {
            AccMap.put((DateTime)ar.get('expr0'),(id)ar.get('AccountId'));
        }
        List<opportunity> opplists = [Select id,Check_Status__c,CreatedDate,AccountId
                                      FROM opportunity 
                                      where Accountid IN :newList.Keyset()];
        system.debug('==aggList=='+aggList+'===='+AccMap+'===='+AccMap.values());
        
        for(opportunity opp:opplists){
            id maxOppDate  = AccMap.get(opp.createdDate);
            system.debug('==maxOppDate=='+maxOppDate);
            if(maxOppDate != Null){
                system.debug('==opp=='+opp.id+'===check'+opp.Check_Status__c);
                OppIds.add(opp.id);
            }
        }
        reqOpplists = [Select id,Check_Status__c,CreatedDate,AccountId
                       FROM opportunity where id IN :OppIds];
        List<account> AccountList = [Select id,Check_Status__c 
                                     from account 
                                     where id in : newList.Keyset()];
        FOR(Account acc:AccountList){
            FOR(Opportunity opp:reqOpplists){
                if(acc.id == opp.accountid){
                    acc.Check_Status__c = opp.Check_Status__c; 
                }
            }
        }
        //Update the account
        update AccountList;
    }
    
    Private void UpdatePriceListDate(List<Account> newAccounts,Map<id,Account> accountOldMap){
        //Create the instance for the Account
        List<Account> ChildRecords = new List<Account>();
        //Variable Declaration
        string CurrentAccountNotes;
        string CurrentParentId; 
        date PrilistCorrectdate;
         for (Account currentrecord : newAccounts) {
             //Getting the parentid, PriceListDate and Account notes
             CurrentParentId = currentrecord.id;
             PrilistCorrectdate = currentrecord.Price_List_Correct__c;
             CurrentAccountNotes =currentrecord.Account_Notes__c; 
         }
        
        ChildRecords = [Select id,Parentid,Price_List_Correct__c,Account_Notes__c from account where parentid = :CurrentParentId];
       
         for (Account childrecord : ChildRecords) {
             //Update the PriceList Date to Childrecord
             childrecord.Price_List_Correct__c = PrilistCorrectdate;
             //Update the Account Notes to Childrecord
             childrecord.Account_Notes__c = CurrentAccountNotes ;
            } 
        //Updata the Child Records
        update ChildRecords;
    }
/*====================================================
*Method Name     : 
*Description     : Update the amount from all site to customer.
*Arguments       : new Account list
====================================================*/  
Public void Updatetotalamount(map<id,Account> AcctNewMap,Map<id,Account> AcctOldMap){
       List<AggregateResult> aggList = New List<AggregateResult>();
       Set<Id> setParentAccId = new Set<Id>();
  //  Map<id,Account> AcctNewMap = [select Id,name,ParentId from Account];
     If(AcctNewMap != Null){
         
        for(Account acc: AcctNewMap.values()) {
            if(acc.ParentId!=null)
              setParentAccId.add(acc.ParentId); 
    
             system.debug('setParentAccId==[562]==>' + setParentAccId);  
            }
          }
            else{
                   for(Account acc: AcctOldMap.values()) {
            if(acc.ParentId!=null)
              setParentAccId.add(acc.ParentId);
                   }
                 }
     
      List<Account> accList = new  List<Account>();{
      system.debug('accList==[570]==>' + accList);  
  aggList=[Select ParentId, Sum(Invoiced_in_last_12_months__c)Total 
                                 from Account 
                                 where ParentId IN : setParentAccId
                                 group by ParentId];
          
      for(AggregateResult aRes: aggList){
                                   
      accList.add(new Account(Id = (Id)aRes.get('ParentId'), All_Site_Total_Amount__c = (Decimal)aRes.get('Total')));
     //  accList.add(new Account(Id = (Id)aRes.get('ParentId'), All_Site_Total_Amount__c = (Decimal)aRes.get('Total')));                              
      system.debug('aRes==[577]==>'+ aRes);  
                                
        } 
    
  try{	
      if(accList.size() > 0)
      {
       Update accList;
      } 
     }catch(DmlException de){
         System.debug(de);
        }
     } 
      
 }
}