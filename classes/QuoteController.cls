Public class QuoteController{
    Public Id QliId;
     public List<QuoteLineitem> Qli{get;set;}  
    public QuoteController()
    {
       
    }
     public ID getQliId()
    {
    
    system.debug('getQliId========'+QliId);
    return QliId;
    
    }
    
    public void setQliId(ID QliIds){
        if(QliIds != null){
            QliId= QliIds ;
            system.debug('setQliId========'+QliId);
            ChangeOrder();
         }
    }
    
    public void ChangeOrder()
    {
       
    //added << Product2.Product_URL__c >> Field For Quote Line Item.
    Qli=[Select id,QuoteId,Product2.Name,Product2.Product_URL__c,Sales_Description__c,Show_Description__c,Extended_Sales_Description__c,Product2.Description,
         Quantity,Product2.Stock_Unit__c,UnitPrice,TotalPrice from QuoteLineitem where QuoteId =:QliId order by SortOrder,Pricebookentry.product2.Name];
    system.debug('Qli========'+Qli);
    }
    }