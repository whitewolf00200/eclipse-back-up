/*============================================================================================================
*Class Name     : SignatureComponentController 
*Description    : Update customer signature
*Company        : FieldAx
*Date           : 25 March 2016
*============================================================================================================*/
global with sharing class SignatureComponentController {

    public SignatureComponentController() {

    }


    public SignatureComponentController(QuoteController controller) {

    }

 
global id objParentId{get;set;}
global String customer{get;set;}
 
/*====================================================
*Method Name     : saveSignature
*Description     : Save the customer signature
*Arguments       : Null
====================================================*/     
 @RemoteAction
 global static boolean saveSignature(String signatureBody, id parentId, String customer){
  try{
   system.debug('Record== ' + parentId);
   system.debug('customer=='+customer);    
   Schema.SObjectType sobjectType = parentId.getSObjectType();
   String sobjectName = sobjectType.getDescribe().getName();
   sObject s = Schema.getGlobalDescribe().get(sobjectName).newSObject();
   s.put('Id',parentId);
   
           s.put('Customer_Signature__c','<img src="' +signatureBody+ '" alt="' + parentId+ '"/>');
           //s.put('Customer_Name__c',authority);   
       system.debug(s);
       update s;
   }Catch(exception e){
   system.debug(e);
     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'signature not save'+e.getmessage()));
   }
   return true;
   //return '{success:true, attachId:' + a.Id + ', sObject: ' + c + '}';
    
 }
}