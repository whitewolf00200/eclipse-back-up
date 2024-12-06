public class Projectdetails{
public List<Project__c> merch{get;set;}
private ApexPages.StandardSetController standardController;
public List<Id> selectedId;
public List<Project__c> selectedAccs;

 public Projectdetails(ApexPages.StandardSetController controller) { 
     standardController=controller;
     merch=new List<Project__c>();
     selectedId = new List<Id>();
     selectedAccs = (List<Project__c>) standardController.getSelected();
     if(selectedAccs != null){
         for(Project__c act : selectedAccs){
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
  
        
        return SObjectType.Project__c.FieldSets.Export_To_Excel.getFields();

    }

 

    /*private List<Project__c> getMerchandise() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Project__c';
        system.debug('query====='+query);
         return Database.query(query);

    }*/
    
    private List<Project__c> getSelected() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Project__c where Id IN :selectedId';
        
         return Database.query(query);

    }
 
}