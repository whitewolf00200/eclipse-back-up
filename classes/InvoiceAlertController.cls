Public class InvoiceAlertController{
     
      public String Oid;
         public InvoiceAlertController(ApexPages.StandardController controller) {
          Oid=ApexPages.CurrentPage().getParameters().get('id');
          for( Opportunity opp:[Select id,name,Invoice_Sent__c from Opportunity where id=:Oid]){
            if(opp.Invoice_Sent__c ){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,' This Invoice was sent to client'));
            }
          
          }
         
         }
        
    }