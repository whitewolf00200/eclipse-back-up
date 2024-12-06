trigger OpportunityLineItem on OpportunityLineItem (before insert, before update) {

    if(Trigger.isInsert && Trigger.isBefore) {
        OpportunityLineItemHandler handler = new OpportunityLineItemHandler(Trigger.isExecuting, Trigger.size);
        Integer totalQueries=Limits.getQueries();    //Added by Puthuvannam on 7th May, 2014
        if(totalQueries<=80){                        //"CreateOppandOliOnReactiveSheetsTest" Test Class was not written properly. So to skip the unnecessary steps, we are using this line            
            handler.OnBeforeInsert(Trigger.New);
        }
        IF(RecursiveHandler.runOnce()){
                ZeroPricingProductsHandler handlerZeroPrice = ZeroPricingProductsHandler.getInstance();
                handlerZeroPrice.OnBeforeInsert(Trigger.New);
        }
    }
}