global class ScheduleUpdateCustomerGroups implements Schedulable {
    global void execute(SchedulableContext ctx) {
        UpdateCustomerGroup();
    }
    
    public void UpdateCustomerGroup() {
        
        Date last24Months = System.today().addMonths(-24);
        Date last60Months = System.today().addMonths(-60);
        
        List<Account> accountsToUpdate = new List<Account>();
        
        List<Account> accountsWithOpportunities = [
            SELECT Id, Customer_Group__c,
            (SELECT Id,Opportunity_Created_Date__c 
             FROM Opportunities 
             WHERE Opportunity_Created_Date__c != null AND (StageName = 'Sent' OR StageName = 'Moved to Invoice' OR StageName = 'Closed Won')
             ORDER BY CreatedDate DESC 
             LIMIT 1) 
            FROM Account 
            WHERE Id IN (SELECT AccountId 
                         FROM Opportunity 
                         WHERE Opportunity_Created_Date__c != null  AND (StageName = 'Sent' OR StageName = 'Moved to Invoice' OR StageName = 'Closed Won') )
        ];
        
        
        System.debug('Size of the list: ' + accountsWithOpportunities.size());
        System.debug('List of Accounts: ' + accountsWithOpportunities);
        
        for (Account acc : accountsWithOpportunities) {
            Boolean hasRecentActivity = false;
            Boolean hasLapsedActivity = false;
            Boolean hasNotActivity = false;
            Boolean Existing = false;
            
            for (Opportunity opp : acc.Opportunities) {
                if ( opp.Opportunity_Created_Date__c >= last24Months) {
                    hasRecentActivity = true;
                } else if (opp.Opportunity_Created_Date__c >= last60Months) {
                    hasLapsedActivity = true;
                } else if (opp.Opportunity_Created_Date__c < last60Months ) {
                    hasNotActivity = true;
                }
            }
            System.debug('Lapsed Customers' + acc.Customer_Group__c + acc.Id);
            
            if (hasRecentActivity && acc.Customer_Group__c != 'Existing Customers') {
                acc.Customer_Group__c = 'Existing Customers';
                Existing = true;
            } else if (hasLapsedActivity && acc.Customer_Group__c != 'Lapsed Customers') {
                acc.Customer_Group__c = 'Lapsed Customers';
                Existing = true;
            } else if (hasNotActivity && acc.Customer_Group__c != 'Not Customers') {
                acc.Customer_Group__c = 'Not Customers';
                Existing = true;
            }
            if (Existing) {
                accountsToUpdate.add(acc);
            }
        }
        for (Account acc : accountsToUpdate) {
            System.debug('Account Id: ' + acc.Id + ', Customer_Group__c: ' + acc.Customer_Group__c);
        }
        
        System.debug('Size of the list====: ' + accountsToUpdate.size());
        System.debug('account'+ accountsToUpdate );
        
        
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
    
}