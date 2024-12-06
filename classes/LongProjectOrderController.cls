public with sharing class LongProjectOrderController {
public String MasterRecordId;
 
    public opportunity[] ChildRecords{get; set;}
    public List<SalesOrderLineItems__c> salesoli  {get; set;}
    public SalesOrder__c MasterRecord{get; set;}
     public opportunity pro{get;set;}
    public String prono{get;set;}
    public Boolean checked{get;set;}
    
    public LongProjectOrderController()
    {
    system.debug('constructor>>>>>>>>');
      
}

 public String getMasterRecordId (){        
        return MasterRecordId ;
    }
    public void setMasterRecordId (String msid){
        this.MasterRecordId =msid;
        system.debug('MasterRecordId ========'+MasterRecordId );
        if(!String.isBlank(MasterRecordId)){
          Proj();
       }
        
    }

public void Proj(){
MasterRecord =
                [
                    SELECT 
                        Invoice_Address__c,
                        Delivery_Address__c,
                        Due_Date__c,Account__r.Site_Contact__r.Name,Name,CreatedBy.Name,CreatedDate,Account__r.Parent_SAGE_ID__c,Fax__c,Email__c,Phone__c,
                        Account__r.Name,Account__r.Site_Invoice_Name__c,Total_Price__c,Vat_Total__c,Order_Total__c  
                    FROM
                        SalesOrder__c
                    WHERE
                        Id = :MasterRecordId
                ];
                system.debug('<<<<<<>>>>>>>>>');
                /** ChildRecords =
                 [
                    SELECT 
                          Delivery_Address__c,Billing_Street__c,Billing_City__c,Billing_State__c,Billing_Country__c,Billing_Postal_Code__c,Schedule_of_Work__c
                    FROM
                        opportunity
                    WHERE 
                        Long_Project_Order__c = :MasterRecordId order by createddate desc limit 1
                ];**/
            /*     system.debug('###########################');
               system.debug(''+ChildRecords);
                    checked=true;
                    For(opportunity po:ChildRecords){
                    if(((po.Room1_Dispensors_Include_In_Print__c)==checked) &&(po.Room1_Dispensors__c==null))
                    {
                        po.Room1_Dispensors__c='None';
                        system.debug(''+po.Room1_Dispensors__c);
                    }
                        
                        
                        if(((po.Room1_Splashbacks_Include_In_Print__c)==checked) &&(po.Room1_Splashbacks__c==null)) {
                            po.Room1_Splashbacks__c='None';
                            system.debug(''+po.Room1_Splashbacks__c); */
                        
                        
        
                

              salesoli=
                [
                    SELECT 
                        Price__c,
                        Product__c,
                        Quantity__c,
                        Product__r.Stock_Unit__c,
                        Extended_Sales_Description__c,
                        Show_Description__c ,
                        Sales_Description__c,
                        Total_Price__c,Product__r.Name
                    FROM
                        SalesOrderLineItems__c
                    WHERE 
                        Sales_Order__c= :MasterRecordId
                ];
                
    
}
}