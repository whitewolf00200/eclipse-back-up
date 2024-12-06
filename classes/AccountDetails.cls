public class AccountDetails{
public List<Account> merch{get;set;}
private ApexPages.StandardSetController standardController;
public List<Id> selectedId;
public List<Account> selectedAccs;
//public string callfunc{get;set;}

 public AccountDetails(ApexPages.StandardSetController controller) { 
     standardController=controller;
     merch=new List<Account>();
     selectedId = new List<Id>();
     selectedAccs = (List<Account >) standardController.getSelected();
     if(selectedAccs != null){
         for(Account act : selectedAccs){
             selectedId.add(act.id);    
         }
     }
     
     if(selectedAccs .size()>0){
      this.merch=getSelected();
     }
    // else{
    // callfunc='<script> func(); </script>';
    // }
    }

  public List<Schema.FieldSetMember> getFields() {
  
        
        return SObjectType.Account.FieldSets.export.getFields();

    }

 

   /* private List<Account> getMerchandise() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Account';
        system.debug('query====='+query);
         return Database.query(query);

    }*/
    
    private List<Account> getSelected() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Account where Id IN :selectedId';
        
         return Database.query(query);

    }
 
}