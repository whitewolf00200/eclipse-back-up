/*============================================================================================================
*Class Name     : Purchase_Order_Preview_Controller 
*Description    : Naming the Purchase Order as 'Eclipse Dental Purchase Order.pdf' when it will be download
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 29th Jan, 2017
*Version        : 2.0
*Change History : Initial Class
*Methods        : No methods
*============================================================================================================*/

public class Purchase_Order_Preview_Controller {
//public Config__c configvalue{get;set;}


    public Purchase_Order_Preview_Controller(ApexPages.StandardController controller) {
    //configvalue = [select Background_Colour__c,Header__c,Footer_Line_1__c,Footer_Line_2__c,Product_Table_Colour__c,Header_Title__c,Invoice_Background__c from Config__c Limit 1];
     Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=Eclipse Dental Purchase Order.pdf');
    }

}