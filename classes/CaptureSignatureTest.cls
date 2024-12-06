@istest(seeAlldata=true)
private class CaptureSignatureTest {

    public static testMethod void noParams() {
        CaptureSignature cs = new CaptureSignature();
        
        list<SelectOption> testOption = cs.getOption();
    }
    
    public static testMethod void param1() {
        PageReference pageRef = Page.Capture_Signature;
        Map<String, String> params = pageRef.getParameters();
        
        params.put('objecttype', 'Contact');
        
        Test.setCurrentPage(pageRef);
        CaptureSignature cs = new CaptureSignature();
        cs.printedName='Test';
    }

    public static testMethod void param2() {
        Contact c = new Contact(firstName = 'Joe', lastName = 'Bloggs');
        
        insert c;
        
        PageReference pageRef = Page.Capture_Signature;
        Map<String, String> params = pageRef.getParameters();
        
        params.put('objecttype', 'Contact');
        params.put('id', c.id);
        
        Test.setCurrentPage(pageRef);
        CaptureSignature cs = new CaptureSignature();
    }
    public static testMethod void param3() {
        Contact c = new Contact(firstName = 'Joe', lastName = 'Bloggs');
        
        insert c;
        
        PageReference pageRef = Page.Capture_Signature;
        Map<String, String> params = pageRef.getParameters();
        
        params.put('objecttype', 'Contact');
        params.put('id', c.id);
        params.put('targetRTField', 'rtf');
        
        Test.setCurrentPage(pageRef);
        CaptureSignature cs = new CaptureSignature();
        cs.printedName='Test';
    }
    public static testMethod void param4() {
        Contact c = new Contact(firstName = 'Joe', lastName = 'Bloggs');
        
        insert c;
        
        PageReference pageRef = Page.Capture_Signature;
        Map<String, String> params = pageRef.getParameters();
        
        params.put('objecttype', 'Contact');
        params.put('id', c.id);
        params.put('targetRTField', 'rtf');
        params.put('targetPrintField', 'tpf');
        
        Test.setCurrentPage(pageRef);
        CaptureSignature cs = new CaptureSignature();
    }

    public static testMethod void invalidId() {
        Contact c = new Contact(firstName = 'Joe', lastName = 'Bloggs');
        
        insert c;
        
        PageReference pageRef = Page.Capture_Signature;
        Map<String, String> params = pageRef.getParameters();
        
        params.put('objecttype', 'Contact');
        params.put('id', ('' + c.id).substring(0, 14) + 'A');
        params.put('targetRTField', 'rtf');
        params.put('targetPrintField', 'tpf');
        
        Test.setCurrentPage(pageRef);
        CaptureSignature cs = new CaptureSignature();
        cs.printedName='Test';
    }
    public static testMethod void badType() {
        Contact c = new Contact(firstName = 'Joe', lastName = 'Bloggs');
        
        insert c;
        
        PageReference pageRef = Page.Capture_Signature;
        Map<String, String> params = pageRef.getParameters();
        
        params.put('objecttype', 'NoSuchType');
        params.put('id', ('' + c.id).substring(0, 14) + 'A');
        params.put('targetRTField', 'rtf');
        params.put('targetPrintField', 'tpf');
        
        Test.setCurrentPage(pageRef);
        CaptureSignature cs = new CaptureSignature();
        cs.printedName='Test';
    }

    public static testMethod void working() {
        Contact c = new Contact(firstName = 'Joe', lastName = 'Bloggs');
        
        insert c;
        
        PageReference pageRef = Page.Capture_Signature;
        Map<String, String> params = pageRef.getParameters();
        
        params.put('objecttype', 'Contact');
        params.put('id', c.id);
        params.put('targetRTField', 'rtf');
        params.put('targetPrintField', 'tpf');
        
        Test.setCurrentPage(pageRef);
        CaptureSignature cs = new CaptureSignature();
        cs.printedName='Test';
        
        cs.getName();
        
        try {
            cs.getViewFeedback();
            cs.checkUpdate();
            cs.saveSignature();
            
        } catch(Exception e) {
            // Not sure how to test this properly... no guarantee of an RT field
        }
    }
}