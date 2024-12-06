global class AcknowledgementComponentController {
//global String poNo{get; set;}
global String poId{get; set;}
global Map<String, String> prodCounts{get; set;}
global List<String> prods{get; set;}


public String poNo;
public String getpoNo(){return poNo; }
public void setpoNo(String po) {
    poNo = po;
    System.debug('pooo==='+poNo);
    AcknowledgementComponentController();
}
 
    global void AcknowledgementComponentController() {
        poId=ApexPages.currentPage().getParameters().get('id');
        System.debug('pooo==='+poId);
        prodCounts=new Map<String, String>();
        prods=new List<String>();
        for(AggregateResult ag:[select Product2__c prod, count(Id) cnt from Inventory_transaction__c where Purchase_Order__c=:poNo group by Product2__c]){
            prodCounts.put(String.ValueOf(ag.get('prod')),String.ValueOf(ag.get('cnt')));
            prods.add(String.ValueOf(ag.get('prod')));   
                  
        }
        System.debug('poNopc==='+prodCounts);
        System.debug('poNoprdsa==='+prods);
    }        
}