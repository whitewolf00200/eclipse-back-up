public class XeroInvoice {

    public String Type; //ACCREC
    public String InvoiceID;   
    public String InvoiceNumber;    //INV-0002
    public XeroContact Contact;
    public String DateString;   //2015-12-01T00:00:00
    public String DueDateString;    //2015-12-31T00:00:00
    public String Status;   //DRAFT
    public String Reference;  
    public LineItem[] LineItems;
    public Decimal AmountDue;   //600
    public Decimal AmountPaid;  //0
    public String ExpectedPaymentDateString;
    public String PlannedPaymentDate;
    public String FullyPaidOnDate;
    public Decimal AmountCredited;
    public Boolean SentToContact;
    /*public Payment[] Payments;
    public CreditNote[] CreditNotes;
    public PrePayment[] Prepayments;
    public Overpayment[] Overpayments;
    public Decimal CurrencyRate;    //1
    public Boolean HasErrors;
    public Boolean IsDiscounted;
    public String LineAmountTypes;  //Exclusive

    public Decimal SubTotal;    //600
    public Decimal TotalTax;    //0
    public Decimal Total;   //600
    public String UpdatedDateUTC;   ///Date(1447665863507+1300)/
    public String CurrencyCode; 
    public cls_Warnings[] Warnings;

    class Payment {
    }
    class CreditNote {
    }
    class PrePayment {
    }
    class Overpayment {
    }
    class cls_ContactGroups {
    }
    class cls_SalesTrackingCategories {
    }
    class cls_PurchasesTrackingCategories {
    }
    class cls_PaymentTerms {
        public cls_Bills Bills;
    }
    class cls_Bills {
        public Integer Day; 
        public String Type;
    }
    class cls_ContactPersons {
    }*/
    
    class Payment {
        public decimal Amount;
    }
    
    public class LineItem{
  
        public String ItemCode;
        public String Description; 
        public Decimal UnitAmount; 
        public Decimal LineAmount; 
          
        /*public Decimal TaxAmount;  
        public String TaxType;
        public String AccountCode;  
        public cls_Tracking[] Tracking;
        public Decimal Quantity;   
        public String LineItemID;  
        public cls_ValidationErrors[] ValidationErrors;
        */
        public LineItem(String ItemCode,String Description,Decimal UnitAmount,Decimal LineAmount){
            this.ItemCode=ItemCode;
            this.Description=Description;
            this.UnitAmount=UnitAmount;
            this.LineAmount=LineAmount;
        }
    }
    class cls_Tracking {
    }
    class cls_ValidationErrors {
    }
    class cls_Warnings {
    }
    
}