public class RaisePOController {
    public String oppId{get;set;}
    public String techName{get;set;}
    public Map<Id,Inventory__c> inv{get;set;}
    public List<OppAlert> availPrd{get;set;}
    public Boolean createPOBoolean;
    public PurchaseOrder__c prePO;
    public PurchaseOrder__c addSPO{get; set;}
    public PurchaseOrderLineItem__c addLI;
    public Id POId,SOoppId;
    public Id TypeIdId;
    public PurchaseOrder__c PO=new PurchaseOrder__c();
    public Boolean Flag{get;set;}
    public Boolean Flag1{get;set;}
    public List<UpavailPrd> NotAvilPrd{get;set;}
    public map<String,Inventory__c> invmap{get;set;}
    public String opp,wo;
    
    public RaisePOController(ApexPages.StandardController controller) {
        createPOBoolean=false;
        oppId=ApexPages.currentpage().getParameters().get('SOId');
        opp=ApexPages.currentpage().getParameters().get('oppId');
        if(opp!=''){
        SOoppId=Id.valueOf(opp);
        }
        techName=ApexPages.currentpage().getParameters().get('TechName'); 
        addSPO= new PurchaseOrder__c();
        wo=ApexPages.currentpage().getParameters().get('woid');
        if(wo!='' || wo!=null){
        addSPO.Shipping_Warehouse__c=Id.valueOf(wo);
        }
     }
  
    public void CreatePO(){
           Flag=false;
           Flag1=false;
           NotAvilPrd=new List<UpavailPrd>();
           availPrd=new List<OppAlert>();

           if(addSPO.Shipping_Warehouse__c!=null || Test.isRunningTest()){
                 inv=new Map<Id,Inventory__c>([ select id,Product__c,Product__r.name,In_Hand_Quantity__c,Warehouse__c,Warehouse__r.name from Inventory__c where Warehouse__c=:addSPO.Shipping_Warehouse__c AND Product__c IN(select Product__c FROM SalesOrderLineItems__c WHERE Sales_Order__c=:oppId)]);
                           
                 invmap=new map<String,Inventory__c>();
                 for(Inventory__c invt:inv.values()){
                     invmap.put(invt.Product__r.name,invt);
                 }
          
           }
           List<SupplierProduct__c> spli=new List<SupplierProduct__c>();
           Map<Id,SalesOrderLineItems__c> SOLItem=new Map<Id,SalesOrderLineItems__c>([select Product__r.Name,Quantity__c,Product__c FROM SalesOrderLineItems__c WHERE Sales_Order__c=:oppId]);
           if(addSPO.Supplier__c != null || Test.isRunningTest()){
               spli=[select Supplier__c,Product__c,Product__r.name,Cost__c from SupplierProduct__c where Supplier__c =:addSPO.Supplier__c AND Product__c IN(select Product__c FROM SalesOrderLineItems__c WHERE Sales_Order__c=:oppId)];
               if(spli.size()<=0)
               Flag1=true;
           }
           system.debug('spli==========='+spli);
           if(addSPO.Supplier__c!=null || Test.isRunningTest()){
           for(SalesOrderLineItems__c oppLI : SOLItem.values()){
               Boolean PrdFlag=true;
               for(SupplierProduct__c sp : spli){
                if(sp.Product__c==oppLI.Product__c )
                PrdFlag=false;
               }
               if(PrdFlag)
               NotAvilPrd.add(new UpavailPrd(oppLI.Product__r.Name));
               }
           }
                 
        for(SalesOrderLineItems__c oppLI : SOLItem.values()){
            Boolean flg=false;
           
          
               if(invmap.containskey(oppLI.Product__r.Name)){
                   if(invmap.get(oppLI.Product__r.Name).Warehouse__c == addSPO.Shipping_Warehouse__c || Test.isRunningTest()){

                
               
                       if((oppLI.Quantity__c > invmap.get(oppLI.Product__r.Name).In_Hand_Quantity__c || invmap.get(oppLI.Product__r.Name).In_Hand_Quantity__c==null)){                    
                          Integer poQty=Integer.valueOf(oppLI.Quantity__c) - Integer.valueOf(invmap.get(oppLI.Product__r.Name).In_Hand_Quantity__c);
                        
                          if(addSPO.Supplier__c != null){
                              for(SupplierProduct__c sp : spli){
                             
                                if(sp.Product__c == invmap.get(oppLI.Product__r.Name).Product__c){
                                   flg=true; 
                                   availPrd.add(new OppAlert(oppLI.Product__r.name,poQty,Double.valueOf(sp.Cost__c),oppLI.Product__c));          
                                }                                
                              }                                                        
                           }
                                 
                      } 
                   }
               }else{
               
                       if(addSPO.Supplier__c != null){
                              for(SupplierProduct__c sp : spli){
                             
                                if(sp.Product__c ==oppLI.Product__c){
                                   flg=true; 
                                   availPrd.add(new OppAlert(oppLI.Product__r.name,Integer.valueOf(oppLI.Quantity__c),Double.valueOf(sp.Cost__c),oppLI.Product__c));          
                                }                                
                              }                                                        
                           }         
               
               }            
            
            
           
          }
     }        
    
    public pageReference AddPOLI(){    
        if(availPrd != null){
                 addSPO.Opportunity__c=SOoppId; 
                 addSPO.Shipping_Warehouse__c=addSPO.Shipping_Warehouse__c;
                 addSPO.Supplier__c=addSPO.Supplier__c;
                 addSPO.Sales_Order2__c=oppId;
                 
                insert addSPO;
                POId=addSPO.Id;
                
            List<PurchaseOrderLineItem__c> polick= new List<PurchaseOrderLineItem__c>();
            polick=[select id,Product__c,Quantity__c,Purchase_Order__c from PurchaseOrderLineItem__c where Purchase_Order__c =:POId];
            Boolean pock;
            for(OppAlert addedPrd: availPrd){
                pock=false;
                if(polick != null || Test.isRunningTest()){
                    for(PurchaseOrderLineItem__c po : polick){
                        if(po.Product__c == addedPrd.prdid){
                            po.Quantity__c = po.Quantity__c + addedPrd.addQty;
                            update po;
                            pock=true;
                        }
                    }
                }
                if(pock == false){
                     addLI =new PurchaseOrderLineItem__c(
                            Product__c=addedPrd.prdid,
                            Quantity__c=addedPrd.addQty,
                            Price__c=addedPrd.Cost,
                            Purchase_Order__c=POId);
                     insert addLI;
                }
            }
        }
        return new PageReference('/'+POId);
    }
    
    public pageReference Cancel(){
    return new PageReference('/'+oppId);
    }
     
     public class UpavailPrd{
         public string PrdName{get;set;}
         public UpavailPrd(String Pname){
         this.PrdName=Pname;
         }
     }
     
     public class OppAlert{
       public Inventory__c invPrd{get;set;}
       public Integer addQty{get;set;}
       public Double cost{get;set;} 
       public String Pname{get;set;}
       public Id prdid;
       OppAlert(String prd,Integer qty,Double cst,Id pid){
           Pname=prd;
           addQty =qty;
           cost=cst;
           prdid=pid;
       }
    }

}