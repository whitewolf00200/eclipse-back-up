public class XeroContact {

    public String ContactID;
    public String ContactStatus;
    public String Name;
    public String FirstName;
    public String LastName;
    public String EmailAddress;
    public String BankAccountDetails;
    public String SkypeUserName;
    public XeroAddress Address=new XeroAddress() ;
    public XeroPhone[] Phones;
    //public String UpdatedDateUTC;
    public ContactGroups[] ContactGroups;
    public Boolean IsSupplier;
    public Boolean IsCustomer;
    public String DefaultCurrency;
    public Balances Balances;
    public ContactPersons[] ContactPersons;
    public Boolean HasAttachments;
    public Attachments[] Attachments;
    public Boolean HasValidationErrors;
    public string ContactNumber;
    public string AccountNumber;
    public string City;
    public string PostalCode;
    public string Country;
    
    
    public class ContactGroups {
    }

    public class ContactPersons {

        public String FirstName;
        public String LastName;
        public String EmailAddress;
        public Boolean IncludeInEmails;
    }

    public class Balances {

        public AccountsPayable AccountsPayable;
        public AccountsReceivable AccountsReceivable;
    }

    public class AccountsPayable {
        public Decimal Overdue; 
        public Decimal Outstanding; 
    }

    public class AccountsReceivable {
        public Decimal Overdue; 
        public Decimal Outstanding;
    }

    public class Attachments {

        public String AttachmentID;
        public String FileName;
        public String Url;
        public String MimeType;
        public Integer ContentLength;
    }
}