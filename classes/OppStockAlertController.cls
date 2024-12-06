public class OppStockAlertController{
    public String soId{get;set;}
    public List<Inventory__c> InvList;
    public List<OpportunityLineItem> soLIs{get;set;}
     //public List<OppAlert> availPrd{get;set;}
    //public List<AvailPrd> PrdList{get;set;}
    public List<OppAlert> PrdList{get;set;}
    public OppStockAlertController(ApexPages.StandardController controller) {
        soId=ApexPages.currentPage().getParameters().get('id');
        soLIs=[select Id,Product2Id,Product2.Name,Quantity,OpportunityId from OpportunityLineItem where OpportunityId=:soId];
        InvList=[select Id,Product__c,Product__r.Name,In_Hand_Quantity__c,Warehouse__c,Warehouse__r.Name from Inventory__c where Product__c IN(select Product2Id from OpportunityLineItem where OpportunityId=:soId)];
    }
    
    public List<OppAlert> getPrdList(){
        PrdList=new List<OppAlert>();
        Boolean isAvailable;
        for(OpportunityLineItem soLI : soLIs){ 
            isAvailable=false;
            for(Inventory__c invPrd : InvList){                       
                if((soLI.Quantity>= invPrd.In_Hand_Quantity__c) && soLI.Product2Id== invPrd.Product__c ){                    
                    PrdList.add(new OppAlert(soLI.Product2.Name,Double.valueOf(soLI.Quantity ),invPrd.In_Hand_Quantity__c,invPrd.Warehouse__r.Name));
                }else if(soLI.Product2Id== invPrd.Product__c){
                    isAvailable=true;
                }
            }
            /*if(!isAvailable)
                PrdList.add(new OppAlert(soLI.Product__r.Name,Double.valueOf(soLI.Quantity__c),0,''));*/
                
                system.debug('Inventory List==='+InvList);
        }
        return PrdList;
    }
        
    public void OppStockAlertOpp(){
        PrdList=getPrdList();
    }
    public class OppAlert{        
        public Double addedQty{get;set;}
        public String prodName{get; set;}
        Public Decimal available{get; set;}
        Public String whName{get; set;}
        
        public OppAlert(String name,Double qty, Decimal avail,String wh){
            prodName=name;
            addedQty=qty;
            available=avail;
            whName=wh;
        }        
    }
}