/*============================================================================================================
*Class Name     : Purchase_Order_Controller 
*Description    : To handle the Supplier Purchase Order Pdf
*Company        : Puthuvannam Technology Solutions Pvt Ltd.
*Date           : 23rd June, 2014
*Version        : 30.0
*Methods        : public Purchase_Order_Controller(ApexPages.StandardController controller)

*============================================================================================================*/

public class Purchase_Order_Controller {

   
    public Purchase_Order_Controller(ApexPages.StandardController controller) {
    
       Purchaseorder = ApexPages.CurrentPage().getParameters().get('id');
    
    SFDC_Purchase_Order__c PO = [select id,Name,Supplier1__c,Visit__c from SFDC_Purchase_Order__c where id=:Purchaseorder ];
    
    Suppliers__c Sup =[select id,Name,Billing_Street__c ,Billing_City__c,Billing_State_Province__c,Billing_Zip_Postal_Code__c,Billing_Country__c,Telephone_Number__c,Fax_Number__c,Sage_Code__c,Email__c from Suppliers__c where id=:PO.Supplier1__c];
    
    setvalue = [select Billing_Street__c from Suppliers__c where id=:PO.Supplier1__c].Billing_Street__c;
    setvalue1 = [select Billing_City__c from Suppliers__c where id=:PO.Supplier1__c].Billing_City__c;
    setvalue2 = [select Billing_State_Province__c from Suppliers__c where id=:PO.Supplier1__c].Billing_State_Province__c;
    setvalue3 = [select Billing_Zip_Postal_Code__c from Suppliers__c where id=:PO.Supplier1__c].Billing_Zip_Postal_Code__c;
    setvalue4 = [select Billing_Country__c from Suppliers__c where id=:PO.Supplier1__c].Billing_Country__c;
    setvalue5 = [select Telephone_Number__c from Suppliers__c where id=:PO.Supplier1__c].Telephone_Number__c;
    setvalue6 = [select Fax_Number__c from Suppliers__c where id=:PO.Supplier1__c].Fax_Number__c;
    setvalue7 = [select Sage_Code__c from Suppliers__c where id=:PO.Supplier1__c].Sage_Code__c ;
    setvalue8 = [select Email__c from Suppliers__c where id=:PO.Supplier1__c].Email__c ;
    
    if(PO.Visit__c !=Null){
    Visits__c Visit =[select id,Name,Site_Address__c,Site_Contract__c from Visits__c where id=:PO.Visit__c ];
    setvalueVisit = [select Site_Address__c from Visits__c where id=:PO.Visit__c].Site_Address__c ;
    }

    
    
    }

public String Purchaseorder{get; set;}
public String PO{get; set;}
public String Sup{get; set;}
public String setvalue {get; set;}
public String setvalue1 {get; set;}
public String setvalue2 {get; set;}
public String setvalue3 {get; set;}
public String setvalue4 {get; set;}
public String setvalue5 {get; set;}
public String setvalue6 {get; set;}
public String setvalue7 {get; set;}
public String setvalue8 {get; set;}
public String Visit{get; set;}
public String setvalueVisit{get; set;}

}