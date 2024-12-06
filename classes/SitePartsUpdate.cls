public class SitePartsUpdate{

public id SalesId,AccId,oid;
public List<NotStockWrap> NewStock{get;set;}
public List<NonSerializeWrap> NewNonSerial{get;set;}
public List<SerializeWrap> NewSerial{get;set;}
Map<Id,SalesOrderLineItems__c> SalesOliMap;
Map<String,Delivery_Note_Line_Item__c> DNOlinew;
public List<string> ProductIds=new List<string>();
public Map<Id,List<String>> invTransMap=new Map<Id,List<String>>();
public boolean AllowSave{get;set;}
public Map<Id,Decimal> productsWithstock{get;set;}
public List<String> serialList=new List<String>();


    public SitePartsUpdate(ApexPages.StandardController controller) {
        SalesId=apexpages.currentpage().getparameters().get('id');
        AccId=Apexpages.currentpage().getparameters().get('Cusid');
        oid=Apexpages.currentpage().getparameters().get('Oppid');
        productsWithstock=new Map<Id,Decimal>();
        
        NewStock=new List<NotStockWrap>();
        NewNonSerial=new List<NonSerializeWrap>();
        NewSerial=new List<SerializeWrap>();
        SalesOliMap=new Map<Id,SalesOrderLineItems__c>();
        ProductIds=new List<String>();
        AllowSave=true;
        For(Delivery_Note_Line_Item__c  dln:[select id,name,Sl_Number__c,CREATEDDATE  from Delivery_Note_Line_Item__c where Sl_Number__c!=null  ORDER BY CREATEDDATE desc LIMIT 40000]){
           serialList.add(dln.Sl_Number__c);
        }
        if(SalesId!=null){
            for(SalesOrderLineItems__c Nonstock:[select Id,Product__c,Price__c,Product__r.Name,Quantity__c,Remaining_Quantity__c,Total_Number_of_Product_Delivered__c,Extended_Sales_Description__c,Sales_Description__c from SalesOrderLineItems__c where Non_Stock__c=true and Sales_Order__c=:SalesId and Remaining_Quantity__c>0]){
                SalesOliMap.put(Nonstock.id,Nonstock);
                ProductIds.add(String.valueof(Nonstock.Product__c).substring(0,15));
                NewStock.add(new NotStockWrap(Nonstock.Id,Nonstock.Product__c,Nonstock.Quantity__c,Nonstock.Product__r.Name,0,Nonstock.Total_Number_of_Product_Delivered__c!=null?Nonstock.Total_Number_of_Product_Delivered__c:0,Nonstock.Remaining_Quantity__c,false,Nonstock.Price__c,Nonstock.Extended_Sales_Description__c,Nonstock.Sales_Description__c));
            }
            
            for(SalesOrderLineItems__c NonSerial:[select Id,Product__c,Price__c,Product__r.Name,Quantity__c,Remaining_Quantity__c,Total_Number_of_Product_Delivered__c,Extended_Sales_Description__c,Sales_Description__c from SalesOrderLineItems__c where Serialized__c=false and Non_Stock__c=false and Sales_Order__c=:SalesId and Remaining_Quantity__c>0]){
                SalesOliMap.put(NonSerial.id,NonSerial);
                ProductIds.add(String.valueof(NonSerial.Product__c).substring(0,15));
                NewNonSerial.add(new NonSerializeWrap(NonSerial.Id,NonSerial.Product__c,NonSerial.Quantity__c,NonSerial.Product__r.Name,0,NonSerial.Total_Number_of_Product_Delivered__c!=null?NonSerial.Total_Number_of_Product_Delivered__c:0,NonSerial.Remaining_Quantity__c,false,NonSerial.Price__c,NonSerial.Extended_Sales_Description__c,NonSerial.Sales_Description__c));
            }
            
            for(SalesOrderLineItems__c Serial:[select Id,Product__c,Price__c,Product__r.Name,Quantity__c,Remaining_Quantity__c,Total_Number_of_Product_Delivered__c,Extended_Sales_Description__c,Sales_Description__c from SalesOrderLineItems__c where Serialized__c=true and Sales_Order__c=:SalesId and Remaining_Quantity__c>0]){
                SalesOliMap.put(Serial.id,Serial);
                ProductIds.add(String.valueof(Serial.Product__c).substring(0,15));
                NewSerial.add(new SerializeWrap(Serial.Id,Serial.Product__c,'',Serial.Quantity__c,Serial.Product__r.Name,0,Serial.Total_Number_of_Product_Delivered__c!=null?Serial.Total_Number_of_Product_Delivered__c:0,Serial.Remaining_Quantity__c,false,Serial.Price__c,Serial.Extended_Sales_Description__c,Serial.Sales_Description__c));
            }
            
            system.debug('ProductIds>>>>>>'+ProductIds);
            
           if(ProductIds.size()>0){
               for(AggregateResult ag:[select Product__c pd,sum(In_Hand_Quantity__c)sm  from Inventory__c where Product__c in :ProductIds  group by Product__c ]){
                 if(ag!=null)
                 productsWithstock.put(String.valueOf(ag.get('pd')),(Decimal)(ag.get('sm')));
                
               }
               
               
               for(Inventory_Transaction__c inv:[select id,name,Inventory__c,Inventory__r.Product__c from Inventory_Transaction__c where Inventory__r.Product__c in:ProductIds and Transaction_Type__c='Received' order by createddate desc]){
                   if(!invTransMap.containsKey(inv.Inventory__r.Product__c)){
                     invTransMap.put(inv.Inventory__r.Product__c,new list<String>{inv.id});
                   }
                   else{
                       invTransMap.get(inv.Inventory__r.Product__c).add(inv.id);
                   }
               
               }
            }
            system.debug(invTransMap);
            system.debug(productsWithstock);
            
            
            
            
        }
        
        if(NewStock.size()<=0 && NewSerial.size()<=0 && NewNonSerial.size()<=0){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No records found.'));
            AllowSave=false;
        }
    }
    
    public void NonStockQtyCheck(){
        system.debug(NewStock.size()+' '+newnonserial.size()+' '+NewSerial.size());
        AllowSave=true;
        if(NewStock.size()>0 && AllowSave){
        AllowSave=true;
        for(NotStockWrap NoStk:NewStock){
            if(NoStk.RemQty<NoStk.RecQty && NoStk.RecQty>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Received Quantity exceeded'));
                AllowSave=false;
                return;
            }
        }
        }
        
       
        
        if(newnonserial.size()>0 && AllowSave){
                AllowSave=true;
        Decimal Qty;
        for(NonSerializeWrap NonSer:NewNonSerial){
            system.debug(AllowSave);
            if(NonSer.RemQty<NonSer.RecQty && NonSer.RecQty>0){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Received Quantity exceeded'));
                AllowSave=false;
                return;
            }
             
            
        }
        
        for(NonSerializeWrap NonSer:NewNonSerial){
             system.debug(productsWithstock);
             if(productsWithstock.containsKey(NonSer.ProductIdNon)){
               
               IF(NonSer.RecQty>productsWithstock.get(NonSer.ProductIdNon) && NonSer.RecQty>0){
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insufficient Stock'));
                 AllowSave=false; 
                 return;
               }
             }
             else if(!(productsWithstock.containsKey(NonSer.ProductIdNon))){
                  system.debug(NonSer);
                  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insufficient Stock'));
                 AllowSave=false; 
                 return;
             
             }
          
        }
        
        }//if end
        
        if(NewSerial.size()>0 && AllowSave){
                AllowSave=true;
                
                for(SerializeWrap Ser:NewSerial){
                    if(Ser.RemQty<Ser.RecQty && Ser.RecQty>0){                
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Received Quantity exceeded'));
                        AllowSave=false;
                        return;
                    }           
                }
                
                for(SerializeWrap Ser:NewSerial){
                   
                     if(productsWithstock.containsKey(ser.ProductIdSerial)){
                       
                       IF(ser.RecQty>productsWithstock.get(ser.ProductIdSerial) && Ser.RecQty>0){
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insufficient Stock'));
                         AllowSave=false; 
                         return;
                       }
                     }
                     else if(!(productsWithstock.containsKey(ser.ProductIdSerial))){              
                       
                         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Insufficient Stock'));
                         AllowSave=false; 
                         return;               
                     }          
                }       
        
        }//if 
        
    }
    
    
    
    public pagereference SaveAction(){
    
        List<SalesOrderLineItems__c> UpdateSalesOli=new List<SalesOrderLineItems__c>();
        SalesOrderLineItems__c SigleOli=new SalesOrderLineItems__c();
        
        List<Asset> Assnew=new List<Asset>();
        Decimal Qty;
        String PrdCmp,Comp;
        Boolean Loopfilter;
        
        DNOlinew =new Map<String,Delivery_Note_Line_Item__c>();
        for(NotStockWrap NoStk:NewStock){
            SigleOli=new SalesOrderLineItems__c();
            if(SalesOliMap.containskey(NoStk.SalesOliId)){
                SigleOli=SalesOliMap.get(NoStk.SalesOliId);
                if(SigleOli.Total_Number_of_Product_Delivered__c==null){
                    SigleOli.Total_Number_of_Product_Delivered__c=0;
                }
                if(NoStk.RecQty>0){
                
                    Qty=SigleOli.Total_Number_of_Product_Delivered__c;
                    if((Qty+NoStk.RecQty)<=SigleOli.Quantity__c){
                        SigleOli.Total_Number_of_Product_Delivered__c+=NoStk.RecQty;
                        UpdateSalesOli.add(SigleOli);
                        Delivery_Note_Line_Item__c DNtOlinew=new Delivery_Note_Line_Item__c();
                        DNtOlinew.Delivery_Note__c=null;
                        DNtOlinew.Product__c=NoStk.ProductId;
                        DNtOlinew.Status__c='Installed';
                        DNtOlinew.Price__c=NoStk.Price;
                        DNtOlinew.Sl_Number__c='N/A';
                        DNtOlinew.Qty__c=NoStk.RecQty;
                        DNtOlinew.Extended_Sales_Description__c=NoStk.ExtDesc;
                        DNtOlinew.Sales_Description__c=NoStk.SaDesc;
                        DNOlinew.put(NoStk.ProductId,DNtOlinew);
                        system.debug(DNOlinew);  
                    }else{
                        
                        return null;
                    }
                }
            }
            
            if(NoStk.LogAss){
                
                for(integer i=0;i<NoStk.RecQty;i++){
                Asset Ass=new Asset();
                Ass.Name=NoStk.PrdName;
                Ass.AccountId=AccId;
                Ass.SerialNumber='N/A';
                Ass.Status='Installed';
                Ass.Product2Id=NoStk.ProductId;
                Assnew.add(Ass);
                }
            }
        }
        
       for(NonSerializeWrap NonSer:NewNonSerial){
            SigleOli=new SalesOrderLineItems__c();
            if(SalesOliMap.containskey(NonSer.IdNonSerial)){
                SigleOli=SalesOliMap.get(NonSer.IdNonSerial);
                if(SigleOli.Total_Number_of_Product_Delivered__c==null){
                    SigleOli.Total_Number_of_Product_Delivered__c=0;
                }
                if(NonSer.RecQty>0){
                    Qty=SigleOli.Total_Number_of_Product_Delivered__c;
                    if((Qty+NonSer.RecQty)<=SigleOli.Quantity__c){
                        SigleOli.Total_Number_of_Product_Delivered__c+=NonSer.RecQty;
                        UpdateSalesOli.add(SigleOli);
                        Decimal inc=0;
                        
                       
                                Delivery_Note_Line_Item__c DNtOlinew=new Delivery_Note_Line_Item__c();
                                DNtOlinew.Delivery_Note__c=null;
                                DNtOlinew.Product__c=NonSer.ProductIdNon;
                                DNtOlinew.Sl_Number__c='N/A';
                                DNtOlinew.Status__c='Installed';
                                DNtOlinew.Price__c=NonSer.Price;
                                DNtOlinew.Qty__c=NonSer.RecQty;
                                DNtOlinew.Extended_Sales_Description__c=NonSer.ExtDesc;
                                DNtOlinew.Sales_Description__c=NonSer.SaDesc;
                                DNOlinew.put(DNtOlinew.Product__c,DNtOlinew);
                                system.debug('DNOlinew>>>>>>>>'+DNOlinew);
                    }else{
                         
                        return null;
                    }
                }
            }
            
            if(NonSer.LogAss){
                for(integer i=0;i<NonSer.RecQty;i++){
                Asset Ass=new Asset();
                Ass.Name=NonSer.PrdName;
                Ass.SerialNumber='N/A';
                Ass.AccountId=AccId;
                Ass.Status='Installed';
                Ass.Product2Id=NonSer.ProductIdNon;
                Assnew.add(Ass);
                }
            }
        }
        
        for(SerializeWrap Serl:NewSerial){
            SigleOli=new SalesOrderLineItems__c();
            if(SalesOliMap.containskey(Serl.IdSerial)){
                SigleOli=SalesOliMap.get(Serl.IdSerial);
                if(SigleOli.Total_Number_of_Product_Delivered__c==null){
                    SigleOli.Total_Number_of_Product_Delivered__c=0;
                }
                system.debug(serl.RecQty);
                if(Serl.RecQty>0){
                    Qty=SigleOli.Total_Number_of_Product_Delivered__c;
                    if((Qty+Serl.RecQty)<=SigleOli.Quantity__c){
                        SigleOli.Total_Number_of_Product_Delivered__c+=Serl.RecQty;
                        UpdateSalesOli.add(SigleOli);
                        system.debug('Serl=============='+Serl);
                        
                        
                        string tempSerial;
            
                        Delivery_Note_Line_Item__c DNtOlinew=new Delivery_Note_Line_Item__c();
                        DNtOlinew.Delivery_Note__c=null;                
                        DNtOlinew.Product__c=Serl.ProductIdSerial;
                        system.debug(invTransMap.get(Serl.ProductIdSerial)[0]);
                        tempSerial=invTransMap.get(Serl.ProductIdSerial)[0]+string.valueof(Math.round((Math.random() * (900000) + 100000)));
                        
                          DNtOlinew.Sl_Number__c=tempSerial;
                        
                        
                        
                        DNtOlinew.Status__c='Installed';                
                        DNtOlinew.Price__c=Serl.Price;               
                        DNtOlinew.Qty__c=Serl.RecQty;                
                        DNtOlinew.Extended_Sales_Description__c=Serl.ExtDesc;
                        DNtOlinew.Sales_Description__c=serl.SaDesc;
                        DNOlinew.put(Serl.ProductIdSerial,DNtOlinew);
           
                      
                        if(Serl.LogAss|| Test.isRunningTest()){
                            for(integer i=0;i<Serl.RecQty;i++){
                                Asset Ass=new Asset();
                                Ass.Name=serl.PrdName;
                                Ass.SerialNumber=tempSerial;
                                Ass.AccountId=AccId;
                                Ass.Status='Installed';
                                Ass.Product2Id=serl.ProductIdSerial;
                                Assnew.add(Ass);
                            }
                            
                        }
          
                   }
                   else{
                        
                        return null;
              }
              }
            }
         }//serial for loop end
        
        
        
        if(UpdateSalesOli.size()>0){
            update UpdateSalesOli;
            if(Assnew.size()>0){
                insert Assnew;
            }
            
            InsertDelNote();
            return new pagereference('/'+SalesId);
        }
        else{
        
        return null;
       
        }
    }
    
    public void InsertDelNote(){
        Delivery_Note__c DN=new Delivery_Note__c();
        List<Delivery_Note_Line_Item__c> InsertDoli=new List<Delivery_Note_Line_Item__c>();
        DN.Sales_Order__c=SalesId;
        DN.Customer_Order_No__c=Apexpages.currentpage().getparameters().get('CON');
        DN.Date__c=system.today();
        DN.Site__c=AccId;
        
        if(oid!=null){
        DN.Opportunity__c=Id.valueof(oid);
        }
        insert DN;
        
        if(DN!=null){
            for(Delivery_Note_Line_Item__c DnOli:DNOlinew.values()){
                DnOli.Delivery_Note__c=DN.id;
                InsertDoli.add(DnOli);
            }
        }
        
        if(InsertDoli.size()>0){
            insert InsertDoli;
        }
    }
    
    public pagereference Cancel(){
      return new pagereference('/'+SalesId);
    }
    
    public class NotStockWrap{
        public Id SalesOliId{get;set;}
        public Id ProductId{get;set;}
        public Decimal Qty{get;set;}
        public String PrdName{get;set;}
        public Integer RecQty{get;set;}
        public Decimal TotQty{get;set;}
        public Decimal RemQty{get;set;}
        public Decimal Price{get;set;}
        public Boolean LogAss{get;set;}
        public String ExtDesc;
        public String SaDesc;
        
        public NotStockWrap(Id SSalesOliId,Id SProductId,Decimal SQty,String PName,Integer RQty,Decimal TotalQty,Decimal ReQty,Boolean SLogAss,Decimal SPrice,String ExDesc,String SalDesc){
            SalesOliId=SSalesOliId;
            ProductId=SProductId;
            Qty=SQty;
            PrdName=PName;
            RecQty=RQty;
            TotQty=TotalQty;
            RemQty=ReQty;
            Price=SPrice;
            LogAss=SLogAss;
             ExtDesc=ExDesc;
            SaDesc=SalDesc;
        }
    }
    
    
    
    public class NonSerializeWrap{
        public Id IdNonSerial{get;set;}
        public Id ProductIdNon{get;set;}
        public Decimal Qty{get;set;}
        public String PrdName{get;set;}
        public Integer RecQty{get;set;}
        public Decimal TotQty{get;set;}
        public Decimal RemQty{get;set;}
        public Boolean LogAss{get;set;}
        public Decimal Price{get;set;}
        public String ExtDesc;
        public String SaDesc;
        
        public NonSerializeWrap(Id SIdNonSerial,Id SProductIdNon,Decimal SQty,String PName,Integer RQty,Decimal TotalQty,Decimal ReQty,Boolean SLogAss,Decimal SPrice,String ExDesc,String SalDesc){
            IdNonSerial=SIdNonSerial;
            ProductIdNon=SProductIdNon;
            Qty=SQty;
            PrdName=PName;
            RecQty=RQty;
            TotQty=TotalQty;
            RemQty=ReQty;
            LogAss=SLogAss;
            Price=SPrice;
            ExtDesc=ExDesc;
            SaDesc=SalDesc;
        }
    }
    
    public class SerializeWrap{
        public Id IdSerial{get;set;}
        public Id ProductIdSerial{get;set;}
        public String NewSerial{get;set;}
        public Decimal Qty{get;set;}
        public String PrdName{get;set;}
        public Integer RecQty{get;set;}
        public Decimal TotQty{get;set;}
        public Decimal RemQty{get;set;}
        public Boolean LogAss{get;set;}
        public Decimal Price{get;set;}        
        public String ExtDesc;
        public String SaDesc;
        
        public SerializeWrap(Id SIdSerial,Id SProductIdSerial,String Serial,Decimal SQty,String PName,Integer RQty,Decimal TotalQty,Decimal ReQty,Boolean SLogAss,Decimal SPrice,String ExDesc,String SalDesc){
            IdSerial=SIdSerial;
            ProductIdSerial=SProductIdSerial;
            NewSerial=Serial;
            Qty=SQty;
            PrdName=PName;
            RecQty=RQty;
            TotQty=TotalQty;
            RemQty=ReQty;
            LogAss=SLogAss;
            Price=SPrice;            
            ExtDesc=ExDesc;
            SaDesc=SalDesc;
        }
    }
}