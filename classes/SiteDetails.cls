public class SiteDetails{
public List<SiteContracts__c> merch{get;set;}
private ApexPages.StandardSetController standardController;
public List<Id> selectedId;
public List<SiteContracts__c> selectedAccs;

 public SiteDetails(ApexPages.StandardSetController controller) { 
     standardController=controller;
     merch=new List<SiteContracts__c>();
     selectedId = new List<Id>();
     selectedAccs = (List<SiteContracts__c>) standardController.getSelected();
     if(selectedAccs != null){
         for(SiteContracts__c act : selectedAccs){
             selectedId.add(act.id);    
         }
     }
     
     if(selectedAccs .size()>0){
      this.merch=getSelected();
     }
     //else
     //this.merch=getMerchandise();
    
   
    }

  public List<Schema.FieldSetMember> getFields() {
  
        
        return SObjectType.SiteContracts__c.FieldSets.Export_To_Excel.getFields();

    }

 

    /*private List<SiteContracts__c> getMerchandise() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM SiteContracts__c';
        system.debug('query====='+query);
         return Database.query(query);

    }*/
    
    private List<SiteContracts__c> getSelected() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM SiteContracts__c where Id IN :selectedId';
        
         return Database.query(query);

    }
 
}