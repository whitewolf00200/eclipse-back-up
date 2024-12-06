@isTest(SeeAllData=true)
public class ComplaintTriggerHandlerTest{
    @isTest public static void passComplaintsTest(){
        Test.StartTest();
        Account newAccount=new Account(Name='Test Account');
        insert newAccount;  
        list<Complaints__c> compList =new list<Complaints__c>();
        Complaints__c comp=new Complaints__c(Customer_Site__c=newAccount.id);
        insert comp;
        list<Complaints__c> complaintList=[SELECT Id,Customer_Site__c,Department__c,Recorded_By__c,Complaint_Details__c,
                                            Reported_to_Manager__c,Passed_To_Email__c,Passed_To__c 
                                             FROM Complaints__c WHERE Customer_Site__c!=NULL  Limit 1];
        Complaints__c newComp;
        for(Complaints__c oldComp:complaintList){
          newComp=oldComp.clone();
          newComp.Customer_Site__c=newAccount.id;
          newComp.Passed_To_Email__c='testing@puthuvannam.com';
          newComp.Department__c='Service';
          newComp.Complaint_Details__c='Test Service';
          newComp.Recorded_By__c='Tester';
          newComp.Reported_to_Manager__c='No';
          compList.add(newComp);
        }
        insert compList;
         for(Complaints__c newComplaint:compList){
            newComplaint.Passed_To_Email__c='test@puthuvannam.com';
        }
        update compList;
        Test.StopTest(); 
   
    }
    }