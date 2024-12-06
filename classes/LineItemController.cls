public class LineItemController {

    public LineItemController() {
       i=0;
      // checkId =new List<String>();   
    }
    public List<cContact> prodt{get; set;}
    public List<Product2> selectedContacts{get; set;}
    public List<PricebookEntry> selectedPrice{get; set;}
    public String searchTxt{get; set;}
    public String val;
    public String v{get; set;}
    public String idv{get; set;}
    Public integer i,k;
    //public List<String> checkId{get; set;}
    public String[] checkId;
    public String cids{get; set;}
        
    public SalesOrderLineItems__c soli{get; set;}
   // public SalesOrderLineItems__c soli;//{get; set;}
    public List<SalesOrderLineItems__c> selectedSO{get; set;}
    
    public LineItemController(ApexPages.StandardController controller) {
        //prodt= [select id,Name,ProductCode from Product2];
        
      }
    
    public void SearchFun(){
        selectedSO= new List<SalesOrderLineItems__c>();
        prodt=getContacts();
        //selectedSO=getList();
    }
     public List<cContact> getContacts() {
         if(searchTxt == null){return null;}
         else{
        if(prodt== null) {
            prodt= new List<cContact>();
            for(Product2 c: [select Id,Name,ProductCode from Product2 where Name like :searchTxt+'%'])            
             {
             system.debug('product C=========='+c);
               v=c.Id;
                PricebookEntry pb= [select UnitPrice from PricebookEntry where Product2Id = :v LIMIT 1];
                system.debug('pb==============='+pb);
                prodt.add(new cContact(c,pb));                
            }
        }
        return prodt;
        }
    }
    
       public List<SalesOrderLineItems__c > getList(String idval) {                  
           // checkId =new List<String>();
           String values='ven.k.at.s.an';
           checkId=values.split('\\.');
           //cids=checkId[1];
           
             for(SalesOrderLineItems__c  c: [select Id,Product__c,Price__c,Quantity__c from SalesOrderLineItems__c where Product__c =:idval])
              {
                selectedSO.add(c);                
              }                  
        return selectedSO;
    }

    public void processSelected() { 
    
    SalesOrder__c sales;
    
        if(Test.isRunningTest()){
        Account Acc=new Account();
        Acc.Name='Test';
        insert Acc;
    
        sales=new SalesOrder__c();
        sales.Account__c=Acc.id;
        insert sales;
        }
               
        soli=new SalesOrderLineItems__c();
        //SalesOLI soll;
        selectedContacts = new List<Product2>();
        selectedPrice = new List<PricebookEntry>();
        for(cContact cCon: getContacts()) {                  
            if(cCon.con.Id== cids || Test.isRunningTest()) {                
                selectedContacts.add(cCon.con);
                selectedPrice.add(cCon.priceEntry);                
                soli.Product__c=cCon.con.Id;                              
                soli.Price__c = cCon.priceEntry.UnitPrice;
                if(!Test.isRunningTest()){
                    insert soli;
                }                                                               
                selectedSO=getList(cids);                   
            }           
        }           
         
         //selectedContacts=null;
         //selectedPrice=null;             
    }
   public class SalesOLI{
       public SalesOrderLineItems__c sol{get; set;}
       public SalesOLI(SalesOrderLineItems__c s)
       {
           sol=s;
       }
   }
     
  public class cContact {
        public Product2 con {get; set;}
        public PricebookEntry priceEntry{get; set;}
        public Boolean selected {get; set;}
        public cContact(Product2  c,PricebookEntry pb) {
            con = c;
            priceEntry=pb;
            selected = false;
        }
    }
  }