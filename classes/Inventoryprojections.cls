public class Inventoryprojections {
   
        
    public List<PurchaseOrderLineItem__c> poliList{get;set;}
    public List<OrderItem> ordliList{get;set;}
    public String recId;
    public List<Date> nextSevenDays{get;set;}
    public List<String> nextSevenDaysStr{get;set;}
    public List<Inventory__c> invList{get;set;}
    public Map<String,Integer> poli;
    public Map<String,Integer> oli;
    public Map<String,Integer> InvProject{get;set;} 
    public Map<String,Date> dispday{get;set;} 
    public Map<String,boolean> dispdayInhand{get;set;} 
    public Date SelectDated{get;set;}
    public List<individuals> oneDay{get;set;}
    public String strd{get;set;}
    public Inventoryprojections(ApexPages.StandardController controller) {
        recId=apexpages.currentpage().getparameters().get('id');
         oneDay=new List<individuals>();
        nextSevenDays=new List<Date>();
        poli=new Map<String,Integer>();
        oli=new Map<String,Integer>();
        InvProject=new Map<String,Integer>();
        nextSevenDays.add(System.today());
        nextSevenDays.add(System.today()+1);
        nextSevenDays.add(System.today()+2);
        nextSevenDays.add(System.today()+3);
        nextSevenDays.add(System.today()+4);
        nextSevenDays.add(System.today()+5);
        nextSevenDays.add(System.today()+6);
        nextSevenDays.add(System.today()+7);
        nextSevenDaysStr=new List<String>();
        dispday=new Map<String,Date>();
        dispdayInhand=new Map<String,boolean>();
        strd=String.valueOf(convertDate(System.today()));
        for(Date dt:nextSevenDays){
            nextSevenDaysStr.add(String.valueOf(dt)); 
            if(dt== system.today()){
                dispdayInhand.put(String.valueOf(dt),true);
            }else{
                dispdayInhand.put(String.valueOf(dt),false);
            }      
            dispday.put(String.valueOf(dt),dt);
            system.debug('String.valueOf(dt)=='+String.valueOf(dt));
        }
        
        poliList=new List<PurchaseOrderLineItem__c>();
        
        poliList=[select id,Purchase_Date__c,Purchase_Order__c,Product__c,Quantity__c from PurchaseOrderLineItem__c where Purchase_Order__c IN(select id from PurchaseOrder__c where Shipping_Warehouse__c=:recId)];
        List<AggregateResult> poresult=new List<AggregateResult>();
        List<AggregateResult> ordresult=new List<AggregateResult>();
        poresult=[select Purchase_Date__c,Purchase_Order__r.Shipping_Warehouse__c,Product__c,sum(Quantity__c) qty from PurchaseOrderLineItem__c group by Product__c,Purchase_Date__c,Purchase_Order__r.Shipping_Warehouse__c having Purchase_Order__r.Shipping_Warehouse__c=:recId];
        ordresult=[select Sold_Date__c,PricebookEntry.Product2Id prd,Order.Warehouse__c,sum(Quantity) qty from OrderItem group by PricebookEntry.Product2Id,Sold_Date__c,Order.Warehouse__c having Order.Warehouse__c=:recId];
        
        for(date d:nextSevenDays){
            for(AggregateResult rs:poresult){
                System.debug('rs=='+rs.get('Product__c'));
                if(convertDate(date.valueOf(rs.get('Purchase_Date__c')))==d){
                    poli.put(String.valueOf(d)+rs.get('Product__c'),integer.valueOf(rs.get('qty')));
                }
            }
        }
        for(date d:nextSevenDays){
            for(AggregateResult rs:ordresult){
                if(convertDate(date.valueOf(rs.get('Sold_Date__c')))==d){
                    oli.put(String.valueOf(d)+rs.get('prd'),integer.valueOf(rs.get('qty')));
                }
            }
        }
        invList=new List<Inventory__c>();
        invList=[Select id,Product__c,Product__r.name,In_Hand_Quantity__c from Inventory__c where Warehouse__c=:recId];
        for(Inventory__c inv:invList){
            for(date d:nextSevenDays){
                
                System.debug('poli=='+poli);
                System.debug('oli=='+oli.get(String.valueOf(String.valueOf(d)+inv.Product__c)));
                Integer i;
                Integer j;
                if(poli.get(String.valueOf(String.valueOf(d)+inv.Product__c)) != null ){
                    i=Integer.valueOf(poli.get(String.valueOf(String.valueOf(d)+inv.Product__c)));
                }
                else{
                    i=0;
                }
                if(oli.get(String.valueOf(String.valueOf(d)+inv.Product__c)) != null){
                    j=Integer.valueOf(poli.get(String.valueOf(String.valueOf(d)+inv.Product__c)));
                }
                else{
                    j=0;
                }
                if(InvProject.get(String.valueOf(convertDate(d-1))+inv.Product__c)!=null){
                    InvProject.put(String.valueOf(convertDate(d))+inv.Product__c,Integer.valueOf(InvProject.get(String.valueOf(convertDate(d-1))+inv.Product__c))+i-j);
                }
                else{
                InvProject.put(String.valueOf(convertDate(d))+inv.Product__c,Integer.valueOf(inv.In_Hand_Quantity__c)+i-j);
                }
                system.debug('InvProject=='+InvProject);
            } 
        }       
    }
    
    public Pagereference individual(){    
        oneDay=new List<individuals>();
        system.debug('SelectDated==='+SelectDated);
        if(SelectDated < System.today() || SelectDated ==null){
            apexpages.Message msg = new Apexpages.Message(ApexPages.Severity.ERROR,'The projection cannot be shown previous days' );
            apexpages.addmessage(msg);
            return null;
        }
        List<PurchaseOrderLineItem__c> polist=new List<PurchaseOrderLineItem__c>();
        List<OrderItem> ordlist=new List<OrderItem>();
        if(recId !=null){
            polist=[select id,Purchase_Date__c,Purchase_Order__c,Product__c,Quantity__c from PurchaseOrderLineItem__c where Purchase_Order__r.Shipping_Warehouse__c=:recId];
            ordlist=[select Id,Sold_Date__c,PricebookEntry.Product2Id,Quantity, OrderId from OrderItem where Order.Warehouse__c=:recId];
        }
        for(Inventory__c inv:invList){
            Integer i=0;
            Integer j=0;
            Integer k=Integer.valueOf(inv.In_Hand_Quantity__c);
           for(PurchaseOrderLineItem__c pol:polist){
               if(inv.Product__c == pol.Product__c && pol.Purchase_Date__c<=SelectDated && pol.Purchase_Date__c>=System.today()){
                   system.debug('pol.Purchase_Date__c==='+pol.Purchase_Date__c);                   
                   i+=Integer.valueOf(pol.Quantity__c);
               }
           } 
           for(OrderItem ol:ordlist){
               if(inv.Product__c == ol.PricebookEntry.Product2Id && ol.Sold_Date__c<=SelectDated && ol.Sold_Date__c>=System.today()){                   
                   j+=Integer.valueOf(ol.Quantity);                   
               }
           }
           oneDay.add(new individuals(inv.Product__r.name,Integer.valueOf(inv.In_Hand_Quantity__c),k+i-j));
           system.debug('oneDay==='+oneDay);
        }
        return null;
    }
    
    public date convertDate(Date dt){
        System.debug('dt=='+dt);
        if(dt !=null){
            date d;
            String str=dt.year()+'-'+dt.month()+'-'+dt.day();
            d=Date.valueOf(str);
            system.debug('d==='+d);
            return d;
        }
        return null;
    }
    public class individuals{
        public String product{get;set;}
        public Integer Qty{get;set;}
        public Integer Inhand{get;set;}
        public individuals(String product,Integer Inhand,Integer Qty){
            this.product=product;
            this.Inhand=Inhand;
            this.Qty=Qty;
        }
    }
}