public class ViewCatalogController {

    public String oppId{get; set;}
    
    
    public List<productCatalogs> catalogList{get; set;}
    public List<NotInSPLI> catLists{get;set;}
    public boolean oppsize {get;set;}
     public boolean suppsize {get;set;}
    public List<AggregateResult> gpaggResult;
   public List<OpportunityLineItem> oppLIList;
    
    public ViewCatalogController() {
         catalogList=new List<productCatalogs>();
         gpaggResult=new List<AggregateResult>();
         gpaggResult= [select Product2Id,avg(GP__c) average from PricebookEntry group by Product2Id];         
         oppId=ApexPages.currentPage().getParameters().get('OPPId');
         catLists=getcatLists();
         catalogList=getProductCatalogs();    
         
    }
    
     public Double getgpCost(String ids){
        Double val;
        for(AggregateResult gpresult : gpaggResult){
            String prdName1=String.valueOf(gpresult.get('Product2Id'));
            if(prdName1 == ids){
                val=Double.valueOf(gpresult.get('average'));
            }
        }
       return val;
    }   
    
    public List<productCatalogs> getProductCatalogs() {
        
         List<AggregateResult> aggResult= [select Product__c,min(Cost__c) minimum,max(Cost__c) maximum,avg(Cost__c) average from SupplierProduct__c where Product__c IN(select Product2Id from OpportunityLineItem where OpportunityId =:oppId) group by Product__c];
         for(AggregateResult result :aggResult) {
                String prdName=String.valueOf(result.get('product__c'));
                Double gpCost=getgpCost(prdName);
                for(OpportunityLineItem oppLIList :[select Product2Id,UnitPrice from OpportunityLineItem where OpportunityId =:oppId]){                                                
                    if(oppLIList.Product2Id == prdName){                      
                      Double minPriceData=Double.valueOf(result.get('minimum'));
                      Double maxPriceData=Double.valueOf(result.get('maximum'));
                      Double averageCost=Double.valueOf(result.get('average'));                      
                      catalogList.add(new productCatalogs(oppLIList ,minPriceData,maxPriceData,averageCost,gpCost));                              
                    }  
                               
              }            
         }     
         if(aggResult.size()<=0)
                    {
                    suppsize=true;
                    }   
        return catalogList;
    }
    
    public List<NotInSPLI> getcatLists(){
        catLists=new List<NotInSPLI>();
        List<AggregateResult> aggResult1=[select Product__c from SupplierProduct__c group by Product__c];
        List<String> uniqueSPLI=new List<String>();
        for(AggregateResult result :aggResult1) {
            uniqueSPLI.add(String.valueOf(result.get('product__c')));
        }
         oppLIList =[select Product2Id,UnitPrice from OpportunityLineItem where OpportunityId =:oppId AND Product2Id NOT IN :uniqueSPLI];
        for(OpportunityLineItem opli:oppLIList){
            for(AggregateResult gpresult : gpaggResult){
                String prdName1=String.valueOf(gpresult.get('Product2Id'));
                if(prdName1 == opli.Product2Id){
                    Double val=Double.valueOf(gpresult.get('average'));
                    catLists.add(new NotInSPLI(opli,val));
                }
                
            }
            
        }
        if(oppLIList.size()<=0)
        {
                    oppsize=true;
                    }
        return catLists;
    }   
    
    public class NotInSPLI{
        public OpportunityLineItem prdNames1{get; set;}
        public Double GpPer{get;set;}
        public NotInSPLI(OpportunityLineItem prdNames,Decimal gpvals){
            prdNames1=prdNames;
            GpPer=gpvals.setscale(2);
        }
    }
    
    public class productCatalogs{
        public Decimal minPrice{get; set;}
        public Decimal maxPrice{get; set;}
        public Decimal avgPrice{get; set;}
        public String productName{get; set;}
        public Double GpPercent{get;set;}
        public OpportunityLineItem ProductListName{get; set;}
        productCatalogs(OpportunityLineItem pName,Decimal minCost,Decimal maxCost,Decimal avgCost,Decimal gp){
           // Map<Id,Product2> prdmap=new Map<Id,Product2>([select id,name form Product2]);
            ProductListName=pName;
            //productName=
            minPrice=minCost;
            maxPrice=maxCost;
            avgPrice=avgCost.setscale(2);
            GpPercent=gp.setscale(2);
        }
    }

}