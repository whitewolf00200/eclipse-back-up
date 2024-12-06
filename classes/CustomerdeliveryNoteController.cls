/*============================================================================================================
*Class Name     : CustomerdeliveryNoteController
*Description    : To handle the Customer Note
*Company        : Puthuvannam Technology Solutions Pvt Ltd.
*Date           : 23rd June, 2014
*Version        : 30.0
*Methods        : public CustomerdeliveryNoteController(ApexPages.StandardController controller)

*============================================================================================================*/

public class CustomerdeliveryNoteController {

public String CurrentId{get; set;}
public String Accid{get; set;}
public String listAccount{get; set;}
public String ShipStreet{get; set;}
public String ShipCity{get; set;}
public String ShipState{get; set;}
public String ShipZip{get; set;}
public String ShipCountry{get; set;}
public String FirstName{get; set;}
public String LastName{get; set;}
public String Name{get; set;}
public String Gift{get; set;}
public String Customer{get; set;}

    public CustomerdeliveryNoteController(ApexPages.StandardController controller) {

      CurrentId=ApexPages.currentPage().getParameters().get('id');
      system.debug('-----------'+CurrentId);
      Technician_Compliance__c Accid=[select id,Customer_Site__r.name,Firstname__c,Lastname__c,Gift__c from Technician_Compliance__c where id=:CurrentId];
      system.debug('-----------'+Accid);
      
      Account listAccount=[select name, ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry from Account where id=:Accid.Customer_Site__c];
       system.debug('-----------'+listAccount);
      ShipStreet= listAccount.ShippingStreet;
      ShipCity = listAccount.ShippingCity;
      ShipState= listAccount.ShippingState;
      ShipZip= listAccount.ShippingPostalCode;
      ShipCountry= listAccount.ShippingCountry ;
      FirstName=Accid.Firstname__c;
      LastName=Accid.Lastname__c ;
      Name=FirstName+'  '+LastName;
      Gift=Accid.Gift__c; 
      Customer=Accid.Customer_Site__r.name; 
    }
   
    

}