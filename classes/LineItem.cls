public class LineItem{

    public LineItem(ApexPages.StandardController controller) {

    }
    @testvisible List<SalesOrderLineItems__c> products;
    public List<SalesOrderLineItems__c> getProducts()
    {
    products=[select Product__c,Price__c from SalesOrderLineItems__c];//products= [select Name,Product_Name__c,Product_Type__c  from SalesOrderLineItems__c];
    return products;
    }

   
}