/*============================================================================================================
*Class Name     : ProductQuoteController
*Description    : To see what Quote have been made for a particular product through ProductQuote Visualforce page
*Company        : Merfantz Technologies Pvt Ltd
*Date           : 12th September, 2021
*Version        : 5.0
*============================================================================================================*/
Public class ProductQuoteController{
    public Id pid;
    public List<QuoteLineItem> quoteLine{get;set;}
    public ProductQuoteController(ApexPages.StandardController controller){
        pId=ApexPages.currentPage().getParameters().get('id');
        quoteLine=new List<QuoteLineItem>();
        quoteLine=[Select Quote.QuoteNumber,Quote.CreatedDate,Quote.name,Quote.Account.name,Quote.Opportunity.name,Quote.Opportunity.StageName,Cost_Price__c FROM QuoteLineItem where Product2Id=:pid AND (NOT Quote.Opportunity.StageName='Closed Won') AND (NOT Quote.Opportunity.StageName='Closed Lost') ORDER BY Quote.CreatedDate DESC];
        }
     }