public class RaisePO {

    public RaisePO(ApexPages.StandardController controller) {
        OrdId=ApexPages.currentpage().getParameters().get('id');        
        addSPO= new PurchaseOrder__c();  
    }
    public String OrdId{get;set;}
    public PurchaseOrder__c addSPO{get; set;}
    public List<PurchaseOrderLineItem__c> addLI{get;set;}
    public List<String> prds{get;set;}
        
    public void CreatePO(){
        prds=new List<String>();   
        addLI=new List<PurchaseOrderLineItem__c>();
        PurchaseOrderLineItem__c poli;
        for(OrderItem oli: [select Id,PricebookEntry.Product2Id,Quantity, OrderId from OrderItem where OrderId=:OrdId]){
           prds.add(oli.PricebookEntry.Product2Id);
        }
             
        for(OrderItem oppLI: [select Id,PricebookEntry.Product2Id,Quantity,UnitPrice,OrderId from OrderItem where OrderId=:OrdId]){
            if(oppLI.Quantity >0){
                poli=new PurchaseOrderLineItem__c(Product__c=oppLI.PricebookEntry.Product2Id,Quantity__c=oppLI.Quantity,Price__c=oppLI.UnitPrice);
                addLI.add(poli);
            }
        }          
      }        
    
    public pageReference AddPOLI(){
        addSPO.Sales_Order__c=OrdId;
        insert addSPO;   
        if(addLI.size()>0){
            for(PurchaseOrderLineItem__c pol:addLI){
                pol.Purchase_Order__c=addSPO.id;
                insert pol;
            }
        }
        return new PageReference('javascript:window.top.close();window.opener.location.reload();');
    }
    
}