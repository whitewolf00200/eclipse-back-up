global class UpdateCustomerGroupsBatch implements Database.Batchable<sObject> 
{
set<id> Opportunityids = new set<id>();
    
    global UpdateCustomerGroupsBatch()
    {
        for(Opportunity opp: [SELECT AccountId FROM Opportunity WHERE Invoice_Date__c != null])
        {
            Opportunityids.add(opp.AccountId);
        }
    }

    global List<Account> start(Database.BatchableContext context) {
        
        List<Account> Accounts = new List<Account>();
        Accounts.addAll([SELECT Id, Customer_Group__c, (SELECT Id, Invoice_Date__c FROM Opportunities) FROM Account WHERE Id=:Opportunityids]);
        return Accounts;
    }

    global void execute(Database.BatchableContext context, List<Account> scope)
    {
        // Calculate date ranges
        Date last24Months = System.today().addMonths(-24);
        Date last60Months = System.today().addMonths(-60);

        List<Account> accountsToUpdate = new List<Account>();

        for (Account acc : scope) {
            Boolean hasRecentActivity = false;
            Boolean hasLapsedActivity = false;
            Boolean hasNotActivity = false;
            Boolean Existing = false;

            for (Opportunity opp : acc.Opportunities) {
                if (opp.Invoice_Date__c >= last24Months) {
                    hasRecentActivity = true;
                } else if (opp.Invoice_Date__c >= last60Months) {
                    hasLapsedActivity = true;
                } else if (opp.Invoice_Date__c < last60Months) {
                    hasNotActivity = true;
                }
            }

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

        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }

    global void finish(Database.BatchableContext context) {

    }
}