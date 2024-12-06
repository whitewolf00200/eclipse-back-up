public class PurchaseOrderController{
public PurchaseOrderController(ApexPages.StandardController controller){
                         
         Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename=Eclipse Dental Purchase Order.pdf');
    }
}