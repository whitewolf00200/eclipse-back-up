public class TransferpartsHomeclass {
    Public id currentid{get;set;}
    
    Public TransferpartsHomeclass(ApexPages.StandardController controller){
        currentid=ApexPages.currentPage().getParameters().get('id');
    }

  public PageReference returnPage()

{

    return new PageReference('/apex/BulkpartsTransfer?id='+currentid);

} 
     public PageReference returnPageqr()

{

    return new PageReference('/apex/TransferPartsAdvanced?id='+currentid);

} 
}