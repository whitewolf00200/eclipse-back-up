public class mechSFCertificateController {

    public mechSFCertificateController(ApexPages.StandardController controller) {

    }
    public String mSSId {get;set;}
    public class SystemLocationWrapper
    {
        public String systemLocation{get;set;}
        public String noOfLocations{get;set;}
        public String capacity{get;set;}
        public String agentFill{get;set;}
        Public String testDate{get;set;}
    }
    Mechanical_Service_Sheet__c mech = [select Id,System_Location__c,No_of_Cycles__c,Capacity__c,Agent_Fill__c,Test_Date__c  from Mechanical_Service_Sheet__c where Id=:ApexPages.currentPage().getParameters().get('id')];
    List<SystemLocationWrapper> liSystemLocation = new List<SystemLocationWrapper>();
    public List<SystemLocationWrapper> getSystemLocation()
    {
        if(liSystemLocation.isEmpty())
        {
          if(mech.System_Location__c!=null)
            {
                List<String> sysLoc,noCyls,capcity,agntfl,tstdt;
                sysLoc=mech.System_Location__c.split(';',-1);
                for(Integer iterator=0;iterator<sysLoc.size()-1;iterator++)
                {
                    SystemLocationWrapper instance = new SystemLocationWrapper();
                    instance.systemLocation = sysLoc[iterator]; 
                    if(mech.No_of_Cycles__c!=null)
                    {
                        noCyls= mech.No_of_Cycles__c.split(';',-1);
                        instance.noOfLocations = noCyls[iterator];
                    }
                    else
                    {
                        instance.noOfLocations=''; 
                    }
                    if(mech.Capacity__c!=null)
                    {
                        capcity= mech.Capacity__c.split(';',-1);
                        instance.capacity= capcity[iterator];
                    }
                    else
                    {
                        instance.capacity=''; 
                    }
                    if(mech.Agent_Fill__c!=null)
                    {
                        agntfl= mech.Agent_Fill__c.split(';',-1);
                        instance.agentFill= agntfl[iterator];
                    }
                    else
                    {
                        instance.agentFill=''; 
                    }
                    if(mech.Test_Date__c!=null)
                    {
                        tstdt= mech.Test_Date__c.split(';',-1);
                        instance.testDate= tstdt[iterator];
                    }
                    else
                    {
                        instance.testDate=''; 
                    }
                    liSystemLocation.add(instance);
                }
                
                
            }
        }
        return liSystemLocation;
    }
}