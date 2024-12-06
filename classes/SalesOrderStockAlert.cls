public class SalesOrderStockAlert {

    public SalesOrderStockAlert(ApexPages.StandardController controller) {
        OrdId=ApexPages.currentPage().getParameters().get('id');
        prds=new List<String>();
        if(OrdId !=null){
            OrdLI=[select Id,PricebookEntry.Product2Id,Quantity, OrderId from OrderItem where OrderId=:OrdId];        
            for(OrderItem oli:OrdLI){
                prds.add(oli.PricebookEntry.Product2Id);
            }
            if(prds.size()>0){
            InvList=[select Id,Product__c,Product__r.Name,In_Hand_Quantity__c,Warehouse__c,Warehouse__r.Name from Inventory__c where Product__c IN:prds];
            }
        }
    }
    
    public List<String> prds;
    public String OrdId{get;set;}
    public List<Inventory__c> InvList;
    public List<OrderItem> OrdLI{get;set;}
    public List<AvailPrd> PrdList{get;set;}    
    
    public List<AvailPrd> getPrdList(){
        PrdList=new List<AvailPrd>();
        for(OrderItem OrdLIprd : OrdLI){
            for(Inventory__c invPrd : InvList){
                if((OrdLIprd.Quantity > invPrd.In_Hand_Quantity__c ||  invPrd.In_Hand_Quantity__c == null) && OrdLIprd.PricebookEntry.Product2Id == invPrd.Product__c ){
                    PrdList.add(new AvailPrd(invPrd,Double.valueOf(OrdLIprd.Quantity)));
                }
            }
        }
        return PrdList;
    }
        
    public void StockAlertOrd(){
        PrdList=getPrdList();
    }
    public class AvailPrd{
        public Inventory__c inv{get;set;}
        public Double addedQty{get;set;}
        public AvailPrd(Inventory__c invPrd,Double qty){
            inv=invPrd;
            addedQty=qty;
        }        
    }

}