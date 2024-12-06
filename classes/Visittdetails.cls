public class Visittdetails{
public List<Visits__c> merch{get;set;}
private ApexPages.StandardSetController standardController;
public List<Id> selectedId;
public List<Visits__c> selectedAccs;

 public Visittdetails(ApexPages.StandardSetController controller) { 
     standardController=controller;
     merch=new List<Visits__c>();
     selectedId = new List<Id>();
     selectedAccs = (List<Visits__c>) standardController.getSelected();
     if(selectedAccs != null){
         for(Visits__c act : selectedAccs){
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
  
        
        return SObjectType.Visits__c.FieldSets.Export_To_Excel.getFields();

    }

 

    /*private List<Visits__c> getMerchandise() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Visits__c';
        system.debug('query====='+query);
         return Database.query(query);

    }*/
    
    private List<Visits__c> getSelected() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Visits__c where Id IN :selectedId';
        
         return Database.query(query);

    }
 
}