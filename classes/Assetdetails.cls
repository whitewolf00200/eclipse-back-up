public class Assetdetails{
public List<Asset> merch{get;set;}
private ApexPages.StandardSetController standardController;
public List<Id> selectedId;
public List<Asset> selectedAccs;

 public Assetdetails(ApexPages.StandardSetController controller) { 
     standardController=controller;
     merch=new List<Asset>();
     selectedId = new List<Id>();
     selectedAccs = (List<Asset>) standardController.getSelected();
     if(selectedAccs != null){
         for(Asset act : selectedAccs){
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
  
        
        return SObjectType.Asset.FieldSets.Export.getFields();

    }

 

   /* private List<Asset> getMerchandise() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Asset';
        system.debug('query====='+query);
         return Database.query(query);

    }*/
    
    private List<Asset> getSelected() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Asset where Id IN :selectedId';
        
         return Database.query(query);

    }
 
}