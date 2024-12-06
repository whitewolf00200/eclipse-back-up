global class ConvertLeadToOpp
{
    WebService static String Convert(String leadId)
    {
        System.debug('This is it');
        // Lead, Account and Opp Record Types are queried.
        Lead instanceOfLead = [select Id,Name,Company,isConverted from Lead where Id=:leadId];
        RecordType recordtyp = [select Id,Name from RecordType where SobjectType = 'Opportunity' and Name = 'Sales'];
        Account instanceOfAccount = [select Id from Account where Name='Amsec' LIMIT 1];  //Added LIMIT by Puthuvannam on 31st May, 2014
        System.debug('This is it 2 ' + instanceOfLead.id);
        //Opportunity Instance as required gets created.       
        
        
        
        //Lead attribute - isConverted needs to go to true, but its not a writable field hence convert lead and attach it to 
        //Amsec account
        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(instanceOfLead.id);
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        
        lc.setAccountId(instanceOfAccount.id);
        lc.setConvertedStatus(convertStatus.MasterLabel);
        
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
        
        Id delConId = [select ConvertedContactId from Lead where Id =:instanceOfLead.id].ConvertedContactId ;
        Contact newConInstance = [select Id from Contact where Id=:delConId];
        database.delete(newConInstance);
        
        Id upOppId = [select ConvertedOpportunityId from Lead where Id =:instanceOfLead.id].ConvertedOpportunityId ;
        Opportunity newInstance = [select CloseDate,StageName,RecordTypeId,Amsec__c,Id from Opportunity where Id=:upOppId];
        
        newInstance.AccountId = instanceOfAccount.Id;
        newInstance.Name = '~Amsec- '+instanceOfLead.Company;
        newInstance.Amsec__c = true;
        newInstance.RecordTypeId = recordtyp.id;
        newInstance.StageName = 'Proposal/Price Quote';
        newInstance.CloseDate = (system.today()).addDays(30);
        database.update(newInstance);
        
        System.debug('This is it 4 '+ upOppId);
        return 'Success';
    }
}