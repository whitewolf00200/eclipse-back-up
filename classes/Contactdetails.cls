public class Contactdetails{
public List<Contact > merch{get;set;}
private ApexPages.StandardSetController standardController;
public List<Id> selectedId;
public List<Contact > selectedAccs;

 public Contactdetails(ApexPages.StandardSetController controller) { 
     standardController=controller;
     merch=new List<Contact>();
     selectedId = new List<Id>();
     selectedAccs = (List<Contact >) standardController.getSelected();
     if(selectedAccs != null){
         for(Contact act : selectedAccs){
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
  
        
        return SObjectType.Contact.FieldSets.Export.getFields();

    }

 

   /* private List<Contact > getMerchandise() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Contact';
        system.debug('query====='+query);
         return Database.query(query);

    }*/
    
    private List<Contact> getSelected() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Contact where Id IN :selectedId';
        
         return Database.query(query);

    }
 
}