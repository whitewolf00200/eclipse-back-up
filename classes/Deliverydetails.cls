public class Deliverydetails{
public List<Delivery_Note__c> merch{get;set;}
private ApexPages.StandardSetController standardController;
public List<Id> selectedId;
public List<Delivery_Note__c> selectedAccs;

 public Deliverydetails(ApexPages.StandardSetController controller) { 
     standardController=controller;
     merch=new List<Delivery_Note__c>();
     selectedId = new List<Id>();
     selectedAccs = (List<Delivery_Note__c>) standardController.getSelected();
     if(selectedAccs != null){
         for(Delivery_Note__c act : selectedAccs){
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
  
        
        return SObjectType.Delivery_Note__c.FieldSets.Export_To_Excel.getFields();

    }

 

   /* private List<Delivery_Note__c> getMerchandise() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Delivery_Note__c';
        system.debug('query====='+query);
         return Database.query(query);

    }*/
    
    private List<Delivery_Note__c> getSelected() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Delivery_Note__c where Id IN :selectedId';
        
         return Database.query(query);

    }
 
}