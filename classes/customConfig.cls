public class customConfig {

public Config__c configvalue{get;set;}
public Config__c cust{get;set;}

public customConfig(){
configvalue = [select Header__c,Background_Colour__c,Product_Table_Colour__c,Footer_Line_1__c,Footer_Line_2__c,Header_Title__c,Invoice_Background__c     from Config__c Limit 1];
   }

public pageReference SAVE()
{

if(configvalue != null)
{
    update configvalue;
}
return null;

} 
 
}