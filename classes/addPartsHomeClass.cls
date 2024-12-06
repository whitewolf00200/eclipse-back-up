public class addPartsHomeClass {
 Public id currentid{get;set;}
    
    Public addPartsHomeClass(ApexPages.StandardController controller){
        currentid=ApexPages.currentPage().getParameters().get('id');
    }

  public PageReference returnPage()

{

    return new PageReference('/apex/addPartsAdvancePage?id='+currentid);

} 
     public PageReference returnPageqr()

{

    return new PageReference('/apex/SSScanner?id='+currentid);

} 
}