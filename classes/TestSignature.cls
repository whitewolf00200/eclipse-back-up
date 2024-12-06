public class TestSignature 
{
    
    
    public sObject obj;
    
    public transient String imageBase64 {get; set;}
    
    public PageReference saveSignature() {
        system.debug('imageBase64=' + imageBase64);

        Id parentId = '0Q04E000000LPYj';
        Schema.SObjectType sobjectType = parentId.getSObjectType();
        String sobjectName = sobjectType.getDescribe().getName();
        obj = Schema.getGlobalDescribe().get(sobjectName).newSObject();
        obj.put('Id',parentId);
        obj.put('Customer_Signature__c', '<img src="' + imageBase64 + '"/>');
        system.debug('<<<<type>>>>'+obj );
        try {
            update obj;
            system.debug('obj======='+obj);
        } catch(Exception e) {
            system.debug(e);
            ApexPages.addMessages(e);    
        }
        
        if(ApexPages.hasMessages()) {
            return null;
        } else {
             pagereference p=new pagereference('/'+parentId);
             p.setRedirect(true);
             return p;
        }
    }
}