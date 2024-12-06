public class ProductDetails{
public List<Product2> merch{get;set;}

 public ProductDetails(ApexPages.StandardSetController controller) { 
    
     merch=new List<Product2>();
     this.merch=getMerchandise();
    system.debug('merch====='+merch);
   
    }

  public List<Schema.FieldSetMember> getFields() {

        return SObjectType.Product2.FieldSets.Export.getFields();

    }

 

    private List<Product2 > getMerchandise() {

        String query = 'SELECT ';

        for(Schema.FieldSetMember f : this.getFields()) {

            query += f.getFieldPath() + ', ' ;

        }

        query += 'Id FROM Product2';
         return Database.query(query);

    }
 
}