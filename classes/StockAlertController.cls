public class StockAlertController{
    public String soId{get;set;}
    public List<Inventory__c> InvList;
    public List<SalesOrderLineItems__c> soLIs{get;set;}
    public List<AvailPrd> PrdList{get;set;}
    public StockAlertController(ApexPages.StandardController controller) {
        soId=ApexPages.currentPage().getParameters().get('id');
        soLIs=[select Id,Product__c,Product__r.Name,Quantity__c, Sales_Order__c from SalesOrderLineItems__c where Sales_Order__c=:soId];
        system.debug('line item========'+soLIs);
        InvList=[select Id,Product__c,Product__r.Name,In_Hand_Quantity__c,Warehouse__c,Warehouse__r.Name from Inventory__c where Product__c IN(select product__c from SalesOrderLineItems__c where Sales_Order__c=:soId)];
        system.debug('Inventory======='+InvList);
    }
    
    public List<AvailPrd> getPrdList(){
        PrdList=new List<AvailPrd>();
        Boolean isAvailable;
        for(SalesOrderLineItems__c soLI : soLIs){ 
            isAvailable=false;
            for(Inventory__c invPrd : InvList){                       
                if((soLI.Quantity__c >= invPrd.In_Hand_Quantity__c) && soLI.Product__c == invPrd.Product__c ){                    
                    PrdList.add(new AvailPrd(soLI.Product__r.Name,Double.valueOf(soLI.Quantity__c),invPrd.In_Hand_Quantity__c,invPrd.Warehouse__r.Name));
                    system.debug('PrdList======'+PrdList);
                }/* else if(soLI.Product__c == invPrd.Product__c){
                    isAvailable=true;
                } */
            }
            /*if(!isAvailable)
                PrdList.add(new AvailPrd(soLI.Product__r.Name,Double.valueOf(soLI.Quantity__c),0,''));*/
                
                system.debug('Inventory List==='+InvList);
        }
        return PrdList;
    }
        
    public void StockAlertOpp(){
        PrdList=getPrdList();
    }
    public class AvailPrd{        
        public Double addedQty{get;set;}
        public String prodName{get; set;}
        Public Decimal available{get; set;}
        Public String whName{get; set;}
        
        public AvailPrd(String name,Double qty, Decimal avail,String wh){
            prodName=name;
            addedQty=qty;
            available=avail;
            whName=wh;
        }        
    }
}