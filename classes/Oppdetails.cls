public class Oppdetails{
public List<Opportunity > merch{get;set;}
private ApexPages.StandardSetController standardController;
public List<Id> selectedId;
public List<Opportunity > selectedAccs;

 public Oppdetails(ApexPages.StandardSetController controller) { 
     standardController=controller;
     merch=new List<Opportunity >();
     selectedId = new List<Id>();
     selectedAccs = (List<Opportunity >) standardController.getSelected();
     if(selectedAccs != null){
         for(Opportunity act : selectedAccs){
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
  
        
        return SObjectType.Opportunity.FieldSets.Export.getFields();

    }

 

    /*private List<Opportunity > getMerchandise() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Opportunity ';
        system.debug('query====='+query);
         return Database.query(query);

    }*/
    
    private List<Opportunity > getSelected() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Opportunity where Id IN :selectedId';
        
         return Database.query(query);

    }
 
}