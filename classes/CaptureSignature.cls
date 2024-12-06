public with sharing class CaptureSignature {
    
    public String technicianName { get; set; }
    
    private Boolean isCustomerCheck;
    
    public String reactiveTechnicianName { get; set; }
    
    private String objectType;
    
    private String objectId;
    public boolean isSf1check{get;set;}
    private String targetRTField;
    
    public String targetPrintField {get; set;}
    public String buttonType {get; set;}
    public String TechnicianPrintName{get; set;}

    private sObject obj;
    
    public transient String printedName {get; set;}
    
    public transient String imageBase64 {get; set;}
    
    public boolean pos{get;set;}
    public boolean tec{get;set;}
    public String feedbackYes{get;set;}
    public String feedbackNo{get;set;}
    public String feedbackNot{get;set;}
     
    
    @TestVisible private String serviceRating{get;set;}
    @TestVisible private String serviceFeedback{get;set;}
    public String CPosition{get;set;}
    public String TPosition{get;set;} 
    public String customerFeedback{get;set;}
    public String Posi{get;set;}
    public String TPosi{get;set;}
    Public Date SignDate{get;set;}
    public Integer selectedOption{get;set;}
    
    

    public list<SelectOption> getOption()
{
    list<SelectOption> options = new list<SelectOption>();
    options.add(new SelectOption('1', ''));
    options.add(new SelectOption('2', ''));
     options.add(new SelectOption('3', ''));
     
    return options;
}

public static Boolean isSF1(){
    if(String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
        String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
        ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
        (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone') )
    ){
        return true;
    }else{
        return false;
    }
}
    public CaptureSignature() {
        try{
        
         isSf1check=isSF1();
         
         Map<String, id> documentList=new Map<string, id>();
                                    
        for(Document doc:[select id,name from document where Name like 'Feadback%' ]){
            documentList.put(doc.name,doc.id);
        }

        if(documentList.size()>0)
        {
          
          feedbackYes ='/servlet/servlet.FileDownload?file='+documentList.get('FeadbackYes');
          feedbackNo ='/servlet/servlet.FileDownload?file='+ documentList.get('FeadbackNo');
          feedbackNot='/servlet/servlet.FileDownload?file='+ documentList.get('FeadbackNA');

        }
        system.debug('<<<documentList>>'+documentList);
    
            String CustomerCheck = ApexPages.currentPage().getParameters().get('targetRTField');
            TechnicianPrintName = ApexPages.currentPage().getParameters().get('TechniciansPrint');
            if((CustomerCheck  == 'Customer_s_Signature__c') || (CustomerCheck == 'Customer_s_Name__c')){
                isCustomerCheck = true;
            }
            else if((CustomerCheck   == 'Engineer_s_Signature__c') || ( CustomerCheck == 'Technician_Signature__c')){
                isCustomerCheck  = false;
            }
            if(isCustomerCheck == false){
                technicianName =[SELECT Engineer__r.Name from Engineer_Checklist__c where id=:ApexPages.currentPage().getParameters().get('id')].Engineer__r.Name;
            }
        }catch(Exception e ){
            if(isCustomerCheck==false){
                try{
                technicianName = [SELECT Technician__r.Name from Service_Sheet_STD__c where id=:ApexPages.currentPage().getParameters().get('id')].Technician__r.Name;              
               }
               catch(Exception ex){
               try{
               technicianName = [SELECT Technician__r.Name from Mechanical_Service_Sheet__c where id=:ApexPages.currentPage().getParameters().get('id')].Technician__r.Name;
               }
               catch(Exception exc){
               if(!Test.isrunningtest())
           //    technicianName = [SELECT Technician__r.Name from Project_Sheet__c where id=:ApexPages.currentPage().getParameters().get('id')].Technician__r.Name;
               {}
               }
               }
            // technicianName = [SELECT Technician__r.Name from Project_Sheet__c where id=:ApexPages.currentPage().getParameters().get('id')].Technician__r.Name;               }
            }System.debug(e.getMessage()+'#####');
        }
        Map<String, String> params = ApexPages.currentPage().getParameters();
        
        system.debug(params);
        
        objectType = params.get('objecttype');
        system.debug('ObjectType========'+ObjectType);
        if(objectType == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       'ObjectType URL parameter is required'));
            return;
        }
        
        objectId = params.get('id');
        if(objectId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       'id URL parameter is required'));
            return;
        }
        
        targetRTField = params.get('targetRTField');
        if(targetRTField == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       'TargetRTField URL parameter is required'));
            return;
        }
        
        targetPrintField = params.get('targetPrintField');
        System.debug('### CaptureSignature - targetPrintField: ' + params.get('targetPrintField'));
        if(targetPrintField == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       'TargetPrintField URL parameter is required'));
            return;
        }
        
        System.debug('### CaptureSignature - targetPrintField: ' + targetPrintField);
        
        String query = 'SELECT id, name FROM ' + objectType + ' WHERE id = \'' + objectId + '\'';
        system.debug('query=' + query);
        
        List<SObject> results;
        
        try {
            results = Database.query(query);
        } catch(Exception e) {
            ApexPages.addMessages(e);
            return;
        }
        
        if(results.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       'No results found for query "' + query + '"'));
        } else {
            obj = results[0];
            system.debug('obj=============='+obj );
        }
        
        buttonType = params.get('buttontype');
        getPositionn();
        getTPositionn();
    }
    
    public void checkUpdate() {
        if(obj != null) {
            Savepoint sp = Database.setSavepoint();
            
            try {
                update obj;
            } catch(Exception e) {
                ApexPages.addMessages(e);    
            }
            
            Database.rollback(sp);
        }
    }
    
    public String getName() {
        if(obj != null) {
            return '' + obj.get('name');
        } else {
            return '';
        }
    }
    
    public PageReference saveSignature() {
        system.debug('printedName=' + printedName);        
        system.debug('selectedOption =' + selectedOption );        
        system.debug('imageBase64=' + imageBase64);
        system.debug('<<<<type>>>>'+obj );
        Integer Namelen = printedName.length();
        system.debug('Name length'+Namelen );
        
         if(Namelen<2) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,
                                                       'Print your Name must be required with the format of initial/last name or first name/last name.'));
        } 
        
        
        if(obj != null) {
            serviceRating = 'Rating__c';
            serviceFeedback = 'Feedback_Comments__c';
            obj.put(targetRTField, '<img src="' + imageBase64 + '" alt="' + printedName + '"/>');
            obj.put(targetPrintField, printedName);
            
            
           // String buttonType = ApexPages.currentPage().getParameters().get('buttontype');
            
            
             if(buttonType=='CustomerSignature' && objectType =='Engineer_Checklist__c'){
                 obj.put(serviceFeedback , customerFeedback);
                 if(selectedOption == 1){ obj.put(serviceRating, 'Satisfied');  }
                 if(selectedOption == 2){ obj.put(serviceRating, 'Neutral');    }
             if(selectedOption == 3 ){obj.put(serviceRating, 'Dissatisfied');}
            }
            
              if(buttonType=='CustomerSignature' && objectType =='SalesOrder__c'){   
               CPosition='Position__c'; 
               SignDate=System.today();
              obj.put('Customer_Signed_Date__c',SignDate);
              obj.put(CPosition,Posi);
               }
              
              if(buttonType!='CustomerSignature' && objectType =='SalesOrder__c'){ 
              TPosition='Technician_Position__c';  
              SignDate=System.today();
              obj.put('Technician_Signed_Date__c',SignDate);           
               obj.put(TPosition,TPosi); 
             
              }
        }
        
        try {
            update obj;
            system.debug('obj======='+obj);
        } catch(Exception e) {
            ApexPages.addMessages(e);    
        }
        
        if(ApexPages.hasMessages()) {
            return null;
        } else {
             pagereference p=new ApexPages.StandardController(obj).view();
             p.setRedirect(true);
             return p;
        }
    }
    

 
     public boolean getViewFeedback(){
     boolean isVis;     
    // String objectname = ApexPages.currentPage().getParameters().get('ObjectType');
     //String buttonType = ApexPages.currentPage().getParameters().get('buttontype');
     
     if(buttonType == 'CustomerSignature' &&  ObjectType=='Engineer_Checklist__c') {
      isVis  = true;
     }
     else
      isVis = false;
    return isVis;
}

 public boolean getPositionn(){

 if(ObjectType=='SalesOrder__c' && buttonType == 'CustomerSignature'){
 pos=true;
 }
 else
 pos=false;
 return pos;
 } 
 
 public boolean getTPositionn(){
 boolean tec;
 if(ObjectType=='SalesOrder__c' && buttonType != 'CustomerSignature'){
 tec=true;
 }
 else
 tec=false;
 return tec;
 }   
}