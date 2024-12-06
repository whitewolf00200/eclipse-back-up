public with sharing class QRCodeProductController {

    public PageReference Cancel() {
        return new pageReference('/'+ProdId);
    }

    
    public Boolean First { get; set; }
    public Boolean Second{ get; set; }
    Public id ProdId;
    Public Integer PordLabelQty{get;set;}
    Public List<POLIWrapper> ProdLIST{get;set;}
    Public List<POLIWrapper> ProdWrapperList{get;set;}
    Public String URLString;
    Public String ProdName{get;set;}
    
    Public QRCodeProductController(){
        First =true;
        Second=false;
        ProdId=ApexPages.currentPage().getparameters().get('id');
        PordLabelQty=1;
        ProdLIST = new List<POLIWrapper>();
        ProdWrapperList = new List<POLIWrapper>(); 
                                              
        For(Product2 Prod :[SELECT Id,Name, ProductCode, Minimum_Stock__c, Min_Stock__c, Supplier_Code__c, Supplier_Product_Code__c, Maximum_stock_level__c FROM Product2 Where id=:ProdId] ){
            ProdName=Prod.Name;
            if(Prod.ProductCode!=null){
                
                URLString ='https://quickchart.io/qr/?chs=250x250&cht=qr&text='+Prod.ProductCode;
                //URLString ='https://chart.googleapis.com/chart?chs=250x250&cht=qr&chl='+Prod.ProductCode;
                system.debug('URLString '+URLString );
            }
            else
                URLString='No Supplier Code';
            ProdLIST.add(new POLIWrapper(URLString,Prod.Name,Prod.Supplier_Product_Code__c,Prod.ProductCode,Prod.Min_Stock__c,Prod.Maximum_stock_level__c));
        }
    }
    Public Class POLIWrapper{
        Public String URL{get;set;}
        Public String PrdouctName{get;set;}
        Public String SupplierCode{get;set;}
        Public String ProductCode{get;set;}
        Public Decimal MinStock{get;set;}
        Public Decimal MaxStock{get;set;}
       
        
        
        
        
        Public POLIWrapper(String URL,String PrdouctName,String SupplierCode,String ProductCode,Decimal min,Decimal max){
            this.URL=URL;
            this.PrdouctName=PrdouctName;
            this.SupplierCode=SupplierCode;
            this.ProductCode=ProductCode;
            this.MinStock=min;
            this.MaxStock=max;
                   }
        
    }
    
    // Determines what kind of rendering to use for the page request
    public String renderingService { get; private set; }
    
    // Allow the page to set the PDF file name
    public String renderedFileName { 
        get; 
        set { renderedFileName = this.sanitizeFileName(value); }
    }
    // Rendered content MIME type, used to affect HTTP response
    public String renderedContentType {
        get {
            String renderedContentType = 'text/html'; // the default
            
            if( ! this.renderingAsHtml() ) {
                // Provides a MIME type for a PDF document 
                renderedContentType = 'application/pdf';
                
                // Add a file name for the PDF file
               
            }
            
            return renderedContentType;
        }
    }
    
    // Are we rendering to HTML or PDF?
    public Boolean renderingAsHtml() {
        return ( (renderingService == null) || 
                ( ! renderingService.startsWith('PDF')) );
    }
    
    // Action method to save (or "print") to PDF
    public PageReference saveToPdf() {
        for(POLIWrapper Prod: ProdLIST){
            for(Integer i=0; i<PordLabelQty;i++){
               ProdWrapperList.add(new POLIWrapper(Prod.URL,Prod.PrdouctName,Prod.SupplierCode,Prod.ProductCode,Prod.MinStock,Prod.MaxStock)); 
                system.debug('ProdWrapperList>>>'+ProdWrapperList);
                 system.debug('Prod.PrdouctName>>>'+Prod.PrdouctName);

            }}
        try{
            //update ProdLISTs;
        }Catch(Exception e){
            
        }
        Second=true;
        first=false;
        renderingService = 'PDF';
        return null;
    }
    
    // Private helper -- basic, conservative santization
    private String sanitizeFileName(String unsafeName) {
        String allowedCharacters = '0-9a-zA-Z-_.';
        String sanitizedName = 
            unsafeName.replaceAll('[^' + allowedCharacters + ']', '');
        // You might also want to check filename length, 
        // that the filename ends in '.pdf', etc.
        return(sanitizedName);
    }
}