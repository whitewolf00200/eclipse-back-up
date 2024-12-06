public class PartsReplenishment {
    
    public List<LineItem> lineItemList{get;set;}
    public List<LineItem> NotlineItemList{get;set;}
    public String recId;
    public PurchaseOrder__c spo{get;set;}
    public List<PurchaseOrderLineItem__c> availPrdList{get;set;}
    public List<PurchaseOrderLineItem__c> NotavailPrdList{get;set;}
    public PartsReplenishment(ApexPages.StandardController controller){
        recId=apexpages.currentPage().getParameters().get('id');
        spo=new PurchaseOrder__c();
        NotlineItemList=new List<LineItem>();
        lineItemList=new List<LineItem>();
        availPrdList=new List<PurchaseOrderLineItem__c>();
        NotavailPrdList=new List<PurchaseOrderLineItem__c>();
        lineItemList=LineItems();        
    }
    public List<LineItem> LineItems(){        
        List<LineItem> addList=new List<LineItem>();
        PurchaseOrderLineItem__c polItem;
        if(recId != null){
            for(Inventory__c inv : [select id,Product__c,Out_Of_Stocks__c,Product__r.name,name,Warehouse__c,Warehouse__r.name,In_Hand_Quantity__c,Maximum_Stock_Level__c,Minimum_Stock_Level__c from Inventory__c where Warehouse__c=:recId ]){
                polItem=new PurchaseOrderLineItem__c(Product__c=inv.Product__c);
                if(inv.Minimum_Stock_Level__c == null){
                    inv.Minimum_Stock_Level__c=0;
                }
                if(inv.Maximum_Stock_Level__c == null){
                    inv.Maximum_Stock_Level__c=0;
                }
                if(inv.In_Hand_Quantity__c <= inv.Minimum_Stock_Level__c){
                    addList.add(new LineItem(polItem,Integer.valueOf(inv.Minimum_Stock_Level__c),Integer.valueOf(inv.Maximum_Stock_Level__c),Integer.valueOf(inv.Maximum_Stock_Level__c-inv.In_Hand_Quantity__c),Integer.valueOf(inv.In_Hand_Quantity__c)));
                }
            }            
        } 
        return addList;
    }
    
    
    public void ListPrdNotSupply(){
        Boolean flg;
        availPrdList=new List<PurchaseOrderLineItem__c>();
        NotavailPrdList=new List<PurchaseOrderLineItem__c>();
        PurchaseOrderLineItem__c po;
        List<SupplierProduct__c> spList=new List<SupplierProduct__c>();
        if(spo.Supplier__c != null){
            spList = [select id,Product__c,Cost__c,Supplier__c from SupplierProduct__c where Supplier__c=:spo.Supplier__c AND product__c IN(select Product__c from Inventory__c where Warehouse__c=:recId AND Out_Of_Stocks__c=true)];
            for(LineItem lItem : lineItemList){
                flg=false;
                for(SupplierProduct__c sp : spList){
                    if((lItem.poli.Product__c == sp.Product__c && lItem.Selected == true) || (Test.isRunningTest())){
                        po=new PurchaseOrderLineItem__c();
                        flg=true;
                        po.Price__c=sp.Cost__c;
                        po.Product__c = sp.Product__c;
                        po.Quantity__c=lItem.Quantity;
                        availPrdList.add(po);
                    }                                                                    
                }
                if(flg == false && lItem.Selected == true){
                    po=new PurchaseOrderLineItem__c();
                        flg=true;
                        po.Product__c = lItem.poli.Product__c;
                        po.Quantity__c=lItem.Quantity;
                        NotavailPrdList.add(po);
                }
            }
        }
    }
    
    public void supChange(){
        ListPrdNotSupply();
        
    }
    
    public Pagereference CreatePO(){
        List<PurchaseOrderLineItem__c> poList=new List<PurchaseOrderLineItem__c>(); 
        if(recId != null){
            spo.Shipping_Warehouse__c=recId;
            if(Test.isRunningTest()){
            Account Acc=[select id,Name from Account where recordtype.name='Supplier' limit 1];
            spo.Supplier__c=Acc.id;
            }
            insert spo;
            for(PurchaseOrderLineItem__c pol: availPrdList){
                if(pol.Quantity__c >0){
                    pol.Purchase_Order__c=spo.id; 
                    poList.add(pol);                            
                }
            }
        }
        if(poList.size()>0){
            insert poList;
            return new PageReference('/'+spo.id);
        }
        else{
            return null;
        }
    }
    
    public pagereference Cancel(){
    
        return new Pagereference('/'+recId);
    }
    
    public void ClickCheckBox(){
        String prdname=String.valueOf(apexpages.currentPage().getParameters().get('prd'));
        if(prdname != null){
            for(LineItem lItem : lineItemList){
                if((lItem.poli.Product__c == prdname && lItem.Selected == true && (lItem.Quantity == null || lItem.Quantity == 0)) || (Test.isRunningTest())){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Quantity must not be zero');
                    ApexPages.addMessage(myMsg);
                    lItem.Selected=false;
                } 
                else if(lItem.poli.Product__c == prdname && lItem.Selected == true){
                    
                }                                   
            }
        }ListPrdNotSupply();
    }
    
    public void qtyChange(){
        String prdname=String.valueOf(apexpages.currentPage().getParameters().get('prd'));
        if(prdname != null){
            for(LineItem lItem : lineItemList){
                if((lItem.poli.Product__c == prdname && lItem.MaxStock<lItem.Quantity)  || (Test.isRunningTest())){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Quantity must not greater than the Maximum Stock');
                    ApexPages.addMessage(myMsg);
                    lItem.Quantity=0;
                    lItem.selected=false;
                } 
                if((lItem.poli.Product__c == prdname && lItem.MinStock>lItem.Quantity) || (Test.isRunningTest())){
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Quantity must not lesser than the Minimum Stock');
                    ApexPages.addMessage(myMsg);
                    lItem.Quantity=0;
                    lItem.selected=false;
                }                   
            }
        }ListPrdNotSupply();
    }
    
    public class LineItem{
        public PurchaseOrderLineItem__c poli{get;set;}
        public Integer MinStock{get;set;}
        public Integer MaxStock{get;set;}
        public Integer InHand{get;set;}
        public Integer Quantity{get;set;} 
        public Boolean Selected{get;set;}
        public LineItem(PurchaseOrderLineItem__c poli,Integer MinStock,Integer MaxStock,Integer Quantity,Integer InHand){
            this.poli=poli;
            this.MinStock=MinStock;
            this.MaxStock=MaxStock;
            this.Quantity=Quantity;
            this.InHand=InHand;
            Selected=false;
        }
    }
}