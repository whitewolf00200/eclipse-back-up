public class SerialNumberEachProductController {
    
    public List<PurchaseOrderLineItem__c > PoliList;
    public String poId{get;set;}
    public String Jstring{get;set;}
    public string prd{get;set;}
    public Boolean viewState{get;set;}
    public string selectedId{get;set;}
    public string serialNO{get;set;}
    public SerialNumberEachProductController (){
        poId=ApexPages.currentPage().getParameters().get('id');
    }
   
   //POILList = [Select id, Name, Product__c, Quantity__c, Price__c, Description__c From Purchase_Order_Line_Item__c Where Supplier_Purchase_Order__c = : POId];
   
   public void getJstring(){
       Jstring=createJson();
   }
   
   public String createJson(){
           
           system.debug('-------Current----'+poId);
            JSONGenerator Jgen = JSON.createGenerator(true);  
              
              
               Jgen.writeStartArray(); 
               Integer j=1;   
             Map<Id,Product2> prdName=new  Map<id,Product2>([select id,Name from Product2]);
      for(PurchaseOrderLineItem__c poliPrd : [Select id, Name, Product__c, Quantity__c, Price__c,Description__c From PurchaseOrderLineItem__c Where Purchase_Order__c = : poId]){
            //PurchaseOrderLineItem__c poliPrd = [Select id, Name, Product__c, Quantity__c, Price__c, Description__c From PurchaseOrderLineItem__c Where Purchase_Order__c = : poId Limit 1];
           
                       
            Jgen.writeStartObject();  
           
            Jgen.writeStringField('product',prdName.get(poliPrd.Product__c).Name);
            Jgen.writeStringField('parentid', '-1');
            Jgen.writeStringField('serial','');
            Jgen.writeStringField('id',String.valueOf(j));
             Jgen.writeEndObject();           
            
            
            SerialNumberWrapper serialNoRow=new SerialNumberWrapper(poliPrd,'');
            

                  // Jgen.writeFieldName('children'); 
                  // Jgen.writeStartArray();
                                                       
                for(Integer i=1;i<=Integer.valueOf(poliPrd.Quantity__c);i++){   
                 
                    
                    Jgen .writeStartObject();   
                    Jgen.writeStringField('parentid',String.valueOf(j));
                    Jgen.writeStringField('id',String.valueOf(j+'-'+i));                
                    Jgen.writeStringField('product',prdName.get(serialNoRow.LineItem.Product__c).Name);
                    Jgen.writeStringField('serial',serialNoRow.SNumber);
                    Jgen.writeBooleanField('isFolder',true); 
                    
                     Jgen.writeEndObject();
                                   
                  
                }  
                j+=1;              
                 // Jgen.writeEndArray();    
                  //   Jgen.writeEndObject();
                
               
                
                          
      }
      Jgen.writeEndArray();
      String str = Jgen.getAsString();
      system.debug('-------JSON----'+str);
      return str;
   }
   
   public void viewselectedItem(){
       viewState=true;
   }
   
   public void InsertInventory(){
       /*Inventory_Transaction__c insertinvT;
       Inventory_Transaction__c getinvT;
       if(prd != null){
           getinvT=[select id,SerialId__c,SerialNumber__c from Inventory_Transaction__c where SerialId__c =:prd];
           if(getinvT.SerialId__c == null){
               PurchaseOrder__c po=[select id, Shipping_Warehouse__c from PurchaseOrder__c where id=:poId];
               if(po.Shipping_Warehouse__c !=null){
                   Inventory__c inv=[select id, Warehouse__c,product__c from Inventory__c where Warehouse__c =:po.Shipping_Warehouse__c];
                   if(inv.product__c !=null && inv.product__c !=prd && serialNO != null){
                       insertinvT=new Inventory_Transaction__c(Inventory__c=inv.id, SerialId__c=selectedId, SerialNumber__c=serialNO, Transaction_Type__c='Added');
                       insert insertinvT;
                   }
                   else if(inv.product__c == null && serialNO != null){
                       Inventory__c insertInv=new Inventory__c(Warehouse__c=po.Shipping_Warehouse__c);
                       insert insertInv;
                       insertinvT=new Inventory_Transaction__c(Inventory__c=insertInv.id, SerialId__c=selectedId, SerialNumber__c=serialNO, Transaction_Type__c='Added');
                       insert insertinvT;
                   }
               }
               //Inventory_Transaction__c insertInvT=new Inventory_Transaction__c();
           }
       }*/
   }
   
   public class SerialNumberWrapper{
       public PurchaseOrderLineItem__c LineItem{get;set;}
       public String SNumber{get;set;}
       
       public SerialNumberWrapper(PurchaseOrderLineItem__c LI,String sn){
           LineItem=LI;
           SNumber=sn;
       }
   }
}